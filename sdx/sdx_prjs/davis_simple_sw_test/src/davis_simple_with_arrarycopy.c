#include <libcaer/libcaer.h>
#include <libcaer/devices/davis.h>
#include <signal.h>
#include <stdatomic.h>
#include <stdio.h>

#ifdef __SDSCC__
#include "sds_lib.h"
#else
#define sds_alloc(x)(malloc(x))
#define sds_free(x)(free(x))
#endif

#define N 16
#define NUM_ITERATIONS N
typedef short data_t;

#pragma SDS data copy(a, b)
void array_copy(data_t a[N], data_t b[N])
{
     for(int i = 0; i < N; i++) {
          b[i] = a[i];
     }
}

#pragma SDS data zero_copy(a_zero, b_zero)
void array_zero_copy(data_t a_zero[N], data_t b_zero[N])
{
     for(int i = 0; i < N; i++) {
    	 b_zero[i] = a_zero[i];
     }
}

void arraycopy_sw(data_t *a, data_t *b)
{
     for(int i = 0; i < N; i++) {
          b[i] = a[i];
     }
}

int print_results(data_t A[N], data_t swOut[N], data_t hwOut[N], data_t hwOut_zero[N])
{
     int i;
     printf( "     A   : ");
     for (i = 0; i < N; i++)
          printf("%d", A[i]);
     printf( "\n(sw) A_cpy: ");
     for (i = 0; i < N; i++)
    	 printf("%d", swOut[i]);
     printf( "\n(hw) A_cpy: ");
     for (i = 0; i < N; i++)
    	 printf("%d", hwOut[i]);
     printf( "\n(hw_zero) A_cpy: ");
     for (i = 0; i < N; i++)
    	 printf("%d", hwOut_zero[i]);
     printf("\n");
     return 0;
}

int compare(data_t swOut[N], data_t hwOut[N])
{
     for (int i = 0; i < N; i++) {
          if (swOut[i] != hwOut[i]) {
               printf ("Values differ: swOut[%d] = %d, hwOut[%d] = %d\n", i, swOut[i], i, hwOut[i]);
               return -1;
          }
     }
     printf( "RESULTS MATCH\n\n");
     return 0;
}

static atomic_bool globalShutdown;

static void globalShutdownSignalHandler(int signal) {
	// Simply set the running flag to false on SIGTERM and SIGINT (CTRL+C) for global shutdown.
	if (signal == SIGTERM || signal == SIGINT) {
		atomic_store(&globalShutdown, true);
	}
}

static void usbShutdownHandler(void *ptr) {
	(void) (ptr); // UNUSED.

	atomic_store(&globalShutdown, true);
}

int main(void) {
// Install signal handler for global shutdown.
#if defined(_WIN32)
	if (signal(SIGTERM, &globalShutdownSignalHandler) == SIG_ERR) {
		caerLog(CAER_LOG_CRITICAL, "ShutdownAction", "Failed to set signal handler for SIGTERM. Error: %d.", errno);
		return (EXIT_FAILURE);
	}

	if (signal(SIGINT, &globalShutdownSignalHandler) == SIG_ERR) {
		caerLog(CAER_LOG_CRITICAL, "ShutdownAction", "Failed to set signal handler for SIGINT. Error: %d.", errno);
		return (EXIT_FAILURE);
	}
#else
	struct sigaction shutdownAction;

	shutdownAction.sa_handler = &globalShutdownSignalHandler;
	shutdownAction.sa_flags   = 0;
	sigemptyset(&shutdownAction.sa_mask);
	sigaddset(&shutdownAction.sa_mask, SIGTERM);
	sigaddset(&shutdownAction.sa_mask, SIGINT);

	if (sigaction(SIGTERM, &shutdownAction, NULL) == -1) {
		caerLog(CAER_LOG_CRITICAL, "ShutdownAction", "Failed to set signal handler for SIGTERM. Error: %d.", errno);
		return (EXIT_FAILURE);
	}

	if (sigaction(SIGINT, &shutdownAction, NULL) == -1) {
		caerLog(CAER_LOG_CRITICAL, "ShutdownAction", "Failed to set signal handler for SIGINT. Error: %d.", errno);
		return (EXIT_FAILURE);
	}
#endif

	// Arraycopy part
    data_t  Bs[N];
    data_t *A = (data_t*)sds_alloc(N * sizeof(data_t));
    data_t *B = (data_t*)sds_alloc(N * sizeof(data_t));
    data_t *B_zero = (data_t*)sds_alloc(N * sizeof(data_t));

    int result = 0;
    for (int ii = 1; !result && ii < NUM_ITERATIONS; ii++) {
         for (int j = 1; j < N; j++) {
              A[j]  = j;
              B[j] = 0;
              B_zero[j] = 0;
              Bs[j] = 0;
         }
         arraycopy_sw(A, Bs);
         array_copy(A, B);
         array_zero_copy(A, B_zero);
         print_results(A, Bs, B, B_zero);
         result = compare(Bs, B) + compare(Bs, B_zero);
    }

    // davis part
	// Open a DAVIS, give it a device ID of 1, and don't care about USB bus or SN restrictions.
	caerDeviceHandle davis_handle = caerDeviceOpen(1, CAER_DEVICE_DAVIS, 0, 0, NULL);
	if (davis_handle == NULL) {
		return (EXIT_FAILURE);
	}

	// Let's take a look at the information we have on the device.
	struct caer_davis_info davis_info = caerDavisInfoGet(davis_handle);

	printf("%s --- ID: %d, Master: %d, DVS X: %d, DVS Y: %d, Logic: %d.\n", davis_info.deviceString,
		davis_info.deviceID, davis_info.deviceIsMaster, davis_info.dvsSizeX, davis_info.dvsSizeY,
		davis_info.logicVersion);

	// Send the default configuration before using the device.
	// No configuration is sent automatically!
	caerDeviceSendDefaultConfig(davis_handle);

	// Tweak some biases, to increase bandwidth in this case.
	struct caer_bias_coarsefine coarseFineBias;

	coarseFineBias.coarseValue        = 2;
	coarseFineBias.fineValue          = 116;
	coarseFineBias.enabled            = true;
	coarseFineBias.sexN               = false;
	coarseFineBias.typeNormal         = true;
	coarseFineBias.currentLevelNormal = true;
	caerDeviceConfigSet(
		davis_handle, DAVIS_CONFIG_BIAS, DAVIS240_CONFIG_BIAS_PRBP, caerBiasCoarseFineGenerate(coarseFineBias));

	coarseFineBias.coarseValue        = 1;
	coarseFineBias.fineValue          = 33;
	coarseFineBias.enabled            = true;
	coarseFineBias.sexN               = false;
	coarseFineBias.typeNormal         = true;
	coarseFineBias.currentLevelNormal = true;
	caerDeviceConfigSet(
		davis_handle, DAVIS_CONFIG_BIAS, DAVIS240_CONFIG_BIAS_PRSFBP, caerBiasCoarseFineGenerate(coarseFineBias));

	// Let's verify they really changed!
	uint32_t prBias, prsfBias;
	caerDeviceConfigGet(davis_handle, DAVIS_CONFIG_BIAS, DAVIS240_CONFIG_BIAS_PRBP, &prBias);
	caerDeviceConfigGet(davis_handle, DAVIS_CONFIG_BIAS, DAVIS240_CONFIG_BIAS_PRSFBP, &prsfBias);

	printf("New bias values --- PR-coarse: %d, PR-fine: %d, PRSF-coarse: %d, PRSF-fine: %d.\n",
		caerBiasCoarseFineParse(prBias).coarseValue, caerBiasCoarseFineParse(prBias).fineValue,
		caerBiasCoarseFineParse(prsfBias).coarseValue, caerBiasCoarseFineParse(prsfBias).fineValue);

	// Now let's get start getting some data from the device. We just loop in blocking mode,
	// no notification needed regarding new events. The shutdown notification, for example if
	// the device is disconnected, should be listened to.
	caerDeviceDataStart(davis_handle, NULL, NULL, NULL, &usbShutdownHandler, NULL);

	// Let's turn on blocking data-get mode to avoid wasting resources.
	caerDeviceConfigSet(davis_handle, CAER_HOST_CONFIG_DATAEXCHANGE, CAER_HOST_CONFIG_DATAEXCHANGE_BLOCKING, true);

	while (!atomic_load_explicit(&globalShutdown, memory_order_relaxed)) {
		caerEventPacketContainer packetContainer = caerDeviceDataGet(davis_handle);
		if (packetContainer == NULL) {
			continue; // Skip if nothing there.
		}

		int32_t packetNum = caerEventPacketContainerGetEventPacketsNumber(packetContainer);

		printf("\nGot event container with %d packets (allocated).\n", packetNum);

		for (int32_t i = 0; i < packetNum; i++) {
			caerEventPacketHeader packetHeader = caerEventPacketContainerGetEventPacket(packetContainer, i);
			if (packetHeader == NULL) {
				printf("Packet %d is empty (not present).\n", i);
				continue; // Skip if nothing there.
			}

			printf("Packet %d of type %d -> size is %d.\n", i, caerEventPacketHeaderGetEventType(packetHeader),
				caerEventPacketHeaderGetEventNumber(packetHeader));

			// Packet 0 is always the special events packet for DVS128, while packet is the polarity events packet.
			if (i == POLARITY_EVENT) {
				caerPolarityEventPacket polarity = (caerPolarityEventPacket) packetHeader;

				// Get full timestamp and addresses of first event.
				caerPolarityEventConst firstEvent = caerPolarityEventPacketGetEventConst(polarity, 0);

				int32_t ts = caerPolarityEventGetTimestamp(firstEvent);
				uint16_t x = caerPolarityEventGetX(firstEvent);
				uint16_t y = caerPolarityEventGetY(firstEvent);
				bool pol   = caerPolarityEventGetPolarity(firstEvent);

				printf("First polarity event - ts: %d, x: %d, y: %d, pol: %d.\n", ts, x, y, pol);
			}

			if (i == FRAME_EVENT) {
				caerFrameEventPacket frame = (caerFrameEventPacket) packetHeader;

				// Get full timestamp, and sum all pixels of first frame event.
				caerFrameEventConst firstEvent = caerFrameEventPacketGetEventConst(frame, 0);

				int32_t ts   = caerFrameEventGetTimestamp(firstEvent);
				uint64_t sum = 0;

				for (int32_t y = 0; y < caerFrameEventGetLengthY(firstEvent); y++) {
					for (int32_t x = 0; x < caerFrameEventGetLengthX(firstEvent); x++) {
						sum += caerFrameEventGetPixel(firstEvent, x, y);
					}
				}

				printf("First frame event - ts: %d, sum: %" PRIu64 ".\n", ts, sum);
			}
		}

		caerEventPacketContainerFree(packetContainer);
	}

	caerDeviceDataStop(davis_handle);

	caerDeviceClose(&davis_handle);

	printf("Shutdown successful.\n");

	return (EXIT_SUCCESS + result);
}
