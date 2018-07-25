#!/usr/bin/tclsh
#  File: xdcc.tcl
###############################################################################
#  (c) Copyright 2012-2018 Xilinx, Inc. All rights reserved.
#
#  This file contains confidential and proprietary information
#  of Xilinx, Inc. and is protected under U.S. and
#  international copyright and other intellectual property
#  laws.
#
#  DISCLAIMER
#  This disclaimer is not a license and does not grant any
#  rights to the materials distributed herewith. Except as
#  otherwise provided in a valid license issued to you by
#  Xilinx, and to the maximum extent permitted by applicable
#  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
#  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
#  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
#  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
#  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
#  (2) Xilinx shall not be liable (whether in contract or tort,
#  including negligence, or under any other theory of
#  liability) for any loss or damage of any kind or nature
#  related to, arising under or in connection with these
#  materials, including for any direct, or any indirect,
#  special, incidental, or consequential loss or damage
#  (including loss of data, profits, goodwill, or any type of
#  loss or damage suffered as a result of any action brought
#  by a third party) even if such damage or loss was
#  reasonably foreseeable or Xilinx had been advised of the
#  possibility of the same.
#
#  CRITICAL APPLICATIONS
#  Xilinx products are not designed or intended to be fail-
#  safe, or for use in any application requiring fail-safe
#  performance, such as life-support or safety devices or
#  systems, Class III medical devices, nuclear facilities,
#  applications related to the deployment of airbags, or any
#  other applications that could lead to death, personal
#  injury, or severe property or environmental damage
#  (individually and collectively, "Critical
#  Applications"). Customer assumes the sole risk and
#  liability of any use of Xilinx products in Critical
#  Applications, subject only to applicable laws and
#  regulations governing limitations on product liability.
#
#  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
#  PART OF THIS FILE AT ALL TIMES.
###############################################################################

###############################################################################
# Globals
###############################################################################

# Associative array containing shared global data
array set apc {}

proc apc_set_global {global_param global_value} {
  global apc

  set apc($global_param) ${global_value}
}

proc apc_get_global {global_param} {
  global apc

  return $apc($global_param)
}

# Test if this command is used to print only the compiler build
# and include paths for the SDSoC Eclipse UI, for example
#   sds++ -E -P -v -c -dD test.cpp
proc is_sdsoc_toolchain_query {} {
  global argc argv

  set option_count 0
  for {set i 0} {$i < $argc} {incr i} {
    set arg [lindex $argv $i]
    switch -- $arg {
      -E  { incr option_count }
      -P  { incr option_count }
      -v  { incr option_count }
      -c  { incr option_count }
      -dD { incr option_count }
    }
  }
  if { ${option_count} == 5 } {
    return 1
  }
  return 0
}
apc_set_global APCC_IS_TOOLCHAIN_QUERY [is_sdsoc_toolchain_query]
apc_set_global APCC_SILENT_MODE [apc_get_global APCC_IS_TOOLCHAIN_QUERY]
apc_set_global APCC_TOOLCHAIN_CONFIG ""
apc_set_global APCC_PROC_INSTANCE ""
apc_set_global APCC_PROC_TYPE     ""
apc_set_global APCC_VPL_LOG_DIR ""

# First argument (arg 0) is the compiler: gcc or g++. It is set by the loader.
set use_sprite_log 0
set use_dsa_for_bsp 1
set compiler [lindex $argv 0]
apc_set_global APCC_GNU_COMPILER      $compiler
set toolchain ""
apc_set_global APCC_SDS_SOFTWARE_DIR      $toolchain

if {[string equal $compiler "gcc"]} {
  apc_set_global APCC_COMMAND_NAME "sdscc"
} else {
  apc_set_global APCC_COMMAND_NAME "sds++"
}

# SDSoC global settings for pre- and post-limited access 1 release

apc_set_global APCC_COPYRIGHT "(c) Copyright 2012-2018 Xilinx, Inc. All Rights Reserved."
apc_set_global APCC_VERSION "[apc_get_global APCC_COMMAND_NAME] 2018.1 [exec sdsbuildinfo]"
apc_set_global APCC_START_TIME [clock format [clock seconds]]

apc_set_global APCC_MIN_ARGC          2
apc_set_global APCC_WORK_DIRECTORY    "_sds"
apc_set_global APCC_REPORT_PREFIX     "sds"
apc_set_global APCC_COMPATIBILITY_OPTS "-sdsoc"
apc_set_global APCC_SDCARD_MOUNT_DIRECTORY  "/mnt"
apc_set_global APCC_SDCARD_PARTITION_DIRECTORY  "_sds"
apc_set_global APCC_ELF_TEMP_PATH     "NA"
apc_set_global APCC_ELF_FINAL_PATH    "NA"

apc_set_global APCC_OPT_HW_BLOCK      "-sds-hw"
apc_set_global APCC_OPT_END_BLOCK     "-sds-end"
apc_set_global APCC_OPT_PLATFORM      "-sds-pf"
apc_set_global APCC_OPT_PLATFORM_INFO "-sds-pf-info"
apc_set_global APCC_OPT_PLATFORM_LIST "-sds-pf-list"

apc_set_global APCC_IS_HLS_OPENCL      0
apc_set_global APCC_USE_STANDALONE_BSP 0
apc_set_global APCC_OS_LINKER_LIBRARY_NAME " "
apc_set_global APCC_LINKER_SCRIPT " "
apc_set_global APCC_USER_LINKER_SCRIPT " "
apc_set_global APCC_BSP_CONFIGURATION_MSS " "
apc_set_global APCC_BSP_CONFIGURATION_MSS_USER " "
apc_set_global APCC_BSP_CONFIGURATION_MSS_USER_MERGE " "
apc_set_global APCC_BSP_REPOSITORY_PATH   " "

apc_set_global APCC_DRC_ONE_ACCEL_PER_SOURCE 0
apc_set_global APCC_PREBUILT_AVAILABLE 0
apc_set_global APCC_PREBUILT_USED 0
apc_set_global APCC_COMPILER_OUTPUT_OPTION_USED 0
apc_set_global APCC_COMPILER_NOOP_FLOW 0

# Directory names under APCC_WORK_DIRECTORY
apc_set_global APCC_DIR_SDCARD             "sd_card"
apc_set_global APCC_DIR_SDS_CFWORK         ".cf_work"
apc_set_global APCC_DIR_SDS_DATA           ".data"
apc_set_global APCC_DIR_SDS_EST            "est"
apc_set_global APCC_DIR_SDS_EST_ACCDATA      ".accdata"
apc_set_global APCC_DIR_SDS_HWTEMP         ".hw"
apc_set_global APCC_DIR_SDS_IPREPO         "iprepo"
apc_set_global APCC_DIR_SDS_LIBS           ".libs"
apc_set_global APCC_DIR_SDS_LLVM           ".llvm"
apc_set_global APCC_DIR_SDS_LLVM_CHECKPOINT  ".checkpoint"
apc_set_global APCC_DIR_SDS_PACKAGING      ".pkg"
apc_set_global APCC_DIR_SDS_PREPROCESS     ".pp"
apc_set_global APCC_DIR_SDS_PART           "p"
apc_set_global APCC_DIR_SDS_PART_CFWORK      ".cf_work"
apc_set_global APCC_DIR_SDS_PART_IPI         "ipi"
apc_set_global APCC_DIR_SDS_PART_SDCARD      "sd_card"
apc_set_global APCC_DIR_SDS_PART_SDCARD_WORK ".boot"
apc_set_global APCC_DIR_SDS_PART_XSD         ".xsd"
apc_set_global APCC_DIR_SDS_REPORTS        "reports"
apc_set_global APCC_DIR_SDS_SWSTUBS        "swstubs"
apc_set_global APCC_DIR_SDS_VHLS           "vhls"
apc_set_global APCC_DIR_SDS_COMPONENTDB    ".cdb"
apc_set_global APCC_DIR_SDS_TRACE          "trace"

apc_set_global APCC_FILE_SYSTEM_HARDWARE   "system_hardware.xml"

# Insert -D macros during compilation
#   - APCC_MACRO_CC for all compile flow tools, including gcc/g++, Vivado HLS,
#     clang_wrapper, sdslint, pragma_gen, perf_instrumenter, stub_gen
#     (not defined prior to Public Access 1 release)
#   - APCC_MACRO_VHLS for Vivado HLS and pragma_gen only, since they deal
#     with the hardware interface. Don't pass this macro to sdslint
#     (it's linting against the hardware/software interface which should
#     be compiled the same as clang_wrapper) or clang_wrapper
#     (it needs to see a hardware function that is the "same" as the
#     caller code, otherwise llvm-link will fail.
apc_set_global APCC_MACRO_CC    "__SDSCC__"
apc_set_global APCC_MACRO_VHLS  "__SDSVHLS__"

# Disable using the bit-accurate floating point simulation models for
# csim and cosim.  Instead use the faster (but not necessarily bit accurate)
# implementation from your local system.  This is often required in SDSoC
# because the bit-accurate simulation models are not provided on ARM.
# Use -mno-fpo-macro in all sdscc/sds++ commands to not insert this macro.
# This is set in .cfg files "-D HLS_NO_XIL_FPO_LIB"
apc_set_global APCC_MACRO_HLS_FPO " "
set use_hls_fpo_macro 1

# Save the command line

set arg_list [apc_get_global APCC_COMMAND_NAME]
set argnum 0
foreach arg $argv {
  if {$argnum > 0 } {
    lappend arg_list $arg
  }
  incr argnum
}
apc_set_global APCC_COMMAND_LINE $arg_list

proc print_standard_header_simple {fp} {
  puts $fp [apc_get_global APCC_COPYRIGHT]
  puts $fp "#-----------------------------------------------------------"
  puts $fp "# Tool version  : [apc_get_global APCC_VERSION]"
  puts $fp "# Start time    : [apc_get_global APCC_START_TIME]"
  puts $fp "# Command line  : [apc_get_global APCC_COMMAND_LINE]"
  puts $fp "#-----------------------------------------------------------"
}

proc print_standard_header {fp} {
  puts $fp [apc_get_global APCC_COPYRIGHT]
  puts $fp "#-----------------------------------------------------------"
  puts $fp "# Tool version  : [apc_get_global APCC_VERSION]"
  puts $fp "# Start time    : [apc_get_global APCC_START_TIME]"
  puts $fp "# Command line  : [apc_get_global APCC_COMMAND_LINE]"
  puts $fp "# Log file      : [apc_get_global APCC_LOG]"
  puts $fp "# Journal file  : [apc_get_global APCC_JOURNAL]"
  puts $fp "# Report file   : [apc_get_global APCC_REPORT]"
  puts $fp "#-----------------------------------------------------------"
  puts $fp ""
}

proc apc_is_windows {} {
  global tcl_platform

  if {[string equal -nocase $tcl_platform(platform) "windows"]} {
    return 1
  }
  return 0
}

###############################################################################
# Output logging and command journaling
###############################################################################
set log_enabled     0
set journal_enabled 0
proc log_open {log_name} {
  global fp_log log_enabled

  set fp_log [open ${log_name} w]
  set log_enabled 1
  print_standard_header $fp_log
}

proc log_puts {log_text} {
  global fp_log log_enabled

  if {$log_enabled} {
    puts $fp_log $log_text
  }
}

proc log_close {} {
  global fp_log log_enabled

  if {$log_enabled} {
    close $fp_log
  }
  set log_enabled 0
}

proc journal_open {journal_name} {
  global fp_journal journal_enabled

  set fp_journal [open ${journal_name} w]
  print_standard_header $fp_journal
  set journal_enabled 1
}

proc journal_puts {journal_text} {
  global fp_journal journal_enabled

  if {$journal_enabled} {
    puts $fp_journal $journal_text
  }
}

proc journal_close {} {
  global fp_journal journal_enabled

  if {$journal_enabled} {
    close $fp_journal
  }
  set journal_enabled 0
}

# Output message to stdout and log
proc puts_command {msg_text} {
  journal_puts "# $msg_text"
  log_puts "$msg_text"
  puts $msg_text
}

###############################################################################
# Start up
###############################################################################
proc sdscc_start_message {} {
  # print_standard_header_simple stdout
}

proc sdscc_finish_message {} {
  set time_string [clock format [clock seconds]]
  set finish_string "[apc_get_global APCC_COMMAND_NAME] completed at $time_string"
  apc_set_global APCC_FINISH_TIME $time_string
  apc_set_global APCC_FINISH_STRING $finish_string

  # puts $finish_string
  puts ""
}

# Set directory from which the program was launched and project directory
# This is a global 
set run_dir [pwd]
set sdscc_dir_name [apc_get_global APCC_WORK_DIRECTORY]
set sdscc_dir [file join $run_dir $sdscc_dir_name]

sdscc_start_message
 
# Set XILINX_XD if not set
if {![info exists ::env(XILINX_XD)]} {
  set XDCC_SCRIPT [info script]
  apc_set_global APCC_PATH_XILINX_XD [file normalize [file join [file dirname $XDCC_SCRIPT] ..]]
  set ::env(XILINX_XD) [apc_get_global APCC_PATH_XILINX_XD]
} else {
  apc_set_global APCC_PATH_XILINX_XD $::env(XILINX_XD)
  puts "Using user-defined path for XILINX_XD environment variable [apc_get_global APCC_PATH_XILINX_XD]"
}

# add SDSoC packages to auto_path
set xdpath [apc_get_global APCC_PATH_XILINX_XD]
apc_set_global APCC_HPFM_INFO_XSL [file join ${xdpath} scripts xdcc platformInfo.xsl]
set sdsoc_packages [file join $xdpath scripts sdsoc]
lappend auto_path $sdsoc_packages
apc_set_global APCC_DEFAULT_ID     0
apc_set_global APCC_PFM_CONFIG     ""
apc_set_global APCC_PFM_PROC       ""
apc_set_global APCC_PFM_IMAGE      ""

package require sdsoc::opt
package require sdsoc::utils
package require sdsoc::lock
package require sdsoc::pfmx
package require sdsoc::template
package require sdsoc::sdcard
package require sdsoc::emu
package require sdsoc::msg

# temporary directory required for unified platform processing
set sdscc_temp_dir [file join $run_dir .Xil]
file mkdir $sdscc_temp_dir
::sdsoc::pfmx::set_temp_dir $sdscc_temp_dir
::sdsoc::template::initializeTemplatePackage [file join $run_dir _sds .Xil template.dat] [file join $sdscc_temp_dir template.loc] 


# Vivado and Vivado HLS tool paths

apc_set_global APCC_PATH_VHLS        [file normalize [exec which vivado_hls]]
apc_set_global APCC_PATH_VHLS_ROOT   [file normalize [file join [file dirname [apc_get_global APCC_PATH_VHLS]] ..]]
apc_set_global APCC_PATH_VIVADO      [file normalize [exec which vivado]]
apc_set_global APCC_PATH_VIVADO_ROOT [file normalize [file join [file dirname [apc_get_global APCC_PATH_VIVADO]] ..]]

# Compiler toolchain information and paths

apc_set_global APCC_PATH_TOOLCHAIN_ROOT ""

# set ARM toolchain name and version dynamically, based on selected toolchain
apc_set_global APCC_TOOLCHAIN         ""
apc_set_global APCC_TOOLCHAIN_VERSION ""

# Toolchain implicit include paths used by clang-based frontends when called
# by sdscc/sds++. These are the enumberated values, and the value used is
# based on the selected toolchain and version.

apc_set_global APCC_IFLAGS_LINUX_GPP  ""
apc_set_global APCC_IFLAGS_LINUX_GCC  ""
apc_set_global APCC_IFLAGS_EABI_GPP   ""
apc_set_global APCC_IFLAGS_EABI_GCC   ""

apc_set_global APCC_IFLAGS_TOOLCHAIN_GCC  ""
apc_set_global APCC_IFLAGS_TOOLCHAIN_GPP  ""

# Vivado HLS implicit include paths used by clang-based frontends when
# called by sdscc/sds++.

apc_set_global APCC_IFLAGS_VHLS "-I [file join [apc_get_global APCC_PATH_VHLS_ROOT] include]"

# set SDSoC library and include flags dynamically, based on selected toolchain.
# These are added by sdscc/sds++ when calling clang-based frontends and
# target compiler toolchain. Required to use libsds_lib.a.

apc_set_global APCC_IFLAGS_SDSLIB ""
apc_set_global APCC_LFLAGS_SDSLIB ""

# Platform-specific include flags and library flags/paths
# These values are initialized when the platform metadata is read.

apc_set_global APCC_IFLAGS_PLATFORM   ""
apc_set_global APCC_LFLAGS_PLATFORM   ""
apc_set_global APCC_LPATHS_PLATFORM   ""

# set dynamically, based on selected toolchain 
apc_set_global APCC_CLANG_ARCHFLAGS         ""
apc_set_global APCC_VHLS_ARCHFLAGS          ""
apc_set_global APCC_SDS_ARCHFLAGS           ""
apc_set_global APCC_SDS_INFERRED_LINK_FLAGS ""

###############################################################################
# Message strings
###############################################################################

apc_set_global APCC_MSG_SUBSYSTEM_NAME   $::sdsoc::msg::ssname_SDSOC
apc_set_global APCC_MSG_SUBSYSTEM_ID     $::sdsoc::msg::ssid_SDSOC

proc MSG_STRING {msg_type msg_id msg_text} {
  if { [apc_get_global APCC_SILENT_MODE] } {
    return
  }
  set msg_subsys    [apc_get_global APCC_MSG_SUBSYSTEM_NAME]
  set msg_subsys_id [apc_get_global APCC_MSG_SUBSYSTEM_ID]
  puts_command "$msg_type: \[$msg_subsys $msg_subsys_id-$msg_id\] $msg_text"
}

proc MSG_DEBUG {msg_id msg_text} {
  MSG_STRING "DEBUG" $msd_id $msg_text
}

proc MSG_STATUS {msg_id msg_text} {
  MSG_STRING "STATUS" $msg_id $msg_text
}

proc MSG_INFO {msg_id msg_text} {
  MSG_STRING "INFO" $msg_id $msg_text
}

proc MSG_CRITICAL_WARNING {msg_id msg_text} {
  MSG_STRING "CRITICAL WARNING" $msg_id $msg_text
}

proc MSG_WARNING {msg_id msg_text} {
  MSG_STRING "WARNING" $msg_id $msg_text
}

proc MSG_ERROR {msg_id msg_text} {
  MSG_STRING "ERROR" $msg_id $msg_text
}

proc MSG_PRINT {msg_text} {
  puts_command "$msg_text"
}

###############################################################################
# Helper functions
###############################################################################

proc is_cpp_source { source_file } {
  set src_ext [file extension $source_file]
  if {[string equal $src_ext ".cc"] || [string equal $src_ext ".cp"] || [string equal $src_ext ".cxx"] || [string equal $src_ext ".cpp"] || [string equal $src_ext ".CPP"] || [string equal $src_ext ".c++"] || [string equal $src_ext ".C"] } { 
    return 1
  }
  return 0
}

proc set_compiler_type { source_file } {
  if {[is_cpp_source $source_file]} {
    return "g++"
  }
  return "gcc"
}

proc is_any_source { source_file } {
  set src_ext [file extension $source_file]
  if {[string equal $src_ext ".cc"] || [string equal $src_ext ".cp"] || [string equal $src_ext ".cxx"] || [string equal $src_ext ".cpp"] || [string equal $src_ext ".CPP"] || [string equal $src_ext ".c++"] || [string equal $src_ext ".C"] || [string equal $src_ext ".c"] || [string equal $src_ext ".h"] } { 
    return 1
  }
  return 0
}

# Set toolchain information
proc sdscc_get_cfg { cfg_file os_name cpu_name tool_name param_name} {
  set xpath "xd:sdsoc/xd:toolConfiguration\[@xd:os='${os_name}' and @xd:cpu='${cpu_name}' and @xd:tool='${tool_name}']/@xd:${param_name}"
  set xpath_value [xpath_get_value ${cfg_file} ${xpath}]
  if {[string length $xpath_value] > 1} {
    return $xpath_value
  }
  return " "
}

proc  sdscc_set_toolchain_includes { cfg_file os_name cpu_name tool_name incl_var incl_type } {
  set tool_root [apc_get_global APCC_PATH_TOOLCHAIN_ROOT]
  set xpath "xd:sdsoc/xd:toolConfiguration\[@xd:os='${os_name}' and @xd:cpu='${cpu_name}' and @xd:tool='${tool_name}']/xd:toolInfo/xd:includeDirs\[@xd:includeType='${incl_type}']/@xd:includeCount"
  set xpath_value [xpath_get_value ${cfg_file} ${xpath}]
  if {[string length $xpath_value] >= 1} {
    set max_id $xpath_value
    set ipath ""
    for { set i 0} {$i < $max_id} {incr i} {
      if {[string equal -nocase ${incl_type} "cc"] } {
        set xpath "xd:sdsoc/xd:toolConfiguration\[@xd:os='${os_name}' and @xd:cpu='${cpu_name}' and @xd:tool='${tool_name}']/xd:toolInfo/xd:includeDirs\[@xd:includeType='cc']/xd:includeDir\[@xd:id='$i']/@xd:path"
      } else {
        set xpath "xd:sdsoc/xd:toolConfiguration\[@xd:os='${os_name}' and @xd:cpu='${cpu_name}' and @xd:tool='${tool_name}']/xd:toolInfo/xd:includeDirs\[@xd:includeType='cpp']/xd:includeDir\[@xd:id='$i']/@xd:path"
      }
      set xpath_value [xpath_get_value ${cfg_file} ${xpath}]
      # xpath_value uses '/' as a separator, and file split removes them
      # so file join will put in OS-specific separators
      append ipath " -I[file join $tool_root {*}[file split $xpath_value]]"
    }

      if {[string equal $cpu_name "x86"]} {
	  set other [setup_x86]
	  foreach path $other {
	      append ipath " -I$path"
	  }
      }
    apc_set_global $incl_var $ipath
  }
}

proc get_cc {} {
    global compiler
    return [get_compiler $compiler]
}

proc get_compiler {compiler} {
    global toolchain
    return "${toolchain}$compiler"
}

proc get_ar {} {
    global toolchain
    return "${toolchain}ar"
}

proc get_objcopy {} {
    global toolchain
    return "${toolchain}objcopy"
}

proc sdscc_set_toolchain_config { dev_name os_name cpu_name tool_name} {
  global toolchain

  # check if tool configuration exists
  set cfg_file [file join [apc_get_global APCC_PATH_XILINX_XD] data toolchain ${dev_name}]
  if {! [file exists ${cfg_file}]} {
    MSG_ERROR $::sdsoc::msg::idSCToolConfigNotFound "Unable to find SDSoC configuration file ${cfg_file}"
    return
  }

  # save the toolchain base name
  set val [sdscc_get_cfg ${cfg_file} ${os_name} ${cpu_name} ${tool_name} "toolBaseName"]
  if {[string length $val] > 1} {
    set toolchain ${val}
    apc_set_global APCC_TOOLCHAIN ${toolchain}
    apc_set_global APCC_SDS_SOFTWARE_DIR ${toolchain}
  }

  # save the spec file for linking, if any
  set val [sdscc_get_cfg ${cfg_file} ${os_name} ${cpu_name} ${tool_name} "toolSpecFile"]
  apc_set_global APCC_TOOL_SPEC_FILE ""
  if {[string length $val] > 1} {
    apc_set_global APCC_TOOL_SPEC_FILE "[file join [apc_get_global APCC_PATH_XILINX_XD] {*}[file split ${val}]]"
  }

  # save the toolchain root PATH
  set gpp_path [file normalize [exec which [apc_get_global APCC_TOOLCHAIN]g++]]
  apc_set_global APCC_PATH_TOOLCHAIN_ROOT [file normalize [file join [file dirname ${gpp_path}] ..]]

  # save the toolchain version number
  set val [sdscc_get_cfg ${cfg_file} ${os_name} ${cpu_name} ${tool_name} "toolVersion"]
  if {[string length $val] > 1} {
    apc_set_global APCC_TOOLCHAIN_VERSION ${val}
  }

  # save the SDSoC include and library paths
  set val [sdscc_get_cfg ${cfg_file} ${os_name} ${cpu_name} ${tool_name} "sdsSoftwareDir"]
  if {[string length $val] > 1} {
    apc_set_global APCC_SDS_SOFTWARE_DIR ${val}
  }
  set val [sdscc_get_cfg ${cfg_file} ${os_name} ${cpu_name} ${tool_name} "sdsIncludeDir"]
  if {[string length $val] > 1} {
    apc_set_global APCC_IFLAGS_SDSLIB "-I [file join [apc_get_global APCC_PATH_XILINX_XD] {*}[file split ${val}]]"
  }
  set val [sdscc_get_cfg ${cfg_file} ${os_name} ${cpu_name} ${tool_name} "sdsLibDir"]
  if {[string length $val] > 1} {
    apc_set_global APCC_LFLAGS_SDSLIB "-L [file join [apc_get_global APCC_PATH_XILINX_XD] {*}[file split ${val}]]"
  }

  # save compiler options required by clang-based frontends
  set val [sdscc_get_cfg ${cfg_file} ${os_name} ${cpu_name} ${tool_name} "clangArchFlags"]
  if {[string length $val] > 1} {
    apc_set_global APCC_CLANG_ARCHFLAGS ${val}
  }

  # save compiler options required by Vivado HLS frontends
  set val [sdscc_get_cfg ${cfg_file} ${os_name} ${cpu_name} ${tool_name} "vhlsArchFlags"]
  if {[string length $val] > 1} {
    apc_set_global APCC_VHLS_ARCHFLAGS ${val}
  }

  # save compiler options required for sdscc/sds++ compiles
  global use_hls_fpo_macro
  if {$use_hls_fpo_macro} {
    # This is set in .cfg files "-D HLS_NO_XIL_FPO_LIB" if required
    set val [sdscc_get_cfg ${cfg_file} ${os_name} ${cpu_name} ${tool_name} "sdsHlsFpoMacro"]
    if {[string length $val] > 1} {
      apc_set_global APCC_MACRO_HLS_FPO ${val}
    }
  }

  # save compiler options required for sdscc/sds++ compiles for code generation
  # (clangArchFlags and sdsArchFlags are mutually exclusive)
  set val [sdscc_get_cfg ${cfg_file} ${os_name} ${cpu_name} ${tool_name} "sdsArchFlags"]
  if {[string length $val] > 1} {
    apc_set_global APCC_SDS_ARCHFLAGS ${val}
  }
  set val [sdscc_get_cfg ${cfg_file} ${os_name} ${cpu_name} ${tool_name} "sdsInferredLinkFlags"]
  if {[string length $val] > 1} {
  set spec_file [apc_get_global APCC_TOOL_SPEC_FILE]
  if {[string length $spec_file] > 1} {
    append val " -specs=" $spec_file
  }
    apc_set_global APCC_SDS_INFERRED_LINK_FLAGS ${val}
  }

  # save include paths required by clang-based frontends
  sdscc_set_toolchain_includes $cfg_file $os_name $cpu_name $tool_name APCC_IFLAGS_TOOLCHAIN_GCC cc
  sdscc_set_toolchain_includes $cfg_file $os_name $cpu_name $tool_name APCC_IFLAGS_TOOLCHAIN_GPP cpp
}

# hack
proc stacktrace {} {
    set stack "Stack trace:\n"
    for {set i 1} {$i < [info level]} {incr i} {
        set lvl [info level -$i]
        set pname [lindex $lvl 0]
        append stack [string repeat " " $i]$pname
        foreach value [lrange $lvl 1 end] arg [info args $pname] {
            if {$value eq ""} {
                info default $pname $arg value
            }
            append stack " $arg='$value'"
        }
        append stack \n
    }
    return $stack
}
# end hack

# Return a string containing options and include flags for clang-based
# compiler frontend tools. The tools require implicitly defined include
# files built into gcc/g++, SDSoC include files, Vivado HLS files, and
# platform include files. They also require target-specific flags.
proc get_implicit_flags_for_clang { compiler_name is_preprocessed enable_warnings } {
  # hack
  MSG_PRINT "get_implicit_flags_for_clang is invoked."
  MSG_PRINT [stacktrace] 
  # end hack
  if {$enable_warnings} {
    set WOPT_FLAG ""
  } else {
    set WOPT_FLAG "-w"
  }
  if {$is_preprocessed} {
    return "[apc_get_global APCC_CLANG_ARCHFLAGS] ${WOPT_FLAG}"
  }
  if {[string equal -nocase ${compiler_name} "gcc"]} {
    return "[apc_get_global APCC_CLANG_ARCHFLAGS] ${WOPT_FLAG} \
            [apc_get_global APCC_IFLAGS_PLATFORM] \
            [apc_get_global APCC_IFLAGS_SDSLIB] \
            [apc_get_global APCC_MACRO_HLS_FPO] \
            [apc_get_global APCC_IFLAGS_VHLS]"
            # [apc_get_global APCC_IFLAGS_TOOLCHAIN_GCC] "
  } elseif {[string equal -nocase ${compiler_name} "g++"]} {
    return "[apc_get_global APCC_CLANG_ARCHFLAGS] ${WOPT_FLAG} \
            [apc_get_global APCC_IFLAGS_PLATFORM] \
            [apc_get_global APCC_IFLAGS_SDSLIB] \
            [apc_get_global APCC_MACRO_HLS_FPO] \
            [apc_get_global APCC_IFLAGS_VHLS] \
            -std=c++11"
            # [apc_get_global APCC_IFLAGS_TOOLCHAIN_GPP] \
  } else {
    MSG_WARNING $::sdsoc::msg::idSCImplicitClangFlags "Unrecognized target compiler ${compiler_name}, using g++ include paths for clang-based frontend"
  }
  return "[apc_get_global APCC_CLANG_ARCHFLAGS] ${WOPT_FLAG} \
          [apc_get_global APCC_IFLAGS_PLATFORM] \
          [apc_get_global APCC_IFLAGS_SDSLIB] \
          [apc_get_global APCC_MACRO_HLS_FPO] \
          [apc_get_global APCC_IFLAGS_VHLS] \
          [apc_get_global APCC_IFLAGS_TOOLCHAIN_GPP]"
}

# Return a string containing options and include flags for Vivado HLS.
# The tool requires implicitly defined SDSoC include files, and
# platform include files.
proc get_implicit_flags_for_vhls {} {
  return "[apc_get_global APCC_VHLS_ARCHFLAGS] \
          [apc_get_global APCC_IFLAGS_PLATFORM] \
          [apc_get_global APCC_MACRO_HLS_FPO] \
          [apc_get_global APCC_IFLAGS_SDSLIB]"
}

# Return a string containing options and include flags for gcc/g++.
# The compilers require implicitly defined SDSoC include files, and
# platform include files.
proc get_implicit_flags_for_gcc {} {
  return "[apc_get_global APCC_SDS_ARCHFLAGS] \
          [apc_get_global APCC_IFLAGS_PLATFORM] \
          [apc_get_global APCC_IFLAGS_SDSLIB] \
          [apc_get_global APCC_MACRO_HLS_FPO] \
          [apc_get_global APCC_IFLAGS_VHLS]"
}

proc get_implicit_link_flags {} {
  return "[apc_get_global APCC_SDS_INFERRED_LINK_FLAGS]"
}

proc proc_is_cortex_a53 {} {
  set proc_type [apc_get_global APCC_PROC_TYPE]
  if {[string equal -nocase $proc_type "cortex-a53"]} {
    return 1
  }
  return 0
}

proc proc_is_x86 {} {
  set proc_type [apc_get_global APCC_PROC_TYPE]
  if {[string equal -nocase $proc_type "x86"]} {
    return 1
  }
  return 0
}

###############################################################################T

# Cleanup
###############################################################################
# copy log files for Sprite - assume all log files close, so you
# can't send error messages to a log file
proc update_sprite_log_directory {} {
  # return if the -log-dir option wasn't specified
  global use_sprite_log
  if {! $use_sprite_log} {
    return
  }
  set logDir [apc_get_global APCC_VPL_LOG_DIR]
  if {[string length ${logDir}] > 0} {
    if {! [file exists ${logDir}]} {
      MSG_ERROR $::sdsoc::msg::idSCUpdateLogDir "Unable to update ${logDir}, directory not found"
      return
    }
  }

  # add the sds.log file to the list
  set sdsLog [apc_get_global APCC_LOG]
  if {[file exists ${sdsLog}]} {
    set sdsocLogDir [file normalize [file join ${logDir} sdsoc]]
    if {[catch {file mkdir ${sdsocLogDir}} ]} {
      MSG_ERROR $::sdsoc::msg::idSCCreateLogDir "Log directory cannot be created at: ${sdsocLogDir}"
    } else {
      set status [catch {file copy -force ${sdsLog} ${sdsocLogDir}} result]
      if {$status != 0} {
        MSG_ERROR $::sdsoc::msg::idSCCopyLogFile "Unable to copy ${sdsLog} to ${sdsocLogDir}, ${result}"
      }
    }
  }

  # for compilation runs, save any Vivado HLS log files
  set flowType [apc_get_global APCC_FLOW_TYPE]
  if {[string equal -nocase $flowType APCC_COMPILE_HLS_FLOW]} {
    set compileLogDir [file normalize [file join ${logDir} compile]]
    if {[catch {file mkdir ${compileLogDir}} ]} {
      MSG_ERROR $::sdsoc::msg::idSCCreateLogDir "Log directory cannot be created at: ${compileLogDir}"
    } else {
      global hls_log_list
      foreach logFile $hls_log_list {
        if {[file exists ${logFile}]} {
          set status [catch {file copy -force ${logFile} ${compileLogDir}} result]
          if {$status != 0} {
            MSG_ERROR $::sdsoc::msg::idSCCopyLogFile "Unable to copy ${logFile} to ${compileLogDir}, ${result}"
          }
        }
      }
    }
  }
}

proc sdscc_on_exit {exit_code} {
  global log_enabled

  # Close log files
  if { $log_enabled } {
    puts "[apc_get_global APCC_COMMAND_NAME] log file saved as [apc_get_global APCC_LOG]"
    log_puts "[apc_get_global APCC_COMMAND_NAME] log file saved as [apc_get_global APCC_LOG]"
  }
  if { ${exit_code} != 0} {
    if { ${exit_code} != 2} {
      MSG_ERROR $::sdsoc::msg::idSCBuildFailed "Build failed"
    }
  }
  sdscc_finish_message
  log_puts [apc_get_global APCC_FINISH_STRING]
  journal_puts "# [apc_get_global APCC_FINISH_STRING]"

  log_close
  journal_close

  # update log file directory for Sprite, if specified
  update_sprite_log_directory

  # exit
  exit ${exit_code}
}

proc initialize_sprite_log_directory {} {
  global use_sprite_log

  set logDir [apc_get_global APCC_VPL_LOG_DIR]
  if {[string length ${logDir}] > 0} {
    if {! [file exists ${logDir}]} {
      if {[catch {file mkdir ${logDir}} ]} {
        MSG_ERROR $::sdsoc::msg::idSCOptLogDir "The log directory cannot be created at: ${logDir}"
        sdscc_on_exit 1
      }
    }
    set use_sprite_log 1
    ::sdsoc::opt::setOptLogDir ${logDir}
  }
}

###############################################################################
# Utilities
###############################################################################

proc get_files {dir pattern} {
  # Ensure directory name is correct for platform
  set dir [string trimright [file join [file normalize $dir] { }]]

  set fileList {}
  foreach fileName [glob -nocomplain -type f -directory $dir $pattern] {
    lappend fileList $fileName
  }
  foreach dirName [glob -nocomplain -type d -directory $dir *] {
    set subDirList [get_files $dirName $pattern]
    foreach subDirFile $subDirList {
      lappend fileList $subDirFile
    }
  }
  return $fileList
}

proc find_component_xml {vlnv} {
  global ip_repo_dir_list

  set vlnv_list [split $vlnv ":"]
  set vendor [lindex $vlnv_list 0]
  set library [lindex $vlnv_list 1]
  set name [lindex $vlnv_list 2]
  set version [lindex $vlnv_list 3]

  #set vivado_ip_repo [file join [apc_get_global APCC_PATH_VIVADO_ROOT] data ip]
  foreach vivado_ip_repo ${ip_repo_dir_list} {

    puts "Locating IP core in $vivado_ip_repo"
    #puts "Vendor : $vendor"
    #puts "Library: $library"
    #puts "Name   : $name"
    #puts "Version: $version"

    set component_xml_files [get_files $vivado_ip_repo component.xml]

    foreach comp_xml $component_xml_files {
      set xpath "boolean(/spirit:component/spirit:vendor/text()='${vendor}')"
      set vendor_match [xpath_get_value $comp_xml $xpath]
      if {[string length $vendor_match] < 1} {
        MSG_PRINT "Unable to parase component XML file $comp_xml to read vendor information, skipping"
        continue
      }

      set xpath "boolean(/spirit:component/spirit:library/text()='${library}')"
      set library_match [xpath_get_value $comp_xml $xpath]
      if {[string length $library_match] < 1} {
        MSG_PRINT "Unable to parase component XML file $comp_xml to read library information, skipping"
        continue
      }

      set xpath "boolean(/spirit:component/spirit:name/text()='${name}')"
      set name_match [xpath_get_value $comp_xml $xpath]
      if {[string length $name_match] < 1} {
        MSG_PRINT "Unable to parase component XML file $comp_xml to read name information, skipping"
        continue
      }

      set xpath "boolean(/spirit:component/spirit:version/text()='${version}')"
      set version_match [xpath_get_value $comp_xml $xpath]
      if {[string length $version_match] < 1} {
        MSG_PRINT "Unable to parase component XML file $comp_xml to read version information, skipping"
        continue
      }

      if {$vendor_match && $library_match && $name_match && $version_match} {
        return $comp_xml
      }
    }
  # end foreach vivado_ip_repo
  }
}


proc copy_file_force {source dest} {
  set status [catch {file copy -force $source $dest} result]
  if {$status != 0} {
    if {[apc_is_windows] && [string length $dest] > 240} {
      MSG_ERROR $::sdsoc::msg::idSCCopyFileWin "Cannot copy '$source' to '$dest' because the destination is in use or not writable, the destination path does not exist, or path names are too long (ensure all path names for the SDSoC installation and design folders are as short as possible)."
    } else {
      MSG_ERROR $::sdsoc::msg::idSCCopyFile "Cannot copy '$source' to '$dest' because the destination is in use or not writable, the destination path does not exist, or another error has occurred."
    }
    sdscc_on_exit 1
  }
}

proc delete_directory {mydirectory} {
  set status [catch {file delete -force $mydirectory} result]
  if {$status != 0} {
    MSG_ERROR $::sdsoc::msg::idSCDeleteDir "Cannot delete directory '$mydirectory' because it is being used. Ensure all files under it are closed and the directory is not being used."
    sdscc_on_exit 1
  }
}

proc delete_file {myfile} {
  set status [catch {file delete -force $myfile} result]
  if {$status != 0} {
    MSG_ERROR $::sdsoc::msg::idSCDeleteFile "Cannot delete file '$myfile' because it is being used. Ensure the file is closed and is not being used."
    sdscc_on_exit 1
  }
}

proc diff_files {file1 file2} {
  set status [catch {exec [::sdsoc::utils::getCommandPath diff] -B $file1 $file2} result]
  if {$status == 0} {
    # files are the same
    return 0
  }
  return 1
}

proc copy_if_different {source target} {
  global verbose
  if {[file exists $target]} {
    set status [catch {exec [::sdsoc::utils::getCommandPath diff] $source $target} result]
    if {$status == 0} {
      if {$verbose} {
        MSG_PRINT "Skipping $source because it matches $target"
      }
      return
    }
  }
  if {$verbose} {
    MSG_PRINT "Copying $source to $target"
  }
  delete_directory -force $target
  file mkdir [file dirname $target]
  copy_file_force $source $target
}

proc copy_if_different_recursive {source_dir target_dir} {
  set files [get_files $source_dir *]
  foreach source_file $files {
    regsub $source_dir $source_file $target_dir target_file
    copy_if_different $source_file $target_file
  }
}

# source and dest both must be file path names, not directories.
# copy file by reading it and writing it to the destination, rather
# than use "file copy", which preserves the file permission (e.g. read-only),
# which can be a problem later if you need to write the file again.
proc copy_file_force_writeable {source dest} {
  if {! [file exists $source]} {
      MSG_ERROR $::sdsoc::msg::idSCCopyFileWriteable "Cannot copy '$source' to '$dest' because the source does not exist."
    sdscc_on_exit 1
  }
  if {[file exists $dest]} {
    delete_file $dest
  }
  set sp [open $source r]
  set dp [open $dest w]
  # make exact copy of the file except metadata (e.g. file permissions)
  fconfigure $sp -translation binary
  fconfigure $dp -translation binary
  fcopy $sp $dp
  close $sp
  close $dp
}

# copy source file to destination translating line terminators to LF (\n).
# This means Windows "\r\n" (CR + LF) becomes "\n" (LF).
proc copy_file_translate_to_unix {source dest} {
  if {! [file exists $source]} {
      MSG_ERROR $::sdsoc::msg::idSCCopyFileUnix "Cannot copy '$source' to '$dest' because the source does not exist."
    sdscc_on_exit 1
  }
  if {[file exists $dest]} {
    delete_file $dest
  }
  set sp [open $source r]
  set dp [open $dest w]
  # TCL translates all line terminators to LF internally
  fconfigure $sp -translation auto
  # On the way out, always use LF ("\n")
  fconfigure $dp -translation lf
  fcopy $sp $dp
  close $sp
  close $dp
}

# copy file but delete pre-processor lines that start with pound character.
# annotations that are not removed confuse downstream tools when you create
# a clang IR from the source, causing line numbers to be off. you need to
# keep the pragmas for DM generation, though.
proc copy_file_remove_pp_lines {source dest} {
  if {! [file exists $source]} {
      MSG_ERROR $::sdsoc::msg::idSCCopyFileUnix "Cannot copy '$source' to '$dest' because the source does not exist."
    sdscc_on_exit 1
  }
  if {[file exists $dest]} {
    delete_file $dest
  }
  set sp [open $source r]
  set dp [open $dest w]
  # copy line if it doesn't start with pound character
  while {[gets $sp sourceBuffer] >= 0} {
    if { [string match -nocase "#pragma*" ${sourceBuffer}]} {
      puts $dp ${sourceBuffer}
      continue
    }
    if {! [string match "#*" ${sourceBuffer}]} {
      puts $dp ${sourceBuffer}
    }
  }
  
  # done
  close $sp
  close $dp
}

# Create empty file
proc create_empty_file {fname} {
  if {[file exists $fname]} {
    delete_file $fname
  }
  set fp [open $fname w]
  close $fp
}

proc tail_file {fname numlines} {
  if {! [file exists $fname]} {
    return
  }
  puts_command "$fname (last $numlines lines):"
  exec_command_and_print "[::sdsoc::utils::getCommandPath tail] -$numlines $fname"
}

proc is_license_available {feature_name show_error} {
  set err ""
  set ec [catch { eval exec -ignorestderr "[::sdsoc::utils::getCommandPath xdlmcheck] $feature_name"} err]
  if { $show_error } {
    puts $err
  }
  if {[string length $err] > 0 && [string first "expires" $err] > 0} {
    puts $err
  }
  if { $ec } {
    return 0
  }
  return 1
}

###############################################################################
# Command execution
###############################################################################
# Execute cd command; wrapper allows the command to be captured
proc cd_command {cd_path} {
  journal_puts "cd $cd_path"
  if {! [file exists $cd_path]} {
    MSG_ERROR $::sdsoc::msg::idSCExitCdFail "Exiting [apc_get_global APCC_COMMAND_NAME] : Error when calling 'cd $cd_path'"
    sdscc_on_exit 1
    exit 1
  }
  cd $cd_path
}

# Run a command and optionally tee output to a file
# (without using the Linux tee command for Windows
# portability). Returns 0 if successful, otherwise
# non-zero, but this is NOT the exit code of the
# command that was run.
#
# command      : command to run
# always_print : 1 always send stdout+stderr to screen
#              : 0 verbose option controls whether to send stdout to screen
# args         : optional proc to process error code (from XidanePass);
#                the name "args" is treated as optional to the calling function,#                and any other name makes it a required argument

proc execpipe_command {command always_print args} {
  global verbose

  journal_puts $command
  log_puts $command

  set error_detected 0
  set enable_print 0
  set enable_print_on_info 0
  set is_hls_compilation_error 0
  set is_hls_compilation_warning 0
  set skip_pragma_warning 0
  set in_clang_pragma_warning 0
  set pragma_warning_buffer ""
  set is_clang_wrapper_command 0
  set in_clang_spurious_warning 0
  if {$verbose} {
    puts $command
  }
  if {$verbose || $always_print} {
    set enable_print 1
  }
  if {! $verbose && [string first "clang_wrapper" $command] >= 0 } {
    set is_clang_wrapper_command 1
  }

  # stderr sent to stdout, so pipe will have both. Note that messages
  # sent to stderr can cause the catch when you close the pipe
  # to return error (return code 1). This should mean only errors that
  # cause an application to exit will trigger the catch.

  set pipe_redirect "2>@1"
  if { [catch { open "| $command $pipe_redirect" "r+"} pipe] } {
    MSG_ERROR $::sdsoc::msg::idSCExecPipe "Cannot execute '$command'"
    sdscc_on_exit 1
  }
  fconfigure $pipe -buffering none
  while { [gets $pipe data] >= 0 } {

    # if errors haven't been detected yet, check to see if the
    # current line looks like it contains an error. If errors
    # started, then start enabling error output even if 
    if { ! $enable_print && ! $error_detected } {
      # clang_wrapper warnings and errors we care about start on a
      # line containing the string SDSCC.
      if { [string first "(SDSoC)" $data] >= 0 } {
        set error_detected 1
      # Vivado HLS errors begin with @E
      } elseif { [string first "@E " $data] >= 0 } {
        set error_detected 1
        if { [string first "Compilation errors found" $data] >= 0 } {
          set is_hls_compilation_error 1
        }
      } elseif { [string first "@W " $data] >= 0 } {
        if { [string first "improper streaming access" $data] >= 0 } {
          set error_detected 1
          set is_hls_compilation_warning 1
        }
      # Other SDSoC tool errors
      } elseif { [string first "ERROR" $data] >= 0 } {
        set error_detected 1
      } elseif { [string equal -length  5 "INFO:" $data] } {
          if { [string first "17-86" $data] > 0 ||
             [string first "expires" $data] > 0 } {
            set enable_print_on_info 1
          }
      }
    }

    # =============================================================
    # SDSoC pragma unrecognized by gcc or other parser frontends
    # can be filtered out. Skip HLS pragma warnings also.
    # Note that the message formats used by various tools differ,
    # so you need to handle each one. Depending on what tool is
    # called, you may want to ignore certain unknown pragma warnings,
    # not necessarily all of them. For example, for clang frontends,
    # ignore unknown pragma warnings for HLS pragmas, but don't ignore
    # SDSoC pragma warnings which could be typos.
    # =============================================================
    # GCC warnings about unknown pragmas look like this (this is for
    # a .c file which includes a .h containing HLS pragmas - note that
    # warning line contains the pragma plus the warning type
    # -Wunknown-pragmas, the source text, and a line with a carat ^).
    #
    # Once you've read the warning, the same line contains the pragma
    # and it's possible to decide if the message should be skipped.
    #
    #   In file included from /proj/fv7/tshui/xidane/test/test_mmult_datasize/mmult.cpp:4:0:
    #   /proj/fv7/tshui/xidane/test/test_mmult_datasize/mmult_accel.h:9:0: warning: ignoring #pragma APF data [-Wunknown-pragmas]
    #   #pragma APF data copy(in_A[0:dim1*dim1])
    #   ^
    # =============================================================
    # In contrast, clang-based tool (sdslint, pragma_gen, et al) warnings
    # are slightly different (don't contain the pragma in the warning line but
    # includes the warning type -Wunknown-pragmas, the source text, and a line
    # with a carat ^).
    #
    # Once you've read the warning, you need to read the next line to
    # know the pragma and decide if the message should be skipped.
    #
    #   C:\Users\tshui\ws_demo\apf_mmultadd\src\mmult.cpp:10:9: warning: unknown pragma ignored [-Wunknown-pragmas]
    #   #pragma HLS INLINE self
    #           ^
    # =============================================================

    # suppress: 1 warning and 1 error generated.
    if { [string first "generated." $data] >= 0 } {
        continue
    }
    # suppress: warning: clang: 'linker' input unused
    # suppress: warning: clang++: 'linker' input unused
    if { [string first "warning: clang: 'linker' input unused" $data] >= 0 } {
        continue
    }
    if { [string first "warning: clang++: 'linker' input unused" $data] >= 0 } {
        continue
    }

    if { $always_print && [string first "In file included from" $data] >= 0 } {
        continue
    }
    if { [string first "-Wunknown-pragmas" $data] >= 0 } {

      set pragma_warning_buffer ""

      # gcc -Wunknown-pragmas (pragma is known on the same line)
      if { [string first "#pragma SDS" $data] >= 0 &&
         [string first "(SDSoC)" $data] < 0 } {
        set skip_pragma_warning 1
        continue
      } elseif {$always_print && ([string first "#pragma HLS" $data] >= 0
                               || [string first "#pragma AP" $data] >= 0) } {
        set skip_pragma_warning 1
        continue
      } elseif { [string first "unknown pragma ignored" $data] >= 0 } {

      # clang -Wunknown-pragmas (need to buffer the warning and read next line)
      # print the buffer later if you decide it needs to be

        set in_clang_pragma_warning 1
        set pragma_warning_buffer $data
        continue
      }

    }

    # suppress spurious clang warnings triggered by processing ARM tool
    # chain headers
    if {$is_clang_wrapper_command} {
      if {[string first "SDK" $data] > 0} {
        if { [string first "warning: unknown attribute" $data] >= 0
          || [string first "note: expanded from macro" $data] >= 0 } {
          set in_clang_spurious_warning 1
          continue
        }
      }
      if {$in_clang_spurious_warning} {
        if {[string first "^" $data] >= 0 } {
          set in_clang_spurious_warning 0
        }
        continue
      }
    }

    # if this is a clang warning, read the pragma and decided if we should
    # pass through the warning or not. If yes, flush the buffer containing
    # the warning message. If no, set a flag to skip the pragma warning.
    if { $in_clang_pragma_warning && [string first "#pragma" $data] >= 0 } {
      if { [string first "HLS" $data] >= 0
        || [string first "AP " $data] >= 0
        || [string first "APF" $data] >= 0 } {
        set skip_pragma_warning 1
      } else {
        if {$enable_print} {
          puts $pragma_warning_buffer
        }
        log_puts $pragma_warning_buffer
        set pragma_warning_buffer ""
      }
    }

    # print output if enabled or triggered by an error
    if {$enable_print || $error_detected || $enable_print_on_info} {
      # llvm-link
      if { [string first "link error" $data] >= 0 } {
        MSG_ERROR $::sdsoc::msg::idSCErrorDetected "Error detected : $data"
      } elseif {! $skip_pragma_warning } {
        puts $data
      }
      set enable_print_on_info 0
    }

    # Text is always printed to the log
    if {! $skip_pragma_warning } {
      log_puts $data
    }

    # Look for string to terminate printing of error and
    # related text
    if { $error_detected } {
      # For HLS compilation errors, keep printing text until exit
      # (it's failed and will write out a lot of error text).
      # For warnings, print only the warning message.
      if { $is_hls_compilation_error } {
        continue
      }
      if { $is_hls_compilation_warning } {
        set error_detected 0
        set is_hls_compilation_warning 0
      }
      # clang_wrapper warnings and errors end on a line
      # containing a carat ^ under the error.
      if { [string first "^" $data] >= 0 } {
        set error_detected 0
      }
    } elseif { $skip_pragma_warning } {
      if { [string first "^" $data] >= 0 } {
        set skip_pragma_warning 0
      }
    }
  }
  # if there is an error in execution, when you close the pipe,
  # $err contains "child process exited abnormally". It hasn't
  # been printed yet, though. The "catch" doesn't return the
  # actual exit code - it returns 0 or 1.
  set ec [catch {close $pipe} err]
  if { $ec } {
    # if there is a handler, let it perform more processing and
    # and exit if it returns a non-zero value. It doesn't process
    # the actual exit code from the command, though.
    if {$args ne ""} {
      if { ! [$args] } {
        return $ec
      }
    }

    # output error message from close the pipe
    # $err contains "child process exited abnormally", which seems to
    # confuse people, so don't print that string
    # puts_command $err
    # if the error comes from internal XidanePass, don't print it out to user
    if {$args != "exit_handler_xidanepass"} {
	MSG_ERROR $::sdsoc::msg::idSCErrorCalling "Exiting [apc_get_global APCC_COMMAND_NAME] : Error when calling '$command'"
    }
    # clean up and close log files (if open)
    sdscc_on_exit 1
  }
  return 0
}

# Execute command with optional processing of the exit code
# optional last arg: procedure name for exit code handler
proc exec_command {command args} {
  if {$args ne ""} {
    execpipe_command $command 0 $args
  } else {
    execpipe_command $command 0
  }
}

proc exec_commandx {command args} {
  global verbose redirect
  journal_puts $command
  if {$verbose} {
    puts $command
  }
  log_puts $command
  set ec [catch { eval exec $command $redirect } err]
  if { $ec } {
    # if there is a handler, let it perform more processing and
    # and exit if it returns a non-zero value. It doesn't have
    # the actual exit code from the exec, though.
    if {$args ne ""} {
      if { ! [$args] } {
        return
      }
    }
    # output error message from close the pipe
    # $err contains "child process exited abnormally", which seems to
    # confuse people, so don't print that string
    # puts_command $err
    MSG_ERROR $::sdsoc::msg::idSCErrorCallingX "Exiting [apc_get_global APCC_COMMAND_NAME] : Error when calling '$command'"
    sdscc_on_exit 1
  }
}

# Dummy proc used to override exits - passed as a proc to
# to check for errors, but always finds none (returns 0)
proc exec_success {} {
  return 0
}

# This proc always returns even if the command fails.
# Assumes the calling code does not want to exit.
proc exec_command_always_returnx {command} {
  execpipe_command $command 0 exec_success
}

proc exec_command_always_return {command} {
  global verbose redirect
  journal_puts $command
  if {$verbose} {
    puts $command
  }
  log_puts $command
  set ec [catch { eval exec $command $redirect } err]
  return $ec
}

# This proc always prints the stdout/stderr of the called command,
# including a log file if enabled.
proc exec_command_and_print {command} {
  global dev_run_log
  global verbose
  if {$dev_run_log} {
    # force stdout + stderr to print
    execpipe_command $command 1
  } else {
    if {$verbose} {
      puts $command
    }
    exec_command_and_print_simple $command
  }
}

# This proc always prints the stdout/stderr of the called command
# to stdout, never logging to a file.
proc exec_command_and_print_simple {command} {
  if { [catch { eval exec $command >@ stdout 2>@ stderr} err] } {
    # output error message from close the pipe
    # $err contains "child process exited abnormally", which seems to
    # confuse people, so don't print that string
    # puts_command $err
    MSG_ERROR $::sdsoc::msg::idSCErrorCallingSimple "Exiting [apc_get_global APCC_COMMAND_NAME] : Error when calling '$command'"
    sdscc_on_exit 1
  }
}

# This proc captures stdout and returns it
proc exec_command_and_capture {command} {
  global verbose redirect
  journal_puts $command
  if {$verbose} {
    puts $command
  }
  log_puts $command
  if { [catch { eval exec $command} err] } {
    # output error message from close the pipe
    # $err contains "child process exited abnormally", which seems to
    # confuse people, so don't print that string
    # puts_command $err
    MSG_ERROR $::sdsoc::msg::idSCErrorCallingCapture "Exiting [apc_get_global APCC_COMMAND_NAME] : Error when calling '$command'"
    sdscc_on_exit 1
  }
  return $err
}

proc lregremove {mylist myregexp} {
  set index [lsearch -regexp $mylist $myregexp]
  set newList [lreplace $mylist $index $index]
  return $newList
}

###############################################################################
# XML interface
###############################################################################

proc xpath_get_value {xml_file xpath} {
  set xsl_file [file join [apc_get_global APCC_PATH_XILINX_XD] scripts xdcc xpathValueOf.xsl]
  set command "[::sdsoc::utils::getCommandPath xsltproc] --stringparam xpath \"$xpath\" $xsl_file $xml_file"
  #puts "COMMAND $command"
  # Escape opening brackets so they don't get evaluated by Tcl interpreter
  regsub -all {\[} $command "\\\[" escaped_command
  #puts "ESCAPED COMMAND $escaped_command"
  catch { eval exec $escaped_command 2>@ stderr } result
  #puts "RESULT $result"
  if {[string equal -nocase $result "child process exited abnormally"]} {
    return ""
  }
  return $result
}

# error out if the value returned by xpath_get_value was undefined
proc check_xpath_value {xml_file xpath value_desc value_str} {
  global xsd_platform

  if {[string length $xsd_platform] < 1} {
    # platform not defined, skip check
    return
  }
  if {[string length $value_str] < 1} {
    MSG_ERROR $::sdsoc::msg::idSCErrorXpath "Error reading $value_desc, XML file $xml_file, xpath $xpath"
    sdscc_on_exit 1
  }
}

proc get_default_clock_id {} {
  global xsd_platform platform_hw_xml
  set xpath "xd:repository/xd:component\[@xd:type='platform']/xd:platformInfo/xd:systemClocks/@xd:defaultClock"
  set val [xpath_get_value $platform_hw_xml $xpath]
  check_xpath_value $platform_hw_xml $xpath "default clock ID for platform ${xsd_platform} (default not defined?)" $val
  return $val
}

proc get_clock_frequency {clk_id} {
  global xsd_platform platform_hw_xml
  set xpath "xd:repository/xd:component\[@xd:type='platform']/xd:platformInfo/xd:systemClocks/xd:clock\[@xd:id=${clk_id}]/@xd:frequency"
  set val [xpath_get_value $platform_hw_xml $xpath]
  check_xpath_value $platform_hw_xml $xpath "clock frequency for clock id $clk_id (clock not defined in XML or missing clock ID?) for platform ${xsd_platform}" $val
  return $val
}

proc get_cpu_frequency {} {
  global xsd_platform platform_hw_xml
    set xpath "xd:repository/xd:component\[@xd:type='platform']/xd:platformInfo/xd:systemClocks/xd:clock\[@xd:name='CPU']/@xd:frequency"
  set val [xpath_get_value $platform_hw_xml $xpath]
  check_xpath_value $platform_hw_xml $xpath "cpu clock frequency (clock not defined in XML or missing clock ID?) for platform ${xsd_platform}" $val
  return $val
}

proc get_clock_period {clk_id} {
  global xsd_platform platform_hw_xml
  set xpath "xd:repository/xd:component\[@xd:type='platform']/xd:platformInfo/xd:systemClocks/xd:clock\[@xd:id=${clk_id}]/@xd:period"
  set val [xpath_get_value $platform_hw_xml $xpath]
  check_xpath_value $platform_hw_xml $xpath "clock period for clock id $clk_id (clock not defined in XML or missing clock ID?) for platform ${xsd_platform}" $val
  return $val
}

proc clock_exists {clk_id} {
  global xsd_platform platform_hw_xml
  set xpath "xd:repository/xd:component\[@xd:type='platform']/xd:platformInfo/xd:systemClocks/xd:clock\[@xd:id=${clk_id}]/@xd:period"
  set val [xpath_get_value $platform_hw_xml $xpath]
  if {[string length $val] < 1} {
    return 0
  }
  return 1
}

proc get_part {} {
  global xsd_platform platform_hw_xml

  set xpath "xd:repository/xd:component\[@xd:type='platform']/xd:platformInfo/xd:deviceInfo/@xd:name"
  set partname [xpath_get_value $platform_hw_xml $xpath]

  if {[string length $partname] > 0} {
    return $partname
  }

  # If there is not a part name, put it together
  set xpath "xd:repository/xd:component\[@xd:type='platform']/xd:platformInfo/xd:deviceInfo/@xd:device"
  set device [xpath_get_value $platform_hw_xml $xpath]
  check_xpath_value $platform_hw_xml $xpath "device name for platform ${xsd_platform}" $device
  set xpath "xd:repository/xd:component\[@xd:type='platform']/xd:platformInfo/xd:deviceInfo/@xd:package"
  set package [xpath_get_value $platform_hw_xml $xpath]
  check_xpath_value $platform_hw_xml $xpath "package name for platform ${xsd_platform}" $package
  set xpath "xd:repository/xd:component\[@xd:type='platform']/xd:platformInfo/xd:deviceInfo/@xd:speedGrade"
  set speedGrade [xpath_get_value $platform_hw_xml $xpath]
  check_xpath_value $platform_hw_xml $xpath "speed grade for platform ${xsd_platform}" $speedGrade
  return ${device}${package}${speedGrade}
}

# .hpfm file (or legacy _hw.pfm file)
proc get_platform_name {platform_xml} {
  set xpath "xd:repository/xd:component\[@xd:type='platform']/@xd:name"
  set val [xpath_get_value $platform_xml $xpath]
  check_xpath_value $platform_xml $xpath "platform name" $val
  return $val
}

# .hpfm file (or legacy _hw.pfm file)
proc get_platform_description {platform_xml} {
  set xpath "xd:repository/xd:description"
  set val [xpath_get_value $platform_xml $xpath]
  check_xpath_value $platform_xml $xpath "platform description" $val
  return $val
}

# Set the platform name using the platform information passed in using
# the -pf <platform_string> command line option.
#
# Prior to restructuring $XILINX_XD/platforms, the -pf value was a simple
# string that was the platform name, e.g. zc702, corresponding to a
# platform folder $XILINX_XD/platforms/zc702 and XML file
# $XILINX_XD/platforms/zc702_v1_0.xml.
#
# After restructuring $XILINX_XD/platforms and to support user-defined
# platforms, the -pf value is a string of the form
# [<user_path>/]<platform>[:<target_os>], where
#
# - if <user_path> is not specified, the platform is found in 
#   $XILINX_XD/platforms/<platform>, as well as its XML file
# - if <user_path> is specified, the platform is found in 
#   <user_path>/<platform>, as well as its XML file
# - it's assumed that the platform folder name <platform> is also
#   the name of the platform, as specified in the XML file
# - if the <target_os> is not specified, it's assumed to be linux (OSL)
# 
proc set_target_os_name {os_string} {
  global target_os_name target_os_type 
  global compile other_syslink_switches

  set target_os_name [string tolower $os_string]
  if {[string first "linux" $target_os_name] >= 0} {
    set target_os_type "linux"
    apc_set_global APCC_TOOLCHAIN_TYPE "linux"
  } elseif {[string first "freertos" $target_os_name] >= 0} {
    set target_os_type "freertos"
    apc_set_global APCC_TOOLCHAIN_TYPE "baremetal"
  } else {
    set target_os_type $target_os_name
    apc_set_global APCC_TOOLCHAIN_TYPE "baremetal"
  }
  if { $compile == 0 } {
    append other_syslink_switches " " -target-os
    append other_syslink_switches " " $target_os_name
  }
}

# helper function for sdslib
proc set_target_cpu_name {cpu_string} {
  switch -nocase $cpu_string {
    microblaze {
      apc_set_global APCC_PFM_PROC         "microblaze_0"
      apc_set_global APCC_PFM_INSTANCE     "microblaze_0"
      apc_set_global APCC_PROC_INSTANCE    "microblaze_0"
      apc_set_global APCC_PFM_TYPE         "microblaze"
      apc_set_global APCC_PROC_TYPE        "microblaze"
      apc_set_global APCC_TOOLCHAIN_CONFIG "microblaze.cfg"
    }
    cortex-a53 {
      apc_set_global APCC_PFM_PROC         "a53_0"
      apc_set_global APCC_PFM_INSTANCE     "psu_cortexa53_0"
      apc_set_global APCC_PROC_INSTANCE    "psu_cortexa53_0"
      apc_set_global APCC_PFM_TYPE         "cortex-a53"
      apc_set_global APCC_PROC_TYPE        "cortex-a53"
      apc_set_global APCC_TOOLCHAIN_CONFIG "zynq_ultrascale.cfg"
    }
    cortex-r5 {
      apc_set_global APCC_PFM_PROC         "r5_0"
      apc_set_global APCC_PFM_INSTANCE     "psu_cortexr5_0"
      apc_set_global APCC_PROC_INSTANCE    "psu_cortexr5_0"
      apc_set_global APCC_PFM_TYPE         "cortex-r5"
      apc_set_global APCC_PROC_TYPE        "cortex-r5"
      apc_set_global APCC_TOOLCHAIN_CONFIG "zynq_ultrascale.cfg"
    }
    cortex-a9  -
    default    {
      apc_set_global APCC_PFM_PROC         "a9_0"
      apc_set_global APCC_PFM_INSTANCE     "ps7_cortexa9_0"
      apc_set_global APCC_PROC_INSTANCE    "ps7_cortexa9_0"
      apc_set_global APCC_PFM_TYPE         "cortex-a9"
      apc_set_global APCC_PROC_TYPE        "cortex-a9"
      apc_set_global APCC_TOOLCHAIN_CONFIG "zynq.cfg"
    }
  }
}

# return the hardware platform XML file
proc resolve_hw_platform_file {xsd_platform} {
  global xsd_platform_path
  set hpfm_file [::sdsoc::pfmx::get_platform_hpfm_file $xsd_platform_path]
  if {[string length $hpfm_file] > 0} {
    return $hpfm_file
  }
  return $hpfm_file
}

# return the software platform XML file
proc resolve_sw_platform_file {xsd_platform} {
  global xsd_platform_path

  set platform_xml ""

  set spfm_file [::sdsoc::pfmx::get_platform_spfm_file $xsd_platform_path]
  if {[string length $spfm_file] > 0} {
    return $spfm_file
  }
  return $spfm_file
}

proc resolve_platform_configuration {xsd_platform reduce_info} {
  global xsd_platform_path
  global target_os_name
  global pf_info

  set pfm_folder $xsd_platform_path
  # test if the platform has legacy platform metadata or not
  set spfm_file [::sdsoc::pfmx::get_platform_spfm_file $pfm_folder]
  if {[string length $spfm_file] < 1} {
    MSG_WARNING $::sdsoc::msg::idSCResolvePlatform "Software platform XML file was not found, unable to resolve platform configuration"
    return
  }

  # platform contains current metadata, platform configuration is set
  set pfm_config [apc_get_global APCC_PFM_CONFIG]
  if {[string length $pfm_config] > 0} {
    set pdict [::sdsoc::pfmx::get_configuration_proc_list $pfm_folder $pfm_config]
    if {[dict size $pdict] > 0} {
      set pfm_proc [apc_get_global APCC_PFM_PROC]
      # -sds-proc was not specified, use the default
      if {[string length $pfm_proc] < 1} {
        set pfm_proc [::sdsoc::pfmx::get_configuration_proc_default $pfm_folder $pfm_config]
        apc_set_global APCC_PFM_PROC $pfm_proc
        set pfm_os [::sdsoc::pfmx::get_configuration_proc_os_name $pfm_folder $pfm_config $pfm_proc]
        set_target_os_name $pfm_os
        return
      }
      # -sds-proc was specified, check if it exists
      if {[::sdsoc::pfmx::configuration_proc_exists $pfm_folder $pfm_config $pfm_proc]} {
        set pfm_os [::sdsoc::pfmx::get_configuration_proc_os_name $pfm_folder $pfm_config $pfm_proc]
        set_target_os_name $pfm_os
        return
      }
      MSG_ERROR $::sdsoc::msg::idSCProcGroupNotFound "Platform configuration processor group -sds-proc $pfm_proc was not found"
      ::sdsoc::pfmx::print_platform_info $pfm_folder 0
      sdscc_on_exit 1
    }
      
    MSG_ERROR $::sdsoc::msg::idSCPlatformConfigNotFound "Platform configuration -sds-sys-config $pfm_config was not found"
    ::sdsoc::pfmx::print_platform_info $pfm_folder 0
    sdscc_on_exit 1
  }

  # if the platform configuration is not set, find one with the
  # matching the target_os_name
  if {! $reduce_info} {
  MSG_PRINT "Platform system configuration option -sds-sys-config was not specified, searching for a configuration that uses the specified OS $target_os_name"
  }

  set cfgdict [::sdsoc::pfmx::get_configuration_list $pfm_folder]
  set config_found 0
  set lc_target_os_name [string tolower $target_os_name]
  dict for {ckey cname} $cfgdict {
    set pdict [::sdsoc::pfmx::get_configuration_proc_list $pfm_folder $cname]
    dict for {pkey pname} $pdict {
      set odict [::sdsoc::pfmx::get_configuration_proc_os_info $pfm_folder $cname $pname]
      dict for {okey oname} $odict {
          set lc_oname [string tolower $oname]
          if {[string equal "sdx:name" $okey] &&
              [string first $lc_target_os_name $lc_oname] >= 0} {
            apc_set_global APCC_PFM_CONFIG $cname
            apc_set_global APCC_PFM_PROC $pname
            set pfm_os [::sdsoc::pfmx::get_configuration_proc_os_name $pfm_folder $cname $pname]
            set_target_os_name $pfm_os
            if {! $reduce_info} {
            MSG_PRINT "Using system configuration -sds-sys-config $cname"
            }
            return
          }
      }
    }
  }

  # if the platform configuration is not found, use the default

  set user_os_name $target_os_name

  set pfm_config [::sdsoc::pfmx::get_configuration_default $pfm_folder]
  apc_set_global APCC_PFM_CONFIG $pfm_config
  set pfm_proc [::sdsoc::pfmx::get_configuration_proc_default $pfm_folder $pfm_config]
  apc_set_global APCC_PFM_PROC $pfm_proc
  set pfm_os [::sdsoc::pfmx::get_configuration_proc_os_name $pfm_folder $pfm_config $pfm_proc]
  set_target_os_name $pfm_os

  if {! $pf_info} {
    MSG_PRINT "Platform system configuration not found for the specified OS $user_os_name, using the default -sds-sys-config $pfm_config which uses the OS $pfm_os"
  }
}

proc emu_is_supported {} {
  global xsd_platform_path

  set pfm_handle $xsd_platform_path
  set pfm_config [apc_get_global APCC_PFM_CONFIG]
  set is_supported [::sdsoc::pfmx::emulation_is_supported $pfm_handle $pfm_config]
  return $is_supported
}

proc set_perf_funcs_string {funcs} {
    global perf_funcs
    set perf_funcs $funcs
}

proc set_perf_root_string {rootfunc} {
    global perf_root
    set perf_root $rootfunc
}

proc set_perf_est_string {estfilename} {
    global perf_sw_file
    set perf_sw_file $estfilename
    MSG_PRINT "Starting performance estimation. This may take a few minutes"
}

proc has_xsd_platform {} {
  global xsd_platform

  if {[string length $xsd_platform] > 1} {
    return 1
  }
  return 0
}

proc set_xsd_platform {platform_string} {
  global run_dir
  global target_os_name xsd_platform xsd_platform_path

  # Save the platform string and work with that
  set user_platform $platform_string

  # Extract target OS, if specified, and update the platform string.
  # The colon ':' should bet the last one, so it doesn't match
  # the Windows path ':' if any, e.g. C:/foo/bar
  set os_index [string last ":" $user_platform]
  if {$os_index > 1} {
    set_target_os_name [string range $user_platform [expr {$os_index + 1}] end]
    set user_platform [string range $user_platform 0 [expr {$os_index - 1}]]
  }

  # save the actual platform name (no path components)
  set xsd_platform [file tail $user_platform]
  apc_set_global APCC_PLATFORM_VALUE ${platform_string}
  apc_set_global APCC_PLATFORM_NAME ${xsd_platform}

  # save platform path, if specified, or use the installation path
  if {[file exists $user_platform]} {
    set xsd_platform_path [file join $run_dir $user_platform]
  } else {
    set xsd_platform_path [file join [apc_get_global APCC_PATH_XILINX_XD] platforms $xsd_platform]
  }
  apc_set_global APCC_PLATFORM_PATH ${xsd_platform_path}

# puts "os $target_os_name pf $xsd_platform path $xsd_platform_path"
}

# In the platform XML file, include and library paths a specified
# relative to the platform directory. If the path contains a leading
# '/' (forward slash character), the path is relative to the SDSoC
# installation path.

proc set_pf_path {path_string} {
  global xsd_platform_path

  if {[string length $path_string] < 1} {
    return $path_string
  }
  if {[string match "/*" $path_string]} {
    set resolved_path [file join [apc_get_global APCC_PATH_XILINX_XD] [string replace $path_string 0 0]]
  } else {
    set resolved_path [::sdsoc::pfmx::get_platform_spfm_param_path $xsd_platform_path $path_string]
  }
  return $resolved_path
}

#gets the include path out of the compiler for x86
proc setup_x86 {} {
    global compiler toolchain
    #setup command to cause gcc/g++ to spew includes info
    set cmd "echo \"main(){}\" | [get_cc] -xc - -v -E"

    #run command, capture output
    catch { open "| $cmd 2>@1" "r+"} pipe
    fconfigure $pipe -buffering none
    set output ""
    while { [gets $pipe data] >= 0 } {
	set output "${output}\n$data"
    }
    catch {close $pipe} err

    #find the include path
    set start "#include <...> search starts here:"
    set include_start [string first $start $output]
    set end_line [string first "\n" $output $include_start]
    #find the end of the includes
    set stop "End of search list."
    set next_line [string first $stop $output [expr $end_line + 1]]
    set include [string range $output [expr $end_line + 1] [expr $next_line - 1]]
    set include [regexp -inline -all -- {\S+} $include]
    return [split $include]
}

proc set_pf_proc_info {platform_xml} {
  global xsd_platform_path
  global run_boot_files

  set pfm_handle $xsd_platform_path
  set pfm_config [apc_get_global APCC_PFM_CONFIG]
  set pfm_proc [apc_get_global APCC_PFM_PROC]
  set pfmdict [::sdsoc::pfmx::get_configuration_proc_info $pfm_handle $pfm_config $pfm_proc]
  if {[dict size $pfmdict] < 1} {
    return
  }
  dict for {pfmkey pfminfo} $pfmdict {
    switch -nocase $pfmkey {
      sdx:displayName { apc_set_global APCC_PROC_DESC     $pfminfo }
      sdx:cpuType     {
                        apc_set_global APCC_PROC_TYPE     $pfminfo
                        switch $pfminfo {
                          cortex-a9 {
                            apc_set_global APCC_TOOLCHAIN_CONFIG "zynq.cfg"
                            apc_set_global APCC_TOOLCHAIN_NAME "arm-linaro"
                          }
                          cortex-a53 -
                          cortex-r5 {
                            apc_set_global APCC_TOOLCHAIN_CONFIG "zynq_ultrascale.cfg"
                            apc_set_global APCC_TOOLCHAIN_NAME "arm-linaro"
                          }
                          microblaze {
                            apc_set_global APCC_TOOLCHAIN_CONFIG "microblaze.cfg"
                            apc_set_global APCC_TOOLCHAIN_NAME "mb-gcc"
                            set run_boot_files 0
                          }
                          x86 {
                            apc_set_global APCC_TOOLCHAIN_CONFIG "x86.cfg"
                            apc_set_global APCC_TOOLCHAIN_NAME "gcc"
                            set run_boot_files 0
                          }
                          default {
    MSG_ERROR $::sdsoc::msg::idSCPlatformUnrecognized "Platform in $pfm_handle: software platform sdx:cpuType value $pfminfo not recognized, expecting cortex-a9, cortex-a53 or cortex-r5"
                            sdscc_on_exit 1
                          }
                        }
      }
      sdx:cpuInstance { apc_set_global APCC_PROC_INSTANCE $pfminfo }
    }
  }
}

proc set_pf_toolchain_info {platform_xml} {
  global xsd_platform_path

  set pfm_handle $xsd_platform_path
  set pfm_config [apc_get_global APCC_PFM_CONFIG]
  set pfm_proc [apc_get_global APCC_PFM_PROC]
  set pfmdict [::sdsoc::pfmx::get_configuration_proc_os_info $pfm_handle $pfm_config $pfm_proc]
  if {[dict size $pfmdict] < 1} {
    return
  }
  dict for {pfmkey pfminfo} $pfmdict {
    switch -nocase $pfmkey {
      sdx:crossCompilerType { apc_set_global APCC_TOOLCHAIN_TYPE   $pfminfo }
      sdx:toolConfig        { apc_set_global APCC_TOOLCHAIN_CONFIG $pfminfo }
    }
  }
}

proc spfm_assert_path_is_directory { pattribute pvalue ppath pcontext } {
  if {! [file isdirectory $ppath]} {
    MSG_ERROR $::sdsoc::msg::idSCSpfmNotDir "Software platform XML error, expecting a directory for $pattribute, value $pvalue is not a directory $ppath, $pcontext"
    sdscc_on_exit 1
  }
}

proc spfm_assert_path_is_file { pattribute pvalue ppath pcontext } {
  if {! [file isfile $ppath] } {
    MSG_ERROR $::sdsoc::msg::idSCSpfmNotFile "Software platform XML error, expecting a file for $pattribute, value $pvalue is not a file $ppath, $pcontext"
    sdscc_on_exit 1
  }
}

proc spfm_exit_path_invalid { pattribute pvalue ppath pcontext } {
  MSG_ERROR $::sdsoc::msg::idSCSpfmPathNotExist "Software platform XML error, $pattribute value $pvalue path does not exist $ppath, $pcontext"
  sdscc_on_exit 1
}

proc set_pf_library_files {platform_xml} {
  global xsd_platform_path

  # initialize software parameters
  set param_list { APCC_LFLAGS_PLATFORM
                   APCC_LPATHS_PLATFORM
                   APCC_IFLAGS_PLATFORM
                   APCC_OS_LINKER_LIBRARY_NAME
                   APCC_LINKER_SCRIPT
                   APCC_BSP_CONFIGURATION_MSS
                   APCC_BSP_REPOSITORY_PATH
  }
  foreach param $param_list {
    apc_set_global $param ""
  }
  # load software platform information
  set pfm_handle $xsd_platform_path
  set context "platform path $pfm_handle"
  set pfm_config [apc_get_global APCC_PFM_CONFIG]
  if {[string length $pfm_config] < 1} {
    MSG_ERROR $::sdsoc::msg::idSCSpfmConfigError "Software platform XML error reading system configuration metadata for $context"
    sdscc_on_exit 1
  }
  append context ", sdx:configuration $pfm_config"
  set pfm_proc   [apc_get_global APCC_PFM_PROC]
  set pfmdict [::sdsoc::pfmx::get_configuration_proc_os_info $pfm_handle $pfm_config $pfm_proc]
  if {[dict size $pfmdict] < 1} {
    MSG_ERROR $::sdsoc::msg::idSCSpfmProcGroupError "Software platform XML error reading processor group metadata for $context"
    sdscc_on_exit 1
  }
  append context ", sdx:processorGroup $pfm_proc"
  # sdx:name
  # sdx:displayName
  # sdx:osDependency

  # sdx:crossCompilerType
  # sdx:toolConfig

  # sdx:compilerOptions
  # sdx:linkerOptions

  # sdx:sysRoot

  ## sdx:includePaths
  ## sdx:libraryPaths
  ## sdx:libraryNames
  ## sdx:ldscript
  ## sdx:bspConfig
  ## sdx:bspRepo
  dict for {pfmkey pfminfo} $pfmdict {
    switch -nocase $pfmkey {
      sdx:includePaths {
        set include_string ""
        set include_list [split $pfminfo :]
        foreach incl $include_list {
          set includeDir [set_pf_path $incl]
          if { ! [file exists $includeDir]} {
            spfm_exit_path_invalid $pfmkey $incl $includeDir $context
          } else {
            spfm_assert_path_is_directory $pfmkey $incl $includeDir $context
          }
          append include_string " -I $includeDir"
        }
        apc_set_global APCC_IFLAGS_PLATFORM $include_string
      }
      sdx:libraryPaths {
        set path_count 0
        set lflags_string ""
        set lpaths_string ""
        set lpath_list [split $pfminfo :]
        foreach lpath $lpath_list {
          set libDir [set_pf_path $lpath]
          append lflags_string " -L $libDir"
          if {$path_count > 0} {
            # this will be used to split the list later, and can't use ':'
            # because that's part of the Windows paths
            append lpaths_string ";"
          }
          if { ! [file exists $libDir]} {
            spfm_exit_path_invalid $pfmkey $lpath $libDir $context
          } else {
            spfm_assert_path_is_directory $pfmkey $lpath $libDir $context
          }
          append lpaths_string "$libDir"
          incr path_count
        }
        apc_set_global APCC_LFLAGS_PLATFORM $lflags_string
        apc_set_global APCC_LPATHS_PLATFORM $lpaths_string
      }
      sdx:libraryNames {
        set libName $pfminfo
        apc_set_global APCC_OS_LINKER_LIBRARY_NAME $libName
      }
      sdx:ldscript {
        apc_set_global APCC_USE_STANDALONE_BSP 1
        set pf_file [::sdsoc::pfmx::get_platform_spfm_param_path $xsd_platform_path $pfminfo]
        if { [file exists $pf_file] } {
          apc_set_global APCC_LINKER_SCRIPT $pf_file
        } else {
          spfm_exit_path_invalid $pfmkey $pfminfo $pf_file $context
        }
        spfm_assert_path_is_file $pfmkey $pfminfo $pf_file $context
      }
      sdx:bspConfig {
        set pf_file [::sdsoc::pfmx::get_platform_spfm_param_path $xsd_platform_path $pfminfo]
        if { [file exists $pf_file] } {
          apc_set_global APCC_BSP_CONFIGURATION_MSS $pf_file
        } else {
          spfm_exit_path_invalid $pfmkey $pfminfo $pf_file $context
        }
        spfm_assert_path_is_file $pfmkey $pfminfo $pf_file $context
      }
      sdx:bspRepo {
        set path_count 0
        set rpaths_string ""
        set rpath_list [split $pfminfo :]
        foreach rpath $rpath_list {
          set repodir [::sdsoc::pfmx::get_platform_spfm_param_path $xsd_platform_path $rpath]
          if { [file exists $repodir] } {
            if {$path_count > 0} {
              # space separated paths for hsi::set_repo_path
              append rpaths_string " "
            }
            spfm_assert_path_is_directory $pfmkey $rpath $repodir $context
            append rpaths_string "$repodir"
            incr path_count
          } else {
            spfm_exit_path_invalid $pfmkey $rpath $repodir $context
          }
        }
        if {$path_count > 0} {
          apc_set_global APCC_BSP_REPOSITORY_PATH $rpaths_string
        }
      }

    # end of switch
    }
  }
  if {[string length [apc_get_global APCC_USER_LINKER_SCRIPT]] > 1} {
    apc_set_global APCC_LINKER_SCRIPT [apc_get_global APCC_USER_LINKER_SCRIPT]
  }
  
  # workaround for FreeRTOS if .spfm does not specify sdx:libraryNames
  global target_os_type
  if {[string equal -nocase $target_os_type "freertos"]} {
    if {[string length [apc_get_global APCC_OS_LINKER_LIBRARY_NAME]] < 1} {
      apc_set_global APCC_OS_LINKER_LIBRARY_NAME "freertos"
    }
  }
}

proc set_boot_param {param_name param_path is_dir context pfm_attribute} {
  global xsd_platform xsd_platform_path

  set pf_file [::sdsoc::pfmx::get_platform_spfm_path $xsd_platform_path]
  set path_list [split ${param_path} "/"]
  foreach path_part $path_list {
    set pf_file [file join ${pf_file} ${path_part}]
  }
  if {[file exists $pf_file]} {
    apc_set_global $param_name $pf_file
  } else {
    spfm_exit_path_invalid $pfm_attribute $param_path $pf_file $context
  }
  if {$is_dir} {
    spfm_assert_path_is_directory $pfm_attribute $param_path $pf_file $context
  } else {
    spfm_assert_path_is_file $pfm_attribute $param_path $pf_file $context
  }
}

proc set_pf_boot_files {platform_xml} {
  global xsd_platform xsd_platform_path

  # initialize boot values
  set param_list { APCC_BOOT_BIF_TEMPLATE
  }
  foreach param $param_list {
    apc_set_global $param ""
  }

  # if the platform is not defined, nothing to be done
  if {[string length $xsd_platform] < 1} {
    return
  }
  # software platform XML
  set context "platform path $xsd_platform_path"
  set pf_config [apc_get_global APCC_PFM_CONFIG]
  if {[string length $pf_config] < 1} {
    MSG_ERROR $::sdsoc::msg::idSCSpfmConfigElement "Unable to read software platform XML system configuration element, $context"
    sdscc_on_exit 1
  }
  append context ", sdx:configuration $pf_config"
    #check if this is not an x86 config
    if {![string equal [sdsoc::pfmx::get_configuration_proc_default_cpuType $xsd_platform_path $pf_config] "x86"]} {    
        set sdsImageOpt [apc_get_global APCC_PFM_IMAGE]
        if {[string length $sdsImageOpt] > 0} {
	  set msgId $::sdsoc::msg::idSCSpfmImage
	  set pf_image $sdsImageOpt
	  if {! [sdsoc::pfmx::is_configuration_image $xsd_platform_path $pf_config $pf_image]} {
            set pfmdict [::sdsoc::pfmx::get_configuration_image_list $xsd_platform_path $pf_config]
	    if {[dict size $pfmdict] < 1} {
              set imageList "none found"
            } else {
              set imageList ""
	      dict for {pfmkey pfminfo} $pfmdict {
                append imageList "$pfminfo "
              }
            }
	    MSG_ERROR $msgId "Unable to find software platform XML image specified using -sds-image $sdsImageOpt, $context. Available image names: $imageList"
	    sdscc_on_exit 1
	  }
        } else {
	  set msgId $::sdsoc::msg::idSCSpfmImageDefault
	  set pf_image  [sdsoc::pfmx::get_configuration_image_default $xsd_platform_path $pf_config]
	  if {[string length $pf_image] < 1} {
	    MSG_ERROR $msgId "Unable to find software platform XML image default, $context"
	    sdscc_on_exit 1
	  }
        }
	append context ", sdx:image $pf_image"
	set pfmdict [sdsoc::pfmx::get_configuration_image_info $xsd_platform_path $pf_config $pf_image]
	if {[dict size $pfmdict] < 1} {
	    MSG_ERROR $::sdsoc::msg::idSCSpfmImageError "Unable to read software platform XML sdx:image metadata for $context"
	    sdscc_on_exit 1
	}
	dict for {pfmkey pfminfo} $pfmdict {
	    switch -nocase $pfmkey {
		sdx:bif
		{set_boot_param APCC_BOOT_BIF_TEMPLATE    $pfminfo 0 $context $pfmkey}
		sdx:mountPath 
		{apc_set_global APCC_SDCARD_MOUNT_DIRECTORY $pfminfo}
	    }
	}
    }
}

proc set_pf_hardware_files {platform_xml} {
  global xsd_platform xsd_platform_path

  apc_set_global APCC_PREBUILT_AVAILABLE 0
  apc_set_global APCC_PREBUILT_DATA_FOLDER ""

  # if the platform is not defined, nothing to be done
  if {[string length $xsd_platform] < 1} {
    return
  }

  set context "platform path $xsd_platform_path"
  set pf_config [apc_get_global APCC_PFM_CONFIG]
  if {[string length $pf_config] < 1} {
    MSG_ERROR $::sdsoc::msg::idSCSpfmSysConfig "Unable to read software platform XML system configuration element, $context"
    sdscc_on_exit 1
  }
  append context ", sdx:configuration $pf_config"
  set pb_path [::sdsoc::pfmx::get_configuration_prebuilt_folder $xsd_platform_path $pf_config]
  if {[string length $pb_path] < 1} {
    return
  }
  if {! [file exists $pb_path] } {
    spfm_exit_path_invalid "sdx:prebuilt" "found for" $pb_path $context
  }
  spfm_assert_path_is_directory "sdx:prebuilt" "found" $pb_path $context
  apc_set_global APCC_PREBUILT_DATA_FOLDER $pb_path
  apc_set_global APCC_PREBUILT_AVAILABLE 1
}

# Call with either auxiliary.xml (HLS)
# TO DO: Clean this up as part of flow cleanup.  Should be same mechanism throughout code base
proc check_ip_requires_adapter {metadata_xml} {
  #puts "metadata_xml = $metadata_xml"
  set xpath "boolean(/xd:acceleratorMap/xd:controlReg/@xd:type='acc_handshake')"
  set requires_stream_adapter [xpath_get_value $metadata_xml $xpath]
  # puts "requires_stream_adapter = $requires_stream_adapter"
  if {$requires_stream_adapter == true} {
    return 1
  }
  return 0
}

# Call with either auxiliary.xml (HLS)
# TO DO: Clean this up as part of flow cleanup.  Should be same mechanism throughout code base
proc check_rtl_ip_requires_adapter {metadata_xml} {
  #puts "metadata_xml = $metadata_xml"
  set xpath "boolean(/xd:repository/xd:fcnMap/xd:ctrlReg/@xd:type='axis_acc_adapter')"
  set requires_stream_adapter [xpath_get_value $metadata_xml $xpath]
  if {$requires_stream_adapter == true} {
    return 1
  }
  return 0
}

# Read XML file produced by XidanePass containing caller rewrite information
# and extract the number of files which need to be rewritten. The XML file
# in _sds/.llvm/caller_rewrites.xml looks like this:
#
# <?xml version="1.0"?>
# <xd:XidanePass xd:num_rewrites="1" xmlns:xd="http://www.xilinx.com/xd">
#   <xd:caller xd:no="0" xd:file="/proj/fv7/tshui/xidane/test/test_add/main.cpp" xd:rewrite="caller0.cfrewrite"/>
# </xd:XidanePass>

proc get_num_rewrites {rewrite_xml} {
  if {[file exists $rewrite_xml]} {
    return [xpath_get_value $rewrite_xml "number(/xd:XidanePass/@xd:num_rewrites)"]
  } else {
    return 0
  }
}

# Given an object file name (.o), search a list of object files with
# full path names and return the path to the object file if found.
proc get_obj_file {obj_list obj_target} {
  foreach obj_current $obj_list {
    set obj_current_tail [file tail $obj_current]
    set obj_target_tail [file tail $obj_target]
    if {[string equal $obj_current_tail $obj_target_tail]} {
      return $obj_current
    }
  }
  return ""
}

proc get_num_partitions {partitions_xml} {
  if {[file exists $partitions_xml]} {
    return [xpath_get_value $partitions_xml "number(/xd:XidanePass/@xd:num_partitions)"]
  } else {
    return 0
  }
}

proc get_partitions {partitions_xml} {
  set partitions [list]
  set num_partitions [get_num_partitions $partitions_xml]
  for {set i 1} {$i <= $num_partitions} {incr i} {
    set xpath "/xd:XidanePass/xd:file\[$i]/@xd:name"
    set part_name [xpath_get_value $partitions_xml $xpath]
    set xpath "/xd:XidanePass/xd:file\[$i]/@xd:partition"
    set part_num [xpath_get_value $partitions_xml $xpath]
    lappend partitions $part_num $part_name
  }
  return $partitions
}

proc get_first_partition {partitions_xml} {
  set partitions [get_partitions $partitions_xml]
  set first_partition [lindex [dict keys $partitions] 0]
  return $first_partition
}

# Clean up any old partition directories with numbers higher than
# the current partition count
proc remove_old_partitions {num_partitions} {
  global sdscc_dir

  set prev_part_dirs [glob -nocomplain -type d [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]*]]
  foreach prev_part_dir $prev_part_dirs {                                                         
    regsub [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]] $prev_part_dir "" prev_part_num
    if [expr $prev_part_num >= $num_partitions] {
      MSG_PRINT "Deleting previous partition directory $prev_part_dir"
      delete_directory $prev_part_dir
    }
  }
}

set enable_multi_partition 0

proc combine_partition_portinfo { sdsroot bsroot partitions_xml } {
  global enable_multi_partition insert_trace_hw hasTrace_dir sdscc_dir num_trace_cores found_hw_trace trace_axilite

  set num_partitions [get_num_partitions $partitions_xml]
  set partitions [get_partitions $partitions_xml]
  set first_partition [get_first_partition $partitions_xml]
  foreach fname [list portinfo.h portinfo.c] {
    set subfiles [glob -nocomplain -type f [file join ${sdsroot} [apc_get_global APCC_DIR_SDS_PART]* [apc_get_global APCC_DIR_SDS_PART_CFWORK] ${fname}]]
    if {[llength $subfiles] != $num_partitions} {
      MSG_ERROR $::sdsoc::msg::idSCMissingPortinfo "ERROR: number of files $fname ([llength $subfiles]) does not match number of partitions ($num_partitions)"
      sdscc_on_exit 1
    }
    set fp [open [file join $sdsroot [apc_get_global APCC_DIR_SDS_SWSTUBS] $fname] w]
    if {[string equal $fname portinfo.h]} {
      puts $fp "\#ifndef _SDS_PORTINFO_H"
      puts $fp "\#define _SDS_PORTINFO_H"
    }
    foreach subfile [glob -nocomplain -type f [file join ${sdsroot} [apc_get_global APCC_DIR_SDS_PART]* [apc_get_global APCC_DIR_SDS_PART_CFWORK] ${fname}]] {
      puts $fp "/* File: ${subfile} */"
      set next [open $subfile r]
      fcopy $next $fp
      close $next
    }
    if {[string equal $fname portinfo.c]} {
#      puts $fp "#define TOTAL_PARTITIONS $num_partitions"
#      puts $fp "int current_partition_num = 0;"
#      puts $fp "struct {"
#      puts $fp "  void (*open)(int);"
#      puts $fp "  void (*close)(int);"
#      puts $fp "}"
#      puts $fp "\n_ptable\[TOTAL_PARTITIONS\]  = {"
#      foreach part [dict keys $partitions] {
#        puts $fp "    {.open = &_p${part}_cf_framework_open, .close= &_p${part}_cf_framework_close}, "
#      }
#      puts $fp "};"
#      puts $fp "\nvoid switch_to_next_partition(int partition_num)"
#      puts $fp "{"
#      puts $fp "#ifdef __linux__"
#      puts $fp "  if (current_partition_num != partition_num) {"
#      puts $fp "    _ptable\[current_partition_num\].close(0);"
#      puts $fp "    char buf\[128\];"
#      puts $fp "    sprintf(buf, \"cat ${bsroot}/_p%d_.bin > /dev/xdevcfg\", partition_num);"
#      puts $fp "    system(buf);"
#      puts $fp "    _ptable\[partition_num\].open(0);"
#      puts $fp "    current_partition_num = partition_num;"
#      puts $fp "  }"
#      puts $fp "#endif"
#      puts $fp "}"
      puts $fp "\nvoid init_first_partition() __attribute__ ((constructor));"
      puts $fp "void close_last_partition() __attribute__ ((destructor));"
      puts $fp "void init_first_partition()"
      puts $fp "{"
      puts $fp "    _p${first_partition}_cf_framework_open(1);"
#      if {$enable_multi_partition} {
#	  puts $fp "#ifdef __linux__"
#	  puts $fp "    char buf\[128\];"
#	  puts $fp "    sprintf(buf, \"cat ${bsroot}/_p${first_partition}_.bin > /dev/xdevcfg\");"
#	  puts $fp "    system(buf);"
#	  puts $fp "#endif"
#      }
#      puts $fp "    current_partition_num = 0;"
#      puts $fp "    _ptable\[current_partition_num\].open(1);"
      puts $fp ""
      if {$insert_trace_hw || $found_hw_trace} {
	  #check that file exists (might have not traced anythign after cf2xd)
	  if {![file exists [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${first_partition} [apc_get_global APCC_DIR_SDS_CFWORK] ".hwTraceInfo"]]} {
	      MSG_ERROR 2 "Tracing is enabled for the project, but no cores were able to be traced. Please rebuild without tracing enabled"
	      sdscc_on_exit 1
	  }

	  set addrFile [open [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${first_partition} [apc_get_global APCC_DIR_SDS_CFWORK] ".hwTraceInfo"] r]
	  set file_data [read $addrFile]
	  close $addrFile
	  set file_lines [split $file_data "\n"]
	  puts $fp "    trace_monitor_base_addr = 0x[lindex $file_lines 1];"
	  puts $fp "    trace_num_cores = $num_trace_cores;"
	  if {$trace_axilite} {
	      puts $fp "    trace_fifo_reg_addr = 0x[lindex $file_lines 0];"
	  }
      }
      puts $fp "    sds_trace_setup();"
      puts $fp "}"
      puts $fp "\n\nvoid close_last_partition()"
      puts $fp "{"
      puts $fp "     _p${first_partition}_cf_framework_close(1);"
      puts $fp "#ifdef PERF_EST"
      puts $fp "    apf_perf_estimation_exit();"
      puts $fp "#endif"
      puts $fp "    sds_trace_cleanup();"
#      puts $fp "    _ptable\[current_partition_num\].close(1);"
#      puts $fp "    current_partition_num = 0;"
      puts $fp "}\n"
    }
    if {[string equal $fname portinfo.h]} {
      puts $fp "\#ifdef __cplusplus"
      puts $fp "extern \"C\" \{"
      puts $fp "\#endif"
#      puts $fp "void switch_to_next_partition(int);"
#      puts $fp "void init_first_partition();"
#      puts $fp "void close_last_partition();"
      if {$insert_trace_hw || $found_hw_trace} {
	  puts $fp "extern unsigned trace_monitor_base_addr;"
	  puts $fp "extern unsigned trace_num_cores;"
	  if {$trace_axilite} {
	      puts $fp "extern unsigned trace_fifo_reg_addr;"
	  }
      }
      puts $fp "\#ifdef __cplusplus"
      puts $fp "\};"
      puts $fp "\#endif /* extern \"C\" */"
      puts $fp "\#endif /* _SDS_PORTINFO_H_ */"
    }
    close $fp
  }
}

###############################################################################
# Globals
###############################################################################

# User environment variables to override or set command line options.
# These are applied after parsing command line options (additive).
set apc(SDS_CFLAGS) ""
if {[info exists ::env(SDSCC_CFLAGS)]} {
  set apc(SDS_CFLAGS) $::env(SDSCC_CFLAGS)
  MSG_WARNING $::sdsoc::msg::idSCEnvCflags "User-defined flags set with SDSCC_CFLAGS environment variable $apc(SDS_CFLAGS)"
}

set apc(RDI_FLAGS) ""
if {[info exists ::env(RDI_SDSOC_FLAGS)]} {
  set apc(RDI_FLAGS) $::env(RDI_SDSOC_FLAGS)
  MSG_WARNING $::sdsoc::msg::idSCEnvLflags "User-defined flags set with RDI_SDSOC_FLAGS environment variable $apc(RDI_FLAGS)"
}

set apc(SDS_LFLAGS) ""
if {[info exists ::env(SDSCC_LFLAGS)]} {
  set apc(SDS_LFLAGS) $::env(SDSCC_LFLAGS)
  MSG_WARNING $::sdsoc::msg::idSCEnvLflags "User-defined flags set with SDSCC_LFLAGS environment variable $apc(SDS_LFLAGS)"
}

# Set default options
#set to the vlnv component name, e.g., xd_adapter
set accels {}
set compile 0
set run_hls 0
set hls_log_list [list]
set perf_prepass 0
set perf_est 0
set run_boot_files 1
set run_apf_clean 1
set run_sdslint 1
set run_bitstream 1
set run_test_link 1
set run_emulation_export 0
set emulation_mode "optimized"
set insert_apm 0
set trace_axilite 0
set trace_burst 0
set insert_trace_hw 0
set insert_trace_sw 0
set num_trace_cores 0
set trace_depth 1024
set found_sw_trace 0
set found_hw_trace 0
set disable_multi_clks 0
set debug 0
set debug_hls 0
set debug_xlnk 0
set optimize_flag ""
set verbose 0
set pf_info 0
set pf_list 0
array set accelmap_clkid {}
array set accelmap_hls_tcl_directive_file {}
array set accelmap_hls_subfile_list {}
set clk_id ""
set shared_aximm 0
set help 0
set version 0
set infiles ""
set ininclpaths ""
set inlibs ""
set inlibpaths ""
set outfile ""
set outfile_str ""
set other_switches ""
set other_mf_mt_switches ""
set other_pragmagen_switches ""
set other_xidanepass_switches ""
set other_syslink_switches ""
set other_vpl_switches ""
set xsd_platform_path ""
set xsd_platform ""
set redirect ""
set hls_tcl_directive_file ""
set hls_subfile_list {}
set llvm_link_exclude_list ""
set lib_asms {}
set vlnv ""
set platform_func 0
set shared 0
set target_os_name "linux"
set target_os_type "linux"
set fcnmap_file ""
set params_file ""
set perf_root "__nil__"
# IP repository search list for RTL IP
#   ip_repo_dir_list     - final search list
#   ip_repo_option_list  - command line list
#   ip_repo_default_list - default search list (built-in)
set ip_repo_dir_list {}
set ip_repo_option_list {}
set ip_repo_default_list {}
lappend ip_repo_default_list [file join [apc_get_global APCC_PATH_VIVADO_ROOT] data ip]
if {[info exists ::env(RDI_DATADIR)]} {
  set rdi_datadir_list [split $::env(RDI_DATADIR) ":"]
  foreach rdi_datadir $rdi_datadir_list {
    lappend ip_repo_default_list [file join $rdi_datadir ip]
  }
}
set partitions [list]

set backup_accels {}
set backup_run_hls 0
set backup_perf_prepass 0
set backup_perf_est 0

# The dev_* variables allow different phases of the flow to be skipped under
# user control. Setting the vars to 0 allows that particular phase to be
# skipped, assuming that it has been successfully run once before
set dev_run_software_only 0
set dev_run_hls 1
set dev_run_llvm 1
set dev_run_xsd 1
set dev_dmtest_early_exit 0
set dev_run_swgen 1
set dev_run_log 1
set dev_run_pragmagen 1
set use_hls_adapter 1

# rebuild hardware for a design that contains no hardware functions
# and the user doesn't want to use prebuilt hardware included with
# a platform
set rebuild_empty_hardware 0

# exit on error conditions, force continue if 0
set dev_run_exit 1

# Xidane repository file passed to system_linker
set xd_ip_database ""

###############################################################################
# Synthesis and implementation options
###############################################################################
apc_set_global APCC_SYNTH_STRATEGY_DEFAULT    "default"
apc_set_global APCC_SYNTH_STRATEGY [apc_get_global APCC_SYNTH_STRATEGY_DEFAULT]
apc_set_global APCC_IMPL_STRATEGY_DEFAULT     "default"
apc_set_global APCC_IMPL_STRATEGY  [apc_get_global APCC_IMPL_STRATEGY_DEFAULT]

proc set_synth_strategy {strategy_name} {
  set synthName [::sdsoc::opt::findSynthStrategy $strategy_name]
  if {[string length $synthName] > 0} {
    apc_set_global APCC_SYNTH_STRATEGY $synthName
  } else {
    MSG_WARNING $::sdsoc::msg::idSCBadSynthOpt "Unrecognized synthesis option -synth-strategy $strategy_name, errors may occur. The strategy name is expected to be one of the following: [::sdsoc::opt::getSynthStrategyList]"
    apc_set_global APCC_SYNTH_STRATEGY $strategy_name
  }
}

proc set_impl_strategy {strategy_name} {
  set implName [::sdsoc::opt::findImplStrategy $strategy_name]
  if {[string length $implName] > 0} {
    apc_set_global APCC_IMPL_STRATEGY $implName
  } else {
    MSG_WARNING $::sdsoc::msg::idSCBadImplOpt "Unrecognized implementation option -impl-strategy $strategy_name, errors may occur. The strategy name is expected to be one of the following: [::sdsoc::opt::getImplStrategyList]"
    apc_set_global APCC_IMPL_STRATEGY $strategy_name
  }
}

###############################################################################
# Internal debugging function
###############################################################################

# allow exit to be overridden
proc exit_with_override {ec} {
  global dev_run_exit

  # normally, just exit
  if {$dev_run_exit} {
    sdscc_on_exit $ec
  }
  # otherwise, print a message
  MSG_WARNING $::sdsoc::msg::idSCExitOverride "internal option -mdev-no-exit used to override exit.\nExecution continuing, but results may be incorrect."
}

###############################################################################
# Process command line options in blocks, passed in via environment varaiables
###############################################################################
set SDS_HW_BLOCK    [apc_get_global APCC_OPT_HW_BLOCK]
set SDS_END_BLOCK   [apc_get_global APCC_OPT_END_BLOCK]

proc pre_process_argv {} {
  global SDS_HW_BLOCK SDS_END_BLOCK
  global argc argv compile

  set apargc 0
  set apargv ""

  set block_element_count 0
  set block_count 0
  set last_block_type ""
  set block_argc 0
  set block_argv ""

  set sds_hw_usage "Syntax is ${SDS_HW_BLOCK} <function> <file> \[option\]* ${SDS_END_BLOCK}. Only one <function> and one <file> can be specified."

  # keep track of blocks
  array set block_fname2index {}
  array set block_accname2index {}
  array set block_index_used {}

  # Create multiple lists from the original global argv
  #   - all arguments that are not in an sdscc option block (this can
  #     include sdscc options)
  #   - all arguments in all compile blocks (if this is a compile run);
  #     in a link run, compile blocks are read but not saved
  # Unneeded blocks are discarded.
  #
  # At the time this function is called, argv has been appended with
  # any options set using environment variables, which may include
  # sdscc option blocks. If there are duplicate blocks, the last one
  # is kept.

  set is_hw_block 0
  for {set i 0} {$i < $argc} {incr i} {
    set arg [lindex $argv $i]
    if { [string equal $arg ${SDS_HW_BLOCK}]} {
      if { ${is_hw_block} } {
        puts "Processing: [lrange $argv 1 $i]"
        MSG_ERROR $::sdsoc::msg::idSCOptHwExtra "${SDS_HW_BLOCK} encountered before previous block ended"
        return 1
      }
      set is_hw_block 1
      set last_block_type $arg
      if { $compile } {
        lappend block_argv $arg
        incr block_argc
        set block_element_count 0
      }
    } elseif {[string equal $arg ${SDS_END_BLOCK}]} {
      if { ! ${is_hw_block} } {
        puts "Processing: [lrange $argv 1 $i]"
        MSG_ERROR $::sdsoc::msg::idSCOptHwEndExtra "${SDS_END_BLOCK} encountered without block starting"
        return 1
      }
      if { $compile && $block_element_count < 1} {
        MSG_ERROR $::sdsoc::msg::idSCOptHwEndNoAccel "${SDS_END_BLOCK} encountered without specifying accelerator function and source file"
        return 1
      }
      if { $compile && ${is_hw_block} } {
        lappend block_argv $arg
        incr block_argc
        incr block_count
      }
      set is_hw_block 0
    } elseif { ${is_hw_block} } {
      # ignore hw blocks if we're running in link mode
      if { $compile} {
        lappend block_argv $arg
        incr block_argc
        incr block_element_count
        # first element in a compile block is the accelerator function
        if { ${block_element_count} == 1} {
          if {[string match "-*" $arg]} {
            puts "Processing: [lrange $argv 1 $i]"
            MSG_ERROR $::sdsoc::msg::idSCOptHwNoAccel "${SDS_HW_BLOCK} first element : expecting a function name"
            return 1
          }
          # get the accelerator name and check if a block has appeared earlier.
          # if yes, mark that block as unused and most recent block as used.
          set accname [file tail $arg]
          if {[info exists block_accname2index($accname)] } {
            puts "Processing: [lrange $argv 1 $i]"
            MSG_ERROR $::sdsoc::msg::idSCOptHwMultipleAccel "Found multiple ${SDS_HW_BLOCK} blocks for $accname, only one is allowed"
            return 1

            # Don't allow multiple blocks for the same function, just error out
            # MSG_WARNING $::sdsoc::msg::id "Found multiple ${SDS_HW_BLOCK} blocks for $accname, using the last one"
            # set block_index_used($block_accname2index($accname)) 0
          }
          set block_accname2index($accname) $block_count
          set block_index_used($block_count) 1
        } elseif { ${block_element_count} == 2} {

        # second element in a compile block is the file to compile
          if {[string match "-*" $arg]} {
            puts "Processing: [lrange $argv 1 $i]"
            MSG_ERROR $::sdsoc::msg::idSCOptHwNoFile "${SDS_HW_BLOCK} second element : expecting a file name"
            return 1
          }
          # get the file name and check if a block has appeared earlier.
          # if yes, mark that block as unused and most recent block as used.
          set fname [file tail $arg]

          # 2015.2 SDSoC allows more than one top-level accelerator
          # function in a source file, so don't error out here.
          if {[info exists block_fname2index($fname)] } {
            if {[apc_get_global APCC_DRC_ONE_ACCEL_PER_SOURCE]} {
              puts "Processing: [lrange $argv 1 $i]"
              MSG_ERROR $::sdsoc::msg::idSCHwMultipleFile "Found multiple ${SDS_HW_BLOCK} blocks for $fname, only one accelerator is allowed per file"
              return 1
            }
          }
          set block_fname2index($fname) $block_count
          set block_index_used($block_count) 1

        } else {
          set opt_name $arg

          # all remaining elements should be options until reach -sds-end;
          # in this code block, if it starts with '-', it's an option because
          # the -sds-end token is taken care of earlier above.
          if {! [string match "-*" $opt_name]} {
            MSG_ERROR $::sdsoc::msg::idSCOptHwEndMissing "Expecting to see an option or ${SDS_END_BLOCK}, not $opt_name. $sds_hw_usage"
            return 1
          }

          # now check if this is a valid option for an -sds-hw/-sds-end block
          set opt_type [::sdsoc::opt::getHwOptionValueType $opt_name]
          if {[::sdsoc::opt::isHwOptionValueError $opt_type]} {
            MSG_ERROR $::sdsoc::msg::idSCOptHwExpected "Expecting to see an [apc_get_global APCC_OPT_HW_BLOCK] block option, $opt_name not recognized as a valid option. $sds_hw_usage"
            return 1
          }

          # if the option appears valid and has an argument, check if the
          # next token could be valid (doesn't start with '-').
          if {! [::sdsoc::opt::isHwOptionValueNoArg $opt_type]} {
            incr i
            if {$i >= $argc} {
              MSG_ERROR $::sdsoc::msg::idSCOptArgMissing "Option $opt_name missing argument (none remaining), expecting to see an option value $opt_type. $sds_hw_usage"
              return 1
            }
            set arg [lindex $argv $i]
            lappend block_argv $arg
            incr block_argc
            incr block_element_count
            if {[string match "-*" $arg]} {
              MSG_ERROR $::sdsoc::msg::idSCOptArgMissingType "Option $opt_name missing argument, expecting to see an option value $opt_type, not $arg. $sds_hw_usage"
              return 1
            }
          }
        }
      }
    } else {
      # everything that's not in a hw block is saved
      lappend apargv $arg
      incr apargc
    }
  }

  # Check if a hw block was started, but an end
  # statement wasn't seen

  if { ${is_hw_block} } {
    puts "Processing: [lrange $argv 1 [ expr {$argc - 1}] ]"
    MSG_ERROR $::sdsoc::msg::idSCOptHWNotTerminated "${last_block_type} block was never terminated"
    return 1
  }

  # Remove duplicate hw blocks for a compile run.
  #
  # During initial argv parsing, a map of compile blocks was saved,
  # use that to remove duplicates.
  #
  # The scheme for removing duplicates is simple. Blocks are associated
  # with a number from 0 to n as they are read in, and the file being
  # compiled is assigned that number; if a file is seen twice, it is
  # assigned the most recent block number. Later, keep only blocks
  # associated with a file through a block number. Similarly, if a
  # function name is seen twice, save the later one.
  #
  # A warning message for duplicates was printed earlier, so don't
  # do that here, just remove blocks.

  if { $compile } {

    # Append the sdscc option blocks to the end of the list.
    # If this is a compile, the list may contain multiple hw blocks, which
    # we'll skip later when processing the options

    set block_index 0
    foreach arg ${block_argv} {
      if { $block_index_used(${block_index}) } {
        lappend apargv ${arg}
        incr apargc
      }
      if { [string equal $arg ${SDS_END_BLOCK}]} {
        incr block_index
      }
    }
  } else {

    # If this is a link, the list contains all arguments with no hw blocks.
    # There is nothing to do here.

  }

  # Update argc and argv
  set argc $apargc
  set argv $apargv

  # Done
  #
  # At this point, -apf-hw blocks have been moved to the end of the
  # argv array with duplicates removed. When the blocks are processed
  # the source file name is known, so the block can be conditionally 
  # used. We've already checked for gross errors, e.g. missing -apf-end
  return 0
}

# Temporary function to check for multiple clocks while there is a
# bug in the axis_accelerator_adapter (fix expected 2015.1). This is
# an early check during compiles. The data motion network clock is 
# only checked if specified explicitly (no guarantee that the user's
# command line contains all of the SDSoC options). A separate,
# more complete check is performed when creating the ELF and bitstream.
proc check_multiple_clocks_in_argv { clk } {
  global argc argv SDS_HW_BLOCK SDS_END_BLOCK
  global disable_multi_clks

  set prev_accel ""
  set prev_accel_clk -1
  set cur_accel ""
  set cur_accel_clk -1
  set dm_clk -1
  set is_sds_hw 0

  # check accelerator clocks
  for {set i 0} {$i < $argc} {incr i} {
    set arg [lindex $argv $i]
    if { [string equal $arg ${SDS_HW_BLOCK}]} {
      set is_sds_hw 1
      incr i
      set cur_accel [lindex $argv $i]
      set cur_accel_clk $clk
      continue
    }
    if { [string equal $arg ${SDS_END_BLOCK}]} {
      set is_sds_hw 0
      if {$prev_accel_clk >= 0 && $cur_accel_clk != $prev_accel_clk && $disable_multi_clks != 0} {
        MSG_ERROR $::sdsoc::msg::idSCMultiClockCheck "Multiple clock systems are not supported, use the same clock ID for accelerators (-clkid options) and data motion network (-dmclkid option); specify all clocks if the default is not used. Accelerator $prev_accel uses clock ID $prev_accel_clk, while accelerator $cur_accel uses clock ID $cur_accel_clk."
        sdscc_on_exit 1
      }
      set prev_accel $cur_accel
      set prev_accel_clk $cur_accel_clk
      continue
    }
    if {$is_sds_hw} {
      if { [string equal $arg "-clkid"]} {
        incr i
        set cur_accel_clk [lindex $argv $i]
      }
    }
    if { [string equal $arg "-dmclkid"]} {
      incr i
      set dm_clk [lindex $argv $i]
    }
  }

  # check data motion clock, if specified
  if {$dm_clk >= 0 && $prev_accel_clk >= 0 && $disable_multi_clks != 0} {
    if {$dm_clk != $prev_accel_clk} {
        MSG_ERROR $::sdsoc::msg::idSCMultiClockCheckDM "Multiple clock systems are not supported, use the same clock ID for accelerators (-clkid options) and data motion network (-dmclkid option); specify all clocks if the default is not used. Accelerator $prev_accel uses clock ID $prev_accel_clk, while the data motion network uses clock ID $dm_clk."
        sdscc_on_exit 1
    }
  }
}

# for internal use only, load command line options from
# $HOME/.Xilinx/sdsoc/sdsoc.ini if it exists. each line
# can contain one or more options.
proc process_ini_file {} {
  # check if a .ini file exists
  set tempDir ""
  if {[apc_is_windows]} {
    if {[info exists ::env(USERPROFILE)]} {
      set tempDir $::env(USERPROFILE)
    } elseif {[info exists ::env(HOMEDIR)]} {
      set tempDir $::env(HOMEDIR)
    } elseif {[info exists ::env(HOME)]} {
      set tempDir $::env(HOME)
    }
  } else {
    if {[info exists ::env(HOME)]} {
      set tempDir $::env(HOME)
    }
  }
  if {[string length ${tempDir}] < 1} {
    return
  }
  set homeDir [file normalize ${tempDir}]
  set iniFile [file normalize [file join ${homeDir} ".Xilinx" "sdscc" "sdscc.ini"]]
  if {! [file exists ${iniFile}] } {
    return
  }

  # if a .ini file exists, read the options into a string
  set optString ""
  set fp [open ${iniFile} r]
  while {[gets $fp iniBuf] >= 0} {
    # remove leading/trailing white space
    set s [string trim ${iniBuf}]
    # if there is anything left, add it to the string
    if {[string length ${s}] > 0} {
      if {[string length ${optString}] > 0} {
        append optString " "
      }
      append optString "${s}"
    }
  }
  close $fp

  # save the options
  apc_set_global INI_FLAGS ${optString}

  # warn the user that .ini file is being used
  MSG_WARNING $::sdsoc::msg::idSCIniFileFlags "User-defined flags set with ${iniFile} : ${optString}"
}

proc process_env_flags {env_string} {
  global argc argv

  if {[string length $env_string] < 1} {
    return
  }

  # create an option list
  set opt_list [regexp -all -inline {\S+} $env_string]
  set optc [llength $opt_list]

  # append the option list to argv
  for {set i 0} {$i < $optc} {incr i} {
    lappend argv [lindex $opt_list $i]
    incr argc
  }
}

# CR 724024 requests improved handling of flags that are not reecognized,
# for example if there is a typo (user types -clkId instead of -clkid).
# When sdscc doesn't recognize an option, it passes it to gcc/g++, which
# in turn prints a warning/error if it doesn't recognize the string.
#
# One possible solution is to allow case-insensitive matching of sdscc
# options, but this was rejected. Instead, we'll check for a case-insensitive
# match and flag it as a potential typo, but it still gets passed through
# to gcc/g++. There isn't a straight-forward way to check if it's a valid
# gcc/g++ option, or finding one may be more effort than warranted.
#
# Flagging options not recognized as sdscc options as being passed to
# gcc/g++ is possible, but that seems rather noisy, and isn't being done.
# Checking for partial matches also isn't done.
set sdscc_option_keyword_list { \
  [apc_get_global APCC_OPT_HW_BLOCK] \
  [apc_get_global APCC_OPT_PLATFORM] \
  [apc_get_global APCC_OPT_PLATFORM_INFO] \
  [apc_get_global APCC_OPT_PLATFORM_LIST] \
  [apc_get_global APCC_OPT_END_BLOCK]  
  -files             -apm              -trace           -trace-no-sw    -trace-buffer -ip-repo -add-ip-repo \
  -vlnv              -ip-map           -ip-params       -hls-tcl -ac \
  -clkid             -dmclkid          -Wxc    -Wxp             -Wxl \
  -mboot-files       -mno-boot-files   -mno-bitstream   -mno-clean \
  -mno-lint          -mdev-no-hls      -mdev-no-swgen   -mdev-no-llvm \
  -mdev-no-llvm-link -mdev-no-xsd      -mdev-no-exit    -mno-ir \
  -mdev-no-log       -mdev-debug-hls   -mdev-debug-xlnk -mdev-pragma-gen \
  -target-os -emulation -synth-strategy -impl-strategy  -mno-pragma-gen \
  -perf-funcs        -perf-root        -perf-est        -perf-est-hw-only \
  -rebuild-sw-only   -rebuild-hardware -mdev-no-cfsys   -verbose \
  -version           --help            -menable-multi-partition -mdev-disable-multi-clks -mno-adapter -mdev-single-accel -sdcard -impl-tcl \
  -experimental-dma -keep -mno-test-link \
  -pfunc -sds-sys-config -sds-proc -proc-instance -proc-type -target-cpu -id \
  -mdev-dmtest -mno-fpo-macro -bsp-config-file -bsp-config-merge-file \
  -mno-dsa-bsp -sds-image -sds-pf-path \
}

proc sdscc_check_option_typo {option_string} {
  global sdscc_option_keyword_list

  foreach kw $sdscc_option_keyword_list {
    if {[string equal -nocase $kw $option_string] &&
       ![string equal $kw $option_string]} {
      MSG_WARNING $::sdsoc::msg::idSCOptTypo "passing $option_string to compiler may cause an error (appears similar to [apc_get_global APCC_COMMAND_NAME] option $kw but case does not match - typo?)"
      return
    }
  }
}

###############################################################################
# Parse command line
###############################################################################

# The environment variables SDS_CFLAGS and SDS_LFLAGS can be
# used to append arguements to argv and update argc

# internal use only
set apc(INI_FLAGS) ""
process_ini_file

# DEBUG: puts "argv before : $argv"
if {[lsearch -exact $argv "-mdev-single-accel"] > 0} {
  apc_set_global APCC_DRC_ONE_ACCEL_PER_SOURCE 1
}
if {[lsearch -exact $argv "-c"] > 0} {
  set compile 1
  apc_set_global APCC_FLOW_TYPE APCC_COMPILE_FLOW
  process_env_flags $apc(INI_FLAGS)
  process_env_flags $apc(RDI_FLAGS)
  process_env_flags $apc(SDS_CFLAGS)
  if { [pre_process_argv] } {
    MSG_ERROR $::sdsoc::msg::idSCParsingOptionsCompile "Issue encountered processing command line options"
    sdscc_on_exit 1
  }
} else {
  apc_set_global APCC_FLOW_TYPE APCC_LINK_FLOW
  process_env_flags $apc(INI_FLAGS)
  process_env_flags $apc(RDI_FLAGS)
  process_env_flags $apc(SDS_LFLAGS)
  if { [pre_process_argv] } {
    MSG_ERROR $::sdsoc::msg::idSCParsingOptionsLink "Issue encountered processing command line options"
    sdscc_on_exit 1
  }
}
# DEBUG: puts "argv after  : $argv"

# Iterate over command line arguments
if {[lsearch -exact $argv "-sdslib"] > 0} {
  set is_sdslib 1
} else {
  set is_sdslib 0
}
set current_accel ""
set sdcard_extras ""
apc_set_global APCC_BOOT_SDCARD_USER ""
set impl_tcl ""
set pfPathList [list]
# set defaults
::sdsoc::opt::setOptSdsocDefaults
for {set i 1} {$i < $argc} {incr i} {
  set arg [lindex $argv $i]
  if {[string equal $arg "-c"]} {
    set compile 1
  } elseif {[string equal $arg "-sdslib"]} {
    # processed earlier, skip here
  } elseif {[string equal $arg "-hw"]} {
    incr i
    if {[string equal "-sds-hw" [apc_get_global APCC_OPT_HW_BLOCK]]} {
      MSG_ERROR $::sdsoc::msg::idSCOptOldHw "The -hw option is no longer supported. Use the option -sds-hw <function> <filename> <other_options> -sds-end instead, for example: sdscc -c -sds-pf zc702 -sds-hw add add.c -sds-end add.c -o add.o"
      sdscc_on_exit 1
    }
    set run_hls 1
    lappend accels [lindex $argv $i]
  } elseif {[string equal $arg [apc_get_global APCC_OPT_PLATFORM]]} {
    incr i
    if { [has_xsd_platform] } {
        MSG_WARNING $::sdsoc::msg::idSCOptMultiPlatform "Multiple platform options specified : [apc_get_global APCC_OPT_PLATFORM] [apc_get_global APCC_PLATFORM_VALUE] was specified earlier, applying [apc_get_global APCC_OPT_PLATFORM] [lindex $argv $i]"
      set_xsd_platform [lindex $argv $i]
    } else {
      set_xsd_platform [lindex $argv $i]
    }
  } elseif {[string equal $arg [apc_get_global APCC_OPT_PLATFORM_INFO]]} {
    set pf_info 1
    incr i
    set_xsd_platform [lindex $argv $i]
  } elseif {[string equal $arg [apc_get_global APCC_OPT_PLATFORM_LIST]]} {
    set pf_list 1
  } elseif {[string equal $arg "-mdev-disable-multi-clks"]} {
    set disable_multi_clks 1
    ::sdsoc::opt::setOptMultiClock 0
  } elseif {[string equal $arg "-trace-axilite"]} {
      set trace_axilite 1
      ::sdsoc::opt::setOptTraceAxilite 1
  } elseif {[string equal $arg "-trace-burst"]} {
      set trace_burst 1
      ::sdsoc::opt::setOptTraceBurst 1
  } elseif {[string equal $arg "-apm"]} {
      set insert_apm 1
      ::sdsoc::opt::setOptApm 1
      #check if other exclusive flags have been set
      if {$insert_trace_hw || $insert_trace_sw || $perf_est || $run_emulation_export} {
	  MSG_ERROR $::sdsoc::msg::idSCOptApmError "The -apm option cannot be used with -trace, -emulation, or -perf-est\[-hw-only\]"
	  sdscc_on_exit 1
      }
  } elseif {[string equal $arg "-trace"]} {
    set insert_trace_hw 1
    set insert_trace_sw 1
    ::sdsoc::opt::setOptTrace 1
    append other_xidanepass_switches " --trace $num_trace_cores"
      #check if other exclusive flags have been set
      #COMMENTED OUT 12/15
#      if {$insert_apm || $perf_est || $run_emulation_export} {
#	  MSG_ERROR $::sdsoc::msg::id "The -trace option cannot be used with -apm, -emulation, or -perf-est\[-hw-only\]"
#	  sdscc_on_exit 1
#      }

      if {$insert_apm || $perf_est} {
	  MSG_ERROR $::sdsoc::msg::idSCOptTraceError "The -trace option cannot be used with -apm or -perf-est\[-hw-only\]"
	  sdscc_on_exit 1
      }
  } elseif {[string equal $arg "-trace-no-sw"]} {
    set insert_trace_hw 1
    ::sdsoc::opt::setOptTraceNoSw 1
      if {$insert_trace_sw} {
	  MSG_ERROR $::sdsoc::msg::idSCOptTraceNoSw "The -trace and -trace-no-sw options cannot be used together. Either choose -trace for tracing both hardware and software, or choose -trace-no-sw for tracing only the hardware"
	  sdscc_on_exit 1
      }
      #check if other exclusive flags have been set
      if {$insert_apm || $perf_est || $run_emulation_export} {
	  MSG_ERROR $::sdsoc::msg::idSCOptTraceNoSwOther "The -trace-no-sw option cannot be used with -apm, -emulation, or -perf-est\[-hw-only\]"
	  sdscc_on_exit 1
      }
  } elseif {[string equal $arg "-trace-buffer"]} {
      incr i
      set trace_depth [lindex $argv $i]
      ::sdsoc::opt::setOptTraceBufferDepth $trace_depth
      if {![string is integer $trace_depth]} {
	  MSG_ERROR $::sdsoc::msg::idSCOptTraceBufferInteger "Trace buffer depth must be numeric, found '$trace_depth'"
	  sdscc_on_exit 1
      }
      if {$trace_depth < 16} {
	  MSG_ERROR $::sdsoc::msg::idSCOptTraceBufferDepth "Trace buffer depth must be greater than 16"
	  sdscc_on_exit 1
      }
      if {[expr $trace_depth & [expr $trace_depth - 1]] != 0} {
	  MSG_ERROR $::sdsoc::msg::idSCOptTracePower2 "Trace buffer depth must be a power of 2 (16,32,64,...)"
	  sdscc_on_exit 1
      }
  } elseif {[string equal $arg "-pfunc"]} {
    set platform_func 1
  } elseif {[string equal $arg "-vlnv"]} {
    incr i
    if {$is_sdslib} {
      set vlnv [lindex $argv $i]
    } else {
      MSG_ERROR $::sdsoc::msg::idSCOptVlnv "Unrecognized option: -vlnv. Use the sdslib tool to create an HDL IP library for linking with your application - see the UG1146 SDSoC Platforms and Libraries and UG1027 Introduction to SDSoC chapters describing SDSoC libraries for more information."
      sdscc_on_exit 1
    }
  } elseif {[string equal $arg "-ip-map"]} {
    incr i
    if {$is_sdslib} {
      set fcnmap_file [file normalize [file join $run_dir [lindex $argv $i]]]
    } else {
      MSG_ERROR $::sdsoc::msg::idSCOptIpMap "Unrecognized option: -ip-map. Use the sdslib tool to create an HDL IP library for linking with your application - see the UG1146 SDSoC Platforms and Libraries and UG1027 Introduction to SDSoC chapters describing SDSoC libraries for more information."
      sdscc_on_exit 1
    }
  } elseif {[string equal $arg "-ip-params"]} {
    incr i
    if {$is_sdslib} {
      set params_file [file normalize [file join $run_dir [lindex $argv $i]]]
    } else {
      MSG_ERROR $::sdsoc::msg::idSCOptIpParams "Unrecognized option: -ip-params. Use the sdslib tool to create an HDL IP library for linking with your application - see the UG1146 SDSoC Platforms and Libraries and UG1027 Introduction to SDSoC chapters describing SDSoC libraries for more information."
      sdscc_on_exit 1
    }
  } elseif {[string equal $arg "-hls-tcl"]} {
    incr i
    set hls_tcl_directive_file [file normalize [file join $run_dir [lindex $argv $i]]]
    if {[string length $current_accel] > 0} {
      set accelmap_hls_tcl_directive_file($current_accel) $hls_tcl_directive_file
    } 
  } elseif {[string equal $arg "-files"]} {
    incr i
    set arg_string [lindex $argv $i]
    set subfile_list [split $arg_string ,]
    foreach sub $subfile_list {
      if {[file exists $sub]} {
        set subFileName [file normalize [file join ${run_dir} $sub]]
        lappend hls_subfile_list $subFileName
        if {[llength $hls_subfile_list] == 1 && 
            [string length $current_accel] > 0 &&
            [::sdsoc::template::isTemplateFunction $current_accel]} {
          ::sdsoc::template::addTemplateSource $current_accel $subFileName
        }
      } else {
        MSG_ERROR $::sdsoc::msg::idSCOptHlsFile "HLS sub-file not found, path may be incorrect: $sub"
        sdscc_on_exit 1
      }
    }
    if {[string length $current_accel] > 0} {
      set accelmap_hls_subfile_list($current_accel) $hls_subfile_list
    }
  } elseif {[string equal $arg "-ip-repo"]} {
    incr i
    set arg_string [lindex $argv $i]
    if {$is_sdslib} {
      if {[file exists $arg_string]} {
        lappend ip_repo_option_list [file join ${run_dir} $arg_string]
      } else {
        MSG_WARNING $::sdsoc::msg::idSCOptIpRepo "IP repository path not found, ignoring: $arg_string"
      }
    } else {
      if {[file exists $arg_string]} {
        set ipRepo [file normalize [file join ${run_dir} ${arg_string}]]
        ::sdsoc::opt::setOptIpRepo ${ipRepo}
        MSG_WARNING $::sdsoc::msg::idSCOptIpRepoNotSdslib "User specified IP repository option added: -ip-repo ${arg_string}"
      } else {
        MSG_WARNING $::sdsoc::msg::idSCOptIpRepo "IP repository path not found, ignoring: $arg_string"
      }
    }
  } elseif {[string equal $arg "-add-ip-repo"]} {
    if {$is_sdslib} {
      ::sdsoc::opt::setOptAddIpRepo 1
    }
  } elseif {[string equal $arg "-ac"]} {
    incr i
    if {! ${compile} } {
      set tokList [split [lindex $argv $i] ":"]
      set acname [lindex $tokList 0]
      if {[llength $tokList] > 1} {
        set acid [lindex $tokList 1]
      } else {
        MSG_ERROR $::sdsoc::msg::idSCOptAclkMissingId "Invalid option -ac [lindex $argv $i], clock ID number was not specified, expecting -ac accelerator_name:clock_id_number"
        sdscc_on_exit 1
      }
      if { [::sdsoc::opt::setOptAclkId $acname $acid]} {
        set existing_acid [::sdsoc::opt::getOptAclkId $acname]
        if {$existing_acid >= 0} {
          MSG_ERROR $::sdsoc::msg::idSCOptAclkDuplicate "Invalid option -ac [lindex $argv $i], clock ID number was specified earlier as $existing_acid"
        } else {
          MSG_ERROR $::sdsoc::msg::idSCOptAclkInvalidId "Invalid option -ac [lindex $argv $i], clock ID number not recognized"
        }
        sdscc_on_exit 1
      }
    }
  } elseif {[string equal $arg "-clkid"]} {
    incr i
    if { ${compile} } {
      set clk_id [lindex $argv $i]
      if {[string length $current_accel] > 0} {
        set accelmap_clkid($current_accel) $clk_id
      } 
    }
  } elseif {[string equal $arg "-dmclkid"]} {
    incr i
    if {! ${compile} } {
      set clk_id [lindex $argv $i]
    }
  } elseif {[string equal $arg "-keep"]} {
    ::sdsoc::opt::setOptKeep 1
  } elseif {[string equal $arg "-shared-aximm"]} {
    if { ${compile} } {
      set shared_aximm 1
    }
  } elseif {[string equal $arg "-bsp-config-file"]} {
    incr i
    set mssFile [file normalize [file join $run_dir [lindex $argv $i]]]
    if {! [file exists ${mssFile}]} {
      MSG_ERROR $::sdsoc::msg::idSCOptNoUserBspConfigFile "The specified user BSP configuration file (.mss) does not exist: -bsp-config-file ${mssFile}"
      sdscc_on_exit 1
    }
    MSG_WARNING $::sdsoc::msg::idSCOptUserBspConfigFile "User BSP configuration file (.mss) specified : ${mssFile}"
    apc_set_global APCC_BSP_CONFIGURATION_MSS_USER ${mssFile}
  } elseif {[string equal $arg "-bsp-config-merge-file"]} {
    incr i
    set mssFile [file normalize [file join $run_dir [lindex $argv $i]]]
    if {! [file exists ${mssFile}]} {
      MSG_ERROR $::sdsoc::msg::idSCOptNoUserBspConfigFile "The specified user BSP configuration file (.mss) does not exist: -bsp-config-merge-file ${mssFile}"
      sdscc_on_exit 1
    }
    apc_set_global APCC_BSP_CONFIGURATION_MSS_USER_MERGE ${mssFile}
  } elseif {[string equal $arg "-Wl,-T"]} {
    # user-defined linker script -Wl,-T -Wl,<linker_script>
    incr i
    set ldscript_tmp [lindex $argv $i]
    if {[string equal -length 4 $ldscript_tmp "-Wl,"]} {
      regsub (-Wl,) $ldscript_tmp "" ldscript_name
      if { [file exists $ldscript_name] } {
        apc_set_global APCC_USER_LINKER_SCRIPT [file join $run_dir $ldscript_name]
        MSG_PRINT "gcc/g++ -Wl,-T $ldscript_tmp linker script option specified, applying user-specified linker script"
      } else {
        MSG_ERROR $::sdsoc::msg::idSCOptLinkerScriptMissing "gcc/g++ -Wl,-T linker script option specified, but file $ldscript_name was not found - ignoring user-specified linker script"
      }
    } else {
      MSG_ERROR $::sdsoc::msg::idSCOptLinkerScriptBad "gcc/g++ -Wl,-T linker script option specified, expecting -Wl,<linker_script> but encountered $ldscript_tmp - ignoring user-specified linker script"
    }
  } elseif {[string equal -length 5 $arg "-Wxc,"]} {
    set tmp_switches ""
    set xc_switches ""
    regsub (-Wxc,) [lindex $argv $i] "" tmp_switches
    regsub -all (,) $tmp_switches " " xc_switches
    append other_pragmagen_switches " " $xc_switches
  } elseif {[string equal -length 5 $arg "-Wxp,"]} {
    set tmp_switches ""
    set xp_switches ""
    regsub (-Wxp,) [lindex $argv $i] "" tmp_switches
    regsub -all (,) $tmp_switches " " xp_switches
    append other_xidanepass_switches " " $xp_switches
  } elseif {[string equal -nocase $arg "-instrument-stub"]} {
    append other_xidanepass_switches " --instrument_stub_apf_counter"
  } elseif {[string equal $arg "-dm-sharing"]} {
    incr i
    set sharing_level [lindex $argv $i]
    switch $sharing_level {
      0   { append other_xidanepass_switches " -slack 0" }
      1   { append other_xidanepass_switches " -slack 50" }
      2   { append other_xidanepass_switches " -slack 100" }
      3   { append other_xidanepass_switches " -slack -1" }
      default {
        if {[string is integer ${sharing_level}] && $sharing_level >= 0 } {
          append other_xidanepass_switches " -slack ${sharing_level}"
        } else {
          MSG_WARNING $::sdsoc::msg::idSCOptDmSharing "Ignoring invalid -dm-sharing value \"$sharing_level\", expecting integer value 0, 1, 2 or 3 (low, medium, high, infinite)"
        }
      }
    }
  } elseif {[string equal -length 5 $arg "-Wxl,"]} {
    set tmp_switches ""
    set xl_switches ""
    regsub (-Wxl,) [lindex $argv $i] "" tmp_switches
    regsub -all (,) $tmp_switches " " xl_switches
    append other_syslink_switches " " $xl_switches
    append other_vpl_switches " " $xl_switches
  } elseif {[string equal -nocase $arg "-poll-mode"]} {
    incr i
    set poll_mode_value [lindex $argv $i]
    if {$poll_mode_value == 0 || $poll_mode_value == 1} {
      append other_syslink_switches " -poll-mode $poll_mode_value"
      ::sdsoc::opt::setOptPollMode $poll_mode_value
    } else {
      MSG_WARNING $::sdsoc::msg::idSCOptPollMode "Ignoring invalid -poll-mode option value $poll_mode_value, expecting 0 or 1"
    }
  } elseif {[string equal $arg "-impl-strategy"]} {
    incr i
    if {! ${compile} } {
      set_impl_strategy [lindex $argv $i]
      ::sdsoc::opt::setOptImplStrategy [lindex $argv $i]
    }
  } elseif {[string equal $arg "-synth-strategy"]} {
    incr i
    if {! ${compile} } {
      set_synth_strategy [lindex $argv $i]
      ::sdsoc::opt::setOptSynthStrategy [lindex $argv $i]
    }
  } elseif {[string equal -length 2 $arg "-o"]} {
    # GCC supports switches such as -o"main.o" where there is no space
    # between the switch and the argument.
    if {[string equal $arg "-o"]} {
      incr i
      set outfile [lindex $argv $i]
    } else {
      regsub (-o) [lindex $argv $i] "" outfile
    }
    apc_set_global APCC_COMPILER_OUTPUT_OPTION_USED 1
  } elseif {[string equal -length 2 $arg "-I"]} {
    # GCC supports switches such as -I.. where there is no space
    # between the switch and the argument.
    if {[string equal $arg "-I"]} {
      incr i
      lappend ininclpaths [lindex $argv $i]
    } else {
      regsub (-I) $arg "" ininclpath
      lappend ininclpaths $ininclpath
    }
  } elseif {[string equal $arg "-log-dir"] ||
            [string equal $arg "--log_dir"]} {
    # this needs to appear before -l, otherwise it's treated as -l
    incr i
    set logDir [file normalize [file join [pwd] [lindex $argv $i]]]
    apc_set_global APCC_VPL_LOG_DIR ${logDir}
  } elseif {[string equal -length 2 $arg "-l"]} {
    # GCC supports switches such as -ladd where there is no space
    # between the switch and the argument.
    if {[string equal $arg "-l"]} {
      lappend other_switches $arg
      incr i
      set inlib [lindex $argv $i]
      if {$inlib ni $inlibs} {
        lappend inlibs $inlib
      }
      lappend other_switches [lindex $argv $i]
    } else {
      regsub (-l) $arg "" inlib
      if {$inlib ni $inlibs} {
        lappend inlibs $inlib
      }
      # Keep these in other switches
      lappend other_switches $arg
    }
  } elseif {[string equal -length 2 $arg "-L"]} {
    # GCC supports switches such as -L.. where there is no space
    # between the switch and the argument.
    if {[string equal $arg "-L"]} {
      lappend other_switches $arg
      incr i
      lappend inlibpaths [lindex $argv $i]
      lappend other_switches [lindex $argv $i]
    } else {
      regsub (-L) $arg "" inlibpath
      lappend inlibpaths $inlibpath
      # Keep these in other switches
      lappend other_switches $arg
    }
  } elseif {[string equal -length 3 $arg "-MF"]} {
    # GCC supports switches such as -MF.. where there is no space
    # between the switch and the argument.
    if {[string equal $arg "-MF"]} {
      lappend other_mf_mt_switches $arg
      incr i
      lappend other_mf_mt_switches [file join $run_dir $arg]
    } else {
      regsub (-MF) $arg "" tmppath
      lappend other_mf_mt_switches -MF[file join $run_dir $tmppath]
    }
  } elseif {[string equal -length 3 $arg "-MT"]} {
    # GCC supports switches such as -MT.. where there is no space
    # between the switch and the argument.
    if {[string equal $arg "-MT"]} {
      lappend other_mf_mt_switches $arg
      incr i
      lappend other_mf_mt_switches [file join $run_dir $arg]
    } else {
      regsub (-MT) $arg "" tmppath
      lappend other_mf_mt_switches -MT[file join $run_dir $tmppath]
    }
  } elseif {[string match "-emulation" $arg]} {
      set run_emulation_export 1
      ::sdsoc::opt::setOptEmuEnable 1
      incr i
      set emulation_arg [lindex $argv $i]
      switch -nocase -- $emulation_arg {
	debug     -
	optimized { set emulation_mode $emulation_arg }
	default   {
            MSG_ERROR $::sdsoc::msg::idSCOptEmuMode "Unrecognized emulation mode $emulation_arg, expecting -emulation debug or -emulation optimized"
            sdscc_on_exit 1
	}
      }
      #check if other exclusive flags have been set
      #COMMENTED OUT 12/15 to test emulation + trace
#      if {$insert_trace_hw || $insert_trace_sw || $insert_apm || $perf_est} {
#	  MSG_ERROR $::sdsoc::msg::id "The -emulation option cannot be used with -trace, -apm, or -perf-est\[-hw-only\]"
#	  sdscc_on_exit 1
#      }
      if {$insert_apm || $perf_est} {
	  MSG_ERROR $::sdsoc::msg::idSCOptEmuOther "The -emulation option cannot be used with -apm or -perf-est\[-hw-only\]"
	  sdscc_on_exit 1
      }
  } elseif {[string match "-mboot-files" $arg]} {
    set run_boot_files 1
  } elseif {[string match "-mno-boot-files" $arg]} {
    set run_boot_files 0
  } elseif {[string match "-menable-multi-partition" $arg]} {
    set enable_multi_partition 1
  } elseif {[string match "-mno-clean" $arg]} {
    set run_apf_clean 0
  } elseif {[string match "-mno-dsa-bsp" $arg]} {
    set use_dsa_for_bsp 0
  } elseif {[string match "-mno-fpo-macro" $arg]} {
    MSG_WARNING $::sdsoc::msg::idSCOptNoFpoMacro "User disabling auto insertion of the macro -D HLS_NO_XIL_FPO_LIB. When used, the -mno-fpo-macro should be specified for each sdscc/sds++ command line."
    set use_hls_fpo_macro 0
  } elseif {[string match "-mno-lint" $arg]} {
    set run_sdslint 0
  } elseif {[string match "-mno-bitstream" $arg]} {
    set run_bitstream 0
  } elseif {[string match "-mno-test-link" $arg]} {
    set run_test_link 0
  } elseif {[string match "-mdev-no-hls" $arg]} {
    set dev_run_hls 0
  } elseif {[string match "-mdev-no-swgen" $arg]} {
    set dev_run_swgen 0
    # propogate switches to system_linker
    append other_syslink_switches " " -mdev-no-swgen
  } elseif {[string match "-mno-ir" $arg]} {
    set dev_run_llvm 0
  } elseif {[string match "-mdev-no-llvm" $arg]} {
    set dev_run_llvm 0
  } elseif {[string match "-mdev-no-llvm-link" $arg]} {
    # exclude files from llvm-link command used to create XidanePass input
    incr i
    set arg_string [lindex $argv $i]
    set excl_list [split $arg_string ,]
    foreach excl $excl_list {
      lappend llvm_link_exclude_list $excl
    }
  } elseif {[string match "-mdev-dmtest" $arg]} {
    set dev_dmtest_early_exit 1
  } elseif {[string match "-mdev-no-xsd" $arg]} {
    set dev_run_xsd 0
  } elseif {[string match "-mdev-no-exit" $arg]} {
    set dev_run_exit 0
  } elseif {[string match "-mdev-no-log" $arg]} {
    set dev_run_log 0
  } elseif {[string match "-mdev-debug-hls" $arg]} {
    set debug_hls 1
  } elseif {[string match "-mdev-debug-xlnk" $arg]} {
    set debug_xlnk 1
  } elseif {[string match "-mdev-pragma-gen" $arg]} {
    set dev_run_pragmagen 1
  } elseif {[string match "-mno-pragma-gen" $arg]} {
    set dev_run_pragmagen 0
  } elseif {[string match "-mdev-single-accel" $arg]} {
    apc_set_global APCC_DRC_ONE_ACCEL_PER_SOURCE 1
  } elseif {[string match "-mno-adapter" $arg]} {
    set use_hls_adapter 0
  } elseif {[string equal $arg "-disable-ip-cache"] ||
            [string equal $arg "--no_ip_cache"]} {
    append other_syslink_switches " -disable-ip-cache"
    ::sdsoc::opt::setOptIpCache    0
  } elseif {[string equal $arg "-remote-ip-cache"] ||
            [string equal $arg "--remote_ip_cache"]} {
    incr i
    set cacheDir [file normalize [file join [pwd] [lindex $argv $i]]]
    if {! [file exists ${cacheDir}]} {
      if {[catch {file mkdir ${cacheDir}}]} {
        MSG_ERROR $::sdsoc::msg::idSCOptRemoteIpCache "The specified remote IP cache directory does not exist and could not be created: ${cacheDir}. Directories that do not exist can be created but you must have write permission in a parent directory."
        sdscc_on_exit 1
      }
    }
    if {! [file writable ${cacheDir}]} {
      MSG_ERROR $::sdsoc::msg::idSCOptRemoteIpCacheWritable "The specified remote IP cache directory exists but is not writable: ${cacheDir}."
      sdscc_on_exit 1
    }
    ::sdsoc::opt::setOptRemoteIpCache ${cacheDir}
  } elseif {[string equal $arg "-vpl-ini"]} {
    incr i
    set iniFile [lindex $argv $i]
    if {! [file exists ${iniFile}]} {
      MSG_ERROR $::sdsoc::msg::idSCOptVplIniFile "The specified vpl ini file with --xp option values does not exist: ${iniFile}"
      sdscc_on_exit 1
    }
    ::sdsoc::opt::setOptVplIniFile ${iniFile}
  } elseif {[string equal $arg "-maxjobs"] ||
            [string equal $arg "--jobs"]} {
    incr i
    ::sdsoc::opt::setOptMaxJobs [lindex $argv $i]
    append other_syslink_switches " -maxjobs " [lindex $argv $i]
  } elseif {[string equal $arg "-maxthreads"]} {
    incr i
    ::sdsoc::opt::setOptMaxThreads [lindex $argv $i]
    append other_syslink_switches " -maxthreads " [lindex $argv $i]
  } elseif {[string equal $arg "-sdcard"]} {
    incr i
    set tempdir [lindex $argv $i]
    if { [llength ${sdcard_extras}] > 0} {
      MSG_ERROR $::sdsoc::msg::idSCOptSdCard "-sdcard $sdcard_extras specified earlier, ignoring -sdscard $tempdir"
    } elseif {[file exists $tempdir]} {
      set sdcard_dir [file normalize [file join $run_dir $tempdir]]
      append other_syslink_switches " " -sdcard " " $sdcard_dir
      apc_set_global APCC_BOOT_SDCARD_USER $sdcard_dir
      set sdcard_extras $tempdir
    } else {
      MSG_ERROR $::sdsoc::msg::idSCOptSdCardMissing "-sdcard $tempdir directory not found, files will not be added to the SD card image"
    }
  } elseif {[string equal $arg "-impl-tcl"]} {
    incr i
    set tempfile [lindex $argv $i]
    ::sdsoc::opt::setOptImplTcl [lindex $argv $i]
    if { [llength ${impl_tcl}] > 0} {
      MSG_ERROR $::sdsoc::msg::idSCOptImplTcl "-impl-tcl $impl_tcl specified earlier, ignoring -impl-tcl $tempfile"
    } elseif {[file exists $tempfile]} {
      append other_syslink_switches " " -impl-tcl " " [file normalize [file join $run_dir $tempfile]]
      set impl_tcl $tempfile
    } else {
      MSG_ERROR $::sdsoc::msg::idSCOptImplTclMissing "-impl-tcl $tempfile file not found, will not be used for Vivado synthesis and implementation"
    }
  } elseif {[string equal $arg "-target-os"]} {
    incr i
    set_target_os_name [lindex $argv $i]
  } elseif {[string equal $arg "-target-cpu"]} {
    incr i
    set_target_cpu_name [lindex $argv $i]
  } elseif {[string equal $arg "-id"]} {
    incr i
    apc_set_global APCC_DEFAULT_ID [lindex $argv $i]
  } elseif {[string equal $arg "-sds-sys-config"]} {
    incr i
    apc_set_global APCC_PFM_CONFIG [lindex $argv $i]
  } elseif {[string equal $arg "-sds-pf-path"]} {
    incr i
    set pfPath [file normalize [file join [pwd] [lindex $argv $i]]]
    if {[file exists ${pfPath}]} {
      lappend pfPathList ${pfPath}
    } else {
      MSG_ERROR $::sdsoc::msg::idSCOptPlatformPath "The $arg path does not exist: ${pfPath}"
      sdscc_on_exit 1
    }
  } elseif {[string equal $arg "-sds-proc"]} {
    incr i
    apc_set_global APCC_PFM_PROC [lindex $argv $i]
  } elseif {[string equal $arg "-sds-image"]} {
    incr i
    apc_set_global APCC_PFM_IMAGE [lindex $argv $i]
  } elseif {[string equal $arg "-proc-instance"]} {
    incr i
    apc_set_global APCC_PROC_INSTANCE [lindex $argv $i]
  } elseif {[string equal $arg "-proc-type"]} {
    incr i
    apc_set_global APCC_PROC_TYPE [lindex $argv $i]
  } elseif {[string equal $arg "-perf-funcs"]} {
    set perf_prepass 1
    incr i
    set_perf_funcs_string [lindex $argv $i]
  } elseif {[string equal $arg "-perf-root"]} {
    incr i
    set_perf_root_string [lindex $argv $i]
  } elseif {[string equal $arg "-perf-est"]} {
      set perf_est 1
      incr i
      set_perf_est_string [lindex $argv $i]
      #check if other exclusive flags have been set
      if {$insert_trace_hw || $insert_trace_sw || $insert_apm || $run_emulation_export} {
	  MSG_ERROR $::sdsoc::msg::idSCOptPerfEst "The -perf-est option cannot be used with -trace, -emulation, or -apm"
	  sdscc_on_exit 1
      }
  } elseif {[string equal $arg "-perf-est-hw-only"]} {
      set perf_est 1
      set_perf_est_string ""
      #check if other exclusive flags have been set
      if {$insert_trace_hw || $insert_trace_sw || $insert_apm || $run_emulation_export} {
	  MSG_ERROR $::sdsoc::msg::idSCOptPerfEstHwOnly "The -perf-est-hw-only option cannot be used with -trace, -emulation, or -apm"
	  sdscc_on_exit 1
      }
  } elseif {[string match "-rebuild-sw-only" $arg]} {
    # -rebuild-sw-only is the same as setting these flags
    #   -mno-bitstream
    #   -mdev-no-hls
    #   -mdev-no-swgen
    #   -mdev-no-llvm
    #   -mdev-no-xsd
    set dev_run_software_only 1
    set run_bitstream 0
    set dev_run_hls 0
    set dev_run_llvm 0
    set dev_run_xsd 0
    set dev_run_swgen 0
    # propogate switches to system_linker
    append other_syslink_switches " " -mdev-no-xsd
    append other_syslink_switches " " -mdev-no-swgen
  } elseif {[string match "-rebuild-hardware" $arg]} {
    set rebuild_empty_hardware 1
  } elseif {[string match "-mdev-no-cfsys" $arg]} {
    # -mdev-no-cfsys is the same as setting these flags
    #   -mdev-no-hls
    #   -mdev-no-llvm
    set dev_run_hls 0
    set dev_run_llvm 0
  } elseif {[string match "-g" $arg]} {
    set debug 1
    lappend other_switches $arg
  } elseif {[string match "-shared" $arg]} {
    set shared 1
    lappend other_switches $arg
  } elseif {[string equal $arg "-xp"] ||
            [string equal $arg "--xp"]} {
    incr i
    ::sdsoc::opt::setOptXp [lindex $argv $i]
  } elseif {[string match "\-O\[0-3\]" $arg]} {
    set optimize_flag $arg
    lappend other_switches $arg
  } elseif {[string match "-h" $arg]} {
    set help 1
  } elseif {[string match "-help" $arg]} {
    set help 1
  } elseif {[string match "--help" $arg]} {
    set help 1
  } elseif {[string match "-verbose" $arg]} {
    set verbose 1
    ::sdsoc::opt::setOptVerbose 1
  } elseif {[string match "-v" $arg]} {
    # unexpected (possibly) gcc behavior, so -v must be user specified :
    # gcc -v foo.c when the file does not exist produces exit code 0
    # gcc foo.c when the file does not exist produces exit code 1
    MSG_WARNING $::sdsoc::msg::idSCOptV "gcc/g++ -v option specified, use the -verbose option instead to only output additional [apc_get_global APCC_COMMAND_NAME] run-time status messages"
    lappend other_switches $arg
  } elseif {[string match "-version" $arg]} {
    set version 1
  } elseif {[string match ${SDS_HW_BLOCK} $arg]} {
    # -apf-hw function file_name other_options -apf-end
    # if -apf-hw is used to specify the accelerator function,
    # don't use the -hw option.
    incr i
    # remove all whitespace if the function is enclosed in quotes
    regsub -all {\s+} [lindex $argv $i] {} temp_acc_name
    incr i
    set block_src_name [file tail [lindex $argv $i]]

    # if this block doesn't match skip it
    if {! [string match ${block_src_name} [file tail $infiles]]} {
      set end_reached 0
      while {! ${end_reached}} {
        incr i
        if {[string match ${SDS_END_BLOCK} [lindex $argv $i]]} {
          break
        }
      }
    } else {
      MSG_PRINT "Processing ${SDS_HW_BLOCK} block for ${temp_acc_name}"
      set run_hls 1
      # internally use mangled function names, save the original name
      set current_accel [::sdsoc::template::originalName2MangledName ${temp_acc_name}]
      ::sdsoc::template::addTemplateMap ${temp_acc_name} $current_accel
      lappend accels ${current_accel}
      set clk_id ""
      set shared_aximm 0
      set accelmap_clkid($current_accel) ""
      set hls_tcl_directive_file ""
      set accelmap_hls_tcl_directive_file($current_accel) ""
      set hls_subfile_list {}
      set accelmap_hls_subfile_list($current_accel) {}
    }
  } elseif {[string match ${SDS_END_BLOCK} $arg]} {
    # MSG_PRINT "Reached ${SDS_END_BLOCK}"
    set current_accel ""
  } elseif {[string match "-*" $arg]} {
    lappend other_switches $arg
    sdscc_check_option_typo $arg
    if { [::sdsoc::opt::isObsoleteOption $arg] } {
      MSG_ERROR $::sdsoc::msg::idSCOptObsolete "Obsolete option $arg specified, use the --help option to display currently supported sdscc/sds++ options"
      sdscc_on_exit 1
    }
    # if only one option is specified and it's not recognized by now, it's
    # probably a typo
    if { $argc < 3 } {
      MSG_ERROR $::sdsoc::msg::idSCOptUnrecognized "Unrecognized option $arg specified, use the --help option to display currently supported sdscc/sds++ options, or refer to gcc/g++ documentation for ARM cross-compiler toolchain options."
      sdscc_on_exit 1
    }
  } else {
    # If no switch matched, append to source list
    lappend infiles $arg
    # when linking, check for libraries specified as positional arguments
    if {! $compile } {
      set posArg ${arg}
      set posArgNormalized [file normalize [file join $run_dir ${posArg}]]
      set posArgName [file tail ${posArgNormalized}]
      set posArgPath [file dirname ${posArgNormalized}]
      # check if the argument is library, add to list for processing
      if {[regexp {^lib(.*)\.a$} ${posArgName} -> posLibName]} {
        lappend inlibs ${posLibName}
        lappend inlibpaths ${posArgPath}
      }
    }
  }
}

# update platform search path
if {[llength $pfPathList] > 0} {
  set pfPathDict [::sdsoc::pfmx::set_platform_search_path {*}$pfPathList]
  if {[dict size $pfPathDict] > 0 && $verbose} {
    puts "Platform search path"
    dict for {pathPosition pathValue} $pfPathDict {
      puts "$pathPosition $pathValue"
    }
  }
}

# create RTL IP repository search path
if { $compile } {
  lappend other_switches "-D"
  lappend other_switches "[apc_get_global APCC_MACRO_CC]"
}

# create RTL IP repository search path
if { [llength ${ip_repo_option_list}] > 0} {
  set ip_repo_dir_list [concat ${ip_repo_option_list} ${ip_repo_default_list}]
} else {
  set ip_repo_dir_list ${ip_repo_default_list}
  # only enable if -ip-repo was specified
  ::sdsoc::opt::setOptAddIpRepo 0
}

# check if trace is enabled but neither emulation nor bitstream generation
if {! $compile } {
  if {$insert_trace_hw} {
    if {! $run_emulation_export && ! $run_bitstream} {
      MSG_ERROR $::sdsoc::msg::idSCOptTraceNoBitOrEmu "Event tracing option -trace specified but neither bitstream generation nor emulation is enabled."
      sdscc_on_exit 1
    }
  }
}

# if no arguments, bail out
if {$argc < [apc_get_global APCC_MIN_ARGC]} {
  puts -nonewline "no arguments specified, for help type: "
  puts "[apc_get_global APCC_COMMAND_NAME] --help"
  sdscc_on_exit 2
}

# -rebuild-sw-only should only be used after having run SDSoC
# at least once
if { $dev_run_software_only && ! [file exists $sdscc_dir] } {
  MSG_ERROR $::sdsoc::msg::idSCOptRebuildSwOnly "-rebuild-sw-only can only be used after running [apc_get_global APCC_COMMAND_NAME] at least once to generate an application ELF and associated hardware"
  sdscc_on_exit 1
}

# Print version information
if {$version} {
  puts [apc_get_global APCC_VERSION]
  sdscc_on_exit 0
}

# Check for a license
if {! [apc_get_global APCC_IS_TOOLCHAIN_QUERY] && $pf_list == 0 && $pf_info == 0} {
  if { ! [is_license_available "ap_sdsoc" 0] } {
    if { ! [is_license_available "ap_cc" 0] } {
      MSG_ERROR $::sdsoc::msg::idSCLicense "license not available for SDSoC"
      sdscc_on_exit 1
    }
  }
}

# set toolchain information
set toolchain_type "baremetal"
if { [string equal -nocase $target_os_type "linux"] } {
  set toolchain_type "linux"
} 
if {[string first "zcu" $xsd_platform] >= 0} {
  set toolchain_config "zynq_ultrascale.cfg"
  set proc_instance [apc_get_global APCC_PROC_INSTANCE]
  if {[string length $proc_instance] < 1} {
    set proc_instance "psu_cortexa53_0"
  }
  set proc_type [apc_get_global APCC_PROC_TYPE]
  if {[string length $proc_type] < 1} {
    set proc_type "cortex-a53"
  }
} else {
  set toolchain_config [apc_get_global APCC_TOOLCHAIN_CONFIG]
  if {[string length $toolchain_config] < 1} {
    set toolchain_config "zynq.cfg"
  }
  set proc_instance [apc_get_global APCC_PROC_INSTANCE]
  if {[string length $proc_instance] < 1} {
    set proc_instance "ps7_cortexa9_0"
  }
  set proc_type [apc_get_global APCC_PROC_TYPE]
  if {[string length $proc_type] < 1} {
    set proc_type "cortex-a9"
  }
}
apc_set_global APCC_TOOLCHAIN_CONFIG $toolchain_config
apc_set_global APCC_TOOLCHAIN_TYPE $toolchain_type
apc_set_global APCC_TOOLCHAIN_NAME "arm-linaro"
apc_set_global APCC_PROC_TYPE $proc_type
apc_set_global APCC_PROC_INSTANCE $proc_instance

# Print help information
if {$help} {
  ::sdsoc::opt::printUsage [apc_get_global APCC_COMMAND_NAME] $compiler ""
  sdscc_on_exit 0
}

###############################################################################
# Initialize globals
# - Occurs after command line options have been parsed
###############################################################################
proc apc_initialize_globals {} {
  global apc
  global verbose

  if {$verbose} {
    set apc(APCC_OPT_VERBOSE) "-verbose"
  } else {
    set apc(APCC_OPT_VERBOSE) ""
  }

# if {$verbose} {
#   parray apc
# }
}

###############################################################################
# Define filenames and directories
###############################################################################

# Initialize globals
apc_initialize_globals


if {$compile && $run_hls} {
  apc_set_global APCC_FLOW_TYPE APCC_COMPILE_HLS_FLOW
}

set hls_dir     [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_VHLS]]
set data_dir    [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_DATA]]
set hw_dir      [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_HWTEMP]]
set libs_dir    [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_LIBS]]
set llvm_dir    [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_LLVM]]
set cf_dir      [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_CFWORK]]
set pp_dir      [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PREPROCESS]]
set swstubs_dir [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_SWSTUBS]]
set xsd_dir     [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_COMPONENTDB]]
set ipi_dir     [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_IPREPO]]
set rpt_dir     [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_REPORTS]]
set est_dir     [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_EST]]
set trace_dir   [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_TRACE]]
#set hasTrace_dir [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]0 [apc_get_global APCC_DIR_SDS_CFWORK] ".hwTraceMapping"]

set sdscc_name [apc_get_global APCC_REPORT_PREFIX]
if {$compile} {
  append sdscc_name "_"
  append sdscc_name [file rootname [file tail $infiles]]
  set accel $accels
  apc_set_global APCC_HLS_SYNTHESIS_LOG [file normalize [file join $hls_dir $accel solution syn report ${accel}_csynth.rpt]]
} else {
  #apc_set_global APCC_VIVADO_LOG [file normalize [file join $ipi_dir vivado.log]]
  apc_set_global APCC_VIVADO_LOG [file normalize [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]0 [apc_get_global APCC_DIR_SDS_PART_IPI] vivado.log]]
  #apc_set_global APCC_VIVADO_TIMING_SUMMARY [file normalize [file join $ipi_dir top.runs impl_1 top_wrapper_timing_summary_routed.rpt]]
  #apc_set_global APCC_VIVADO_UTILIZATION_SUMMARY [file normalize [file join $ipi_dir top.runs impl_1 top_wrapper_utilization_placed.rpt]]
  #apc_set_global APCC_VIVADO_TIMING_SUMMARY [file normalize [file join $ipi_dir ${xsd_platform}.runs impl_1 ${xsd_platform}_wrapper_timing_summary_routed.rpt]]
  apc_set_global APCC_VIVADO_TIMING_SUMMARY [file normalize [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]0 [apc_get_global APCC_DIR_SDS_PART_IPI] ${xsd_platform}.runs impl_1 ${xsd_platform}_wrapper_timing_summary_routed.rpt]]
  #apc_set_global APCC_VIVADO_UTILIZATION_SUMMARY [file normalize [file join $ipi_dir ${xsd_platform}.runs impl_1 ${xsd_platform}_wrapper_utilization_placed.rpt]]
  apc_set_global APCC_VIVADO_UTILIZATION_SUMMARY [file normalize [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]0 [apc_get_global APCC_DIR_SDS_PART_IPI] ${xsd_platform}.runs impl_1 ${xsd_platform}_wrapper_utilization_placed.rpt]]
}
set sdscc_log_name [file join $rpt_dir ${sdscc_name}.log]
apc_set_global APCC_LOG $sdscc_log_name

set sdscc_journal_name [file join $rpt_dir ${sdscc_name}.jou]
apc_set_global APCC_JOURNAL $sdscc_journal_name
set sdscc_report_name [file join $rpt_dir ${sdscc_name}.rpt]
apc_set_global APCC_REPORT $sdscc_report_name

# Do this early for -pf-list and -pf-info
set platform_hw_xml ""
set platform_sw_xml ""

# create run-specific temporary directory for platform handling
if {$compile && [expr [llength $infiles] == 1]} {
  set temp_compile [file normalize [file join $sdscc_temp_dir [string map {"." "_"} [file tail $infiles]]]]
  file mkdir $temp_compile
  ::sdsoc::pfmx::set_temp_dir $temp_compile
}

if {[string length $xsd_platform] > 0} {
  resolve_platform_configuration $xsd_platform $pf_info
   
  set platform_hw_xml [resolve_hw_platform_file $xsd_platform]
  if { [string length $platform_hw_xml] > 0} {
      set platform_sw_xml [resolve_sw_platform_file $xsd_platform]
    if {! $pf_info } {
      set_pf_proc_info $platform_sw_xml
      set_pf_toolchain_info $platform_sw_xml
      set_pf_library_files $platform_sw_xml
      set_pf_boot_files $platform_sw_xml
      set_pf_hardware_files $platform_sw_xml
      # check if emulation is supported
      if { $run_emulation_export } {
        if {![emu_is_supported]} {
          MSG_ERROR $::sdsoc::msg::idSCOptEmuUnsupported "Emulation is not supported for this platform using the specified system configuration and OS"
          sdscc_on_exit 1
        }
      }
    }
  } else {
    MSG_ERROR $::sdsoc::msg::idSCPlatformInvalid "Platform specified as $xsd_platform but the hw platform XML file was not found - is the platform name correct and is the path to the platform correct (if required)?"
    if {$pf_info} {
      sdscc_on_exit 2
    }
    sdscc_on_exit 1
  }
}

set toolchain_config [apc_get_global APCC_TOOLCHAIN_CONFIG]
set toolchain_type [apc_get_global APCC_TOOLCHAIN_TYPE]
set toolchain_name [apc_get_global APCC_TOOLCHAIN_NAME]
set proc_type [apc_get_global APCC_PROC_TYPE]
sdscc_set_toolchain_config $toolchain_config $toolchain_type $proc_type $toolchain_name


# check for missing or invalid platform
if {$pf_list == 0} {
  if { [has_xsd_platform] } {
    if { [string length $platform_hw_xml] < 1} {
      MSG_ERROR $::sdsoc::msg::idSCPlatformNotFound "Platform specified by [apc_get_global APCC_OPT_PLATFORM] [apc_get_global APCC_PLATFORM_VALUE] was not found"
      sdscc_on_exit 1
    }
  } else {
    # Suppress this error for now : sdslib calls sdscc/sds++ without -sds-pdf
    # MSG_ERROR $::sdsoc::msg::id "Platform option [apc_get_global APCC_OPT_PLATFORM] was not specified on the command line"
    # sdscc_on_exit 1
  }
}

# For compiles, partial check for multiple clock systems
# (partial because we don't check IP that might come from
# libraries and use the default clock ID). When creating
# the ELF and bitstream, a more complete check is run.
if {$compile} {
  set default_clk [get_default_clock_id]
  check_multiple_clocks_in_argv $default_clk
  set source_count 0
  foreach infile $infiles {
    if {[is_any_source $infile]} {
      incr source_count
    }
  }
  if {$source_count > 1} {
    MSG_ERROR $::sdsoc::msg::idSCMultipleInputFiles "Cannot specify multiple input files for compilation : $infiles"
    sdscc_on_exit 1
  }
}

if {$verbose} {
  set redirect ">@ stdout 2>@ stderr"
} else {
  set redirect "2>@ stderr"
}

# Make infiles a full path
set infiles_abs {}
foreach infile $infiles {
  lappend infiles_abs [file normalize [file join $run_dir $infile]]
}
set infiles_orig $infiles
set infiles $infiles_abs

# Resolve outfile if not given
if {[string equal $outfile ""]} {
  if {$compile} {
    if {[expr [llength $infiles] == 0]} {
      # Leave output files empty
    } elseif {[expr [llength $infiles] == 1]} {
      # Still need to add support for compiling multiple input files
      set outfile [file rootname [file tail $infiles]].o
    } else {
      if {! [apc_get_global APCC_COMPILER_OUTPUT_OPTION_USED]} {
        apc_set_global APCC_COMPILER_NOOP_FLOW 1
        MSG_WARNING $::sdsoc::msg::idSCMultipleInputFilesLink "Multiple input files specified and -o option missing, flow may not be fully supported - check your results"
      } else {
        MSG_ERROR $::sdsoc::msg::idSCMultipleInputFilesCompile "Multiple input files not supported for compilation"
      }
    }
  }
}

if {![string equal $outfile ""]} {
  apc_set_global APCC_COMPILER_OUTPUT_OPTION_USED 1
  set outfile_str "-o $outfile"
}

# Other filenames
set stubs {}
set asms {}
foreach infile $infiles_orig {
  lappend stubs [file rootname $infile]_stub.cpp
  # will need a better way to define asms in case there are directories
  # long filenames may break windows
  #lappend asms [file join ${llvm_dir} [file rootname [file tail $infile]].s]
  lappend asms [file join ${llvm_dir} [file rootname $infile].s]
}
#set bitstream [file rootname $outfile].bit
set bitstream $outfile.bit

# Early switch checks
if {$compile == 0 && $pf_info == 0 && $pf_list == 0 && $run_boot_files} {
  if {![file exists $bitstream] && $run_bitstream == 0 && $perf_prepass == 0 && $perf_est == 0} {
    MSG_WARNING $::sdsoc::msg::idSCBootNeedsBit "Cannot generate boot files without a bitstream;\n-mboot-files specified, while -mno-bistream disabled\nbitstream generation and a bitstream was not found"

    # Uncomment this and change the message above to ERROR if
    # we want to exit is SD card won't be created
    #exit_with_override 1

    # if -mno-bitstream and -mboot-files, and no existing bitstream,
    # exit override means hidden option -mdev-no-exit was given,
    # this is an internal only flow to build software using an override

    MSG_WARNING $::sdsoc::msg::idSCNoSdCard "disabling -mboot-files option, no SD card will be created"
    set run_boot_files 0
  }
}

# Early checks for existent files
if {[string length $vlnv] != 0} {
  if {[string length $fcnmap_file] == 0} {
    MSG_ERROR $::sdsoc::msg::idSCVlnvIpMap "The -vlnv switch is used but the -ip-map switch is missing"
  } else {
    if {![file exists $fcnmap_file]} {
      MSG_ERROR $::sdsoc::msg::idSCNoFunctionMap "File $fcnmap_file given to -ip-map does not exist"
    }
  }
  if {[string length $params_file] == 0} {
    MSG_ERROR $::sdsoc::msg::idSCVlnvIpParams "The -vlnv switch is used but the -ip-params switch is missing"
  } else {
    if {![file exists $params_file]} {
      MSG_ERROR $::sdsoc::msg::idSCIpParamsFileExist "File $params_file given to -ip-params does not exist"
    }
  }
}

# Check if the -hls-tcl option was given and the file exists
foreach accel $accels {
  if {[string length $accelmap_hls_tcl_directive_file($accel)] > 0} {
    if {! [file exists $accelmap_hls_tcl_directive_file($accel)]} {
      MSG_WARNING $::sdsoc::msg::idSCHlsDirectivesNone "Cannot find user-defined HLS directive file, ignoring $accelmap_hls_tcl_directive_file($accel)"
      set accelmap_hls_tcl_directive_file($accel) ""
    } else {
      MSG_INFO $::sdsoc::msg::idSCHlsDirectivesUse "user-defined HLS directive file specified $accelmap_hls_tcl_directive_file($accel)"
      # don't run pragma_gen for this accelerator
    }
  }
}

if {$pf_info == 0 && $pf_list == 0 && [apc_get_global APCC_IS_TOOLCHAIN_QUERY] == 0} {

  # Create flow directories
  file mkdir $sdscc_dir
  file mkdir $data_dir
  file mkdir $hw_dir
  file mkdir $libs_dir
  file mkdir $llvm_dir
  file mkdir $swstubs_dir
  file mkdir $rpt_dir
  if {$perf_est || $perf_prepass} {
    file mkdir $est_dir
  }  

  if {$dev_run_log} {
    log_open $sdscc_log_name
    global fp_log
    append redirect " >@ $fp_log 2>@ $fp_log"
  }

  journal_open $sdscc_journal_name
}

###############################################################################
# Vivado HLS and IPI Compile Flow
###############################################################################

# Extract SDSoC metadata XML file containing tool version and
# additional information required to support backward compatibility.
proc extract_sdsoc_metadata_xml {o_file sec_name x_file} {
  global toolchain

    set command "[get_objcopy] -O binary --set-section-flags ${sec_name}=alloc --only-section=${sec_name} ${o_file} ${x_file}"
  set objcopy_ec [exec_command_always_return $command]
  if {$objcopy_ec != 0} {
    if {[file exists $x_file]} {
      if {[file size $x_file] == "0"} {
        delete_file $x_file
      }
    }
  } elseif {[file size $x_file] == "0"} {
    delete_file $x_file
  }
  if {[file exists ${x_file}]} {
    return 0
  }
  return 1
}

# 3/6/2013: Mohan recommended clean-up using 2012.4
# 1. add_file changes to add_files
# 2. elaborate can be removed
# 3. autosyn changes to csynth_design
# 4. autoimpl -export-setup changees to export_design -format pcore -use_netlist none

# Write Vivado HLS TCL directives
proc write_hls_tcl_directives {fp period accel tcl_directives_file} {
  global  accelmap_hls_tcl_directive_file

  puts $fp "# synthesis directives"
  # Give a 15% slack
  puts $fp "create_clock -period $period"
  puts $fp "set_clock_uncertainty 27.0%"
  # Zynq UltraScale+ Cortex-A53
  if { [proc_is_cortex_a53] || [proc_is_x86]} {
    puts $fp "config_interface -m_axi_addr64"
  }
  # Don't include the config_rtl line below for HLS OpenCL blocks
  if {! [apc_get_global APCC_IS_HLS_OPENCL] } {
    puts $fp "config_rtl -reset_level low"
  }
  # TCL directives file created by pragma_gen, if any
  if {[string length $tcl_directives_file] > 0} {
    puts $fp "source $tcl_directives_file"
  }
  if {[string length $accelmap_hls_tcl_directive_file($accel)] > 0} {
    puts $fp "# user-defined synthesis directives"
    puts $fp "source $accelmap_hls_tcl_directive_file($accel)"
    puts $fp "# end user-defined synthesis directives"
  }
  puts $fp "# end synthesis directives"
}

# Filter out flags for Vivado HLS which are not accepted
proc filter_hls_flags {other_flags} {
  set hls_flags [list]
  foreach flagp $other_flags {
    switch -glob -- $flagp {
      "-march=*"    { }
      "-mcpu=*"     { }
      "-mtune=*"    { }
      "-pg"         { }
      "-M*"         { }
      default       { lappend hls_flags $flagp }
    }
  }
  return $hls_flags
}

# create a list of paths in the HLS TCL script
proc get_hls_paths {sources subfile_list hls_other_switches} {
  global run_dir

  set pathlist [list]
  # path to the source file
  lappend pathlist [file dirname ${sources}]
  # path to subfiles
  if { [llength ${subfile_list}] > 0 } {
    foreach subfile ${subfile_list} {
      set curpath [file dirname ${subfile}]
      if {[lsearch -exact $pathlist ${curpath}] < 0} {
        lappend pathlist ${curpath}
      }
    }
  }
  # include paths
  set path2sdsoc [apc_get_global APCC_PATH_XILINX_XD]
  set s_hls [string map {"-I" "-I "} $hls_other_switches]
  set s_hls [regexp -all -inline {\S+} $s_hls]
  set s_list [split $s_hls]
  set s_count [llength $s_list]
  if {$s_count > 0} {
    for {set i 0} {$i < $s_count} {incr i} {
      set s_tok [lindex $s_list $i]
      if {[string equal "-I" $s_tok]} {
        incr i
        set curpath [lindex $s_list $i]
        if {[string first $path2sdsoc $curpath] >= 0} {
          continue
        }
        if {[lsearch -exact $pathlist ${curpath}] < 0} {
          lappend pathlist ${curpath}
        }
      }
    }
  }
  # path sdscc/sds++ was run in
  if {[lsearch -exact $pathlist ${run_dir}] < 0} {
    lappend pathlist ${run_dir}
  }
  return $pathlist
}

# Return a list of HLS script shared paths
proc get_hls_shared_paths { plist } {
  set shlist [list]
  set tmplist [lsort $plist]

  set has_match 0
  set s_max [llength $tmplist]
  if {$s_max == 1} {
    return $tmplist
  }
  for {set i 0} {$i < $s_max} {incr i} {
    if {$i < 1} {
      set parent [lindex $tmplist 0]
      if {[string first $parent [lindex $tmplist 1]] < 0} {
        set parent [file dirname [lindex $tmplist $i]]
      }
      continue
    }
    set curpath [lindex $tmplist $i]
    if {[string first $parent $curpath] >= 0} {
      set has_match 1
      continue
    }
    lappend shlist ${curpath}
  }
  if {$has_match} {
    lappend shlist $parent
  } else {
    lappend shlist [lindex $tmplist 0]
  }

  set shlist [lsort $shlist]
  return $shlist
}

# Create Vivado HLS TCL test that's easier to move around
proc write_hls_run_tcl_test_script {tcl_file pathlist} {
  set path2sdsoc [apc_get_global APCC_PATH_XILINX_XD]

  set test_tcl_file [string map {"_run.tcl" "_run_test.tcl"} $tcl_file]
  set fp [open ${test_tcl_file} w]
  puts $fp "# ==========================================================="
  puts $fp "# = Vivado HLS test script"
  puts $fp "# ="
  puts $fp "# = Copy <accel>_run_test.tcl, <accel>_tb.tcl and <accel>.tcl"
  puts $fp "# = to a working directory, plus the source files for the test."
  puts $fp "# = Updates path variables in <accel>_run_test.tcl to reflect"
  puts $fp "# = the location of source files used by the script. Run the"
  puts $fp "# = Vivado HLS command below:"
  puts $fp "# ="
  puts $fp "# =   vivado_hls [file tail $test_tcl_file]"
  puts $fp "# ="
  puts $fp "# = To run cosimulation, first set run_cosim 1."
  puts $fp "# ==========================================================="
  puts $fp "set run_cosim 0"
  puts $fp "set path2sdsoc ${path2sdsoc}"
  set i 0
  foreach curpath $pathlist {
    puts $fp "set path2src$i  ${curpath}"
    incr i
  }
  puts $fp "# ==========================================================="
  puts $fp "# = Vivado HLS run script"
  puts $fp "# ==========================================================="
  
  set infp [open ${tcl_file} r]
  while {[gets $infp tcl_buf] >= 0} {
    # replace paths in SDSoC install and project
    if {[string first "add_files" ${tcl_buf}] >= 0} {
      set sbuf [string map [list ${path2sdsoc} "\$\{path2sdsoc\}"] ${tcl_buf}]
      set i 0
      foreach curpath $pathlist {
        set sbuf [string map [list ${curpath} "\$\{path2src$i\}"] ${sbuf}]
        incr i
      }
      puts $fp ${sbuf}
      continue
    }
    # use pragma_gen TCL file name
    if {[string first "source" ${tcl_buf}] >= 0} {
      set tok [split ${tcl_buf}]
      puts $fp "source [file tail [lindex $tok 1]]"
      continue
    }
    # insert commands for Vivado HLS cosim
    if {[string first "open_solution" ${tcl_buf}] >= 0} {
      set tb_tcl_file [string map {"_run.tcl" "_tb.tcl"} $tcl_file]
      puts $fp "if \{\$run_cosim\} \{"
      puts $fp "  source [file tail $tb_tcl_file]"
      puts $fp "\}"
    }
    # skip the exit, will add that later
    if {[string first "exit" ${tcl_buf}] >= 0} {
      continue
    }
    # otherwise, output text as is
    puts $fp ${tcl_buf}
  }
  close $infp
  puts $fp "if \{\$run_cosim\} \{"
  puts $fp "  cosim_design"
  puts $fp "\}"
  puts $fp "exit"

  close $fp
}

# Create prefix string for Vivado HLS IP
proc get_hls_prefix { accel } {
  global hls_dir

  # file containing prefix information
  set prefix_file [file join $hls_dir prefix.dat]
  set prefix_lock_file [file join $hls_dir prefix.loc]

  # get lock on template.dat (file shared across compiles
  if {! [::sdsoc::lock::createLock ${prefix_lock_file} ${accel}] } {
    MSG_ERROR $::sdsoc::msg::idSCUpdateHlsPrefixFile "Can't create Vivado HLS prefix for $accel"
    sdscc_on_exit 1
  }

  # read file containing accelerator names
  set prefixNames [list]
  if {[file exists $prefix_file]} {
    set fp [open ${prefix_file} r]
    while {[gets $fp sbuf] > -1} {
      lappend prefixNames [lindex ${sbuf} 0]
    }
    close $fp
  }

  # try to find the accelerator
  set nameIndex [lsearch -exact $prefixNames ${accel}]
  if {$nameIndex < 0} {
    set nameIndex [llength $prefixNames]
    lappend prefixNames ${accel}
    set fp [open ${prefix_file} w]
    foreach s $prefixNames {
      puts $fp "${s}"
    }
    close $fp
  }

  # release lock on prefix.dat
  ::sdsoc::lock::removeLock ${prefix_lock_file}

  # set the prefix
  set hls_prefix "a${nameIndex}_"
  return $hls_prefix
}

# Create Vivado HLS TCL to create accelerator for Vivado/IPI
proc write_hls_run_tcl {tcl_file xsd_platform period accel sources tcl_directives_file other_switches} {
  global run_dir dev_run_pragmagen accelmap_hls_subfile_list 
  global debug_hls

  # generate a unique prefix
  set hls_prefix [get_hls_prefix ${accel}]

  # Vivado HLS errors out if it sees the -pg option (profiling),
  # so remove that option here
  set hls_other_switches [filter_hls_flags $other_switches]
  # -D __SDSVHLS_SYNTHESIS__ internal macro for Vivado HLS add_files w/o -tb
  set hls_macros "-D [apc_get_global APCC_MACRO_VHLS] -D __SDSVHLS_SYNTHESIS__"
  set fp [open ${tcl_file} w]
  puts $fp "open_project ${accel}"
  puts $fp "set_top ${accel}"
  set subfile_list $accelmap_hls_subfile_list($accel)

  puts $fp "add_files ${sources} -cflags \"$hls_other_switches $hls_macros -I ${run_dir} -w\""
  if { [llength ${subfile_list}] > 0 } {
    foreach subfile ${subfile_list} {
      puts $fp "add_files $subfile -cflags \"$hls_other_switches $hls_macros -I ${run_dir} -w\""
    }
  }

  puts $fp "open_solution \"solution\" -reset"
  set part [get_part]
  if {[string length $part] != 0} {
    puts $fp "set_part \{ $part \}"
  } else {
    MSG_ERROR $::sdsoc::msg::idSCHlsNoPart "Unable to find part for platform $xsd_platform"
    close $fp
    sdscc_on_exit 1
  }
  write_hls_tcl_directives $fp $period $accel $tcl_directives_file
  puts $fp "config_rtl -prefix ${hls_prefix}"
  puts $fp "csynth_design"
  puts $fp "export_design -ipname ${accel} -acc"
  puts $fp "exit"
  close $fp

  # create HLS unit test script (needs to be made general)
  if {$debug_hls} {
    set pathlist [get_hls_paths $sources $subfile_list $hls_other_switches]
    set pathlist [get_hls_shared_paths $pathlist]
    write_hls_run_tcl_test_script $tcl_file $pathlist
  }
}

# Create Vivado HLS TCL testbench files for cosimulation
proc write_hls_tb_tcl_file {accel objects} {
  global hls_dir

  # collect shared paths
  set pathlist {}
  set varlist {}
  set tcl_file [file join ${hls_dir} ${accel}_run_test.tcl]
  if {[file exists $tcl_file]} {
    set fp [open ${tcl_file} r]
    while {[gets $fp tcl_buf] >= 0} {
      if {[string first "set" ${tcl_buf}] < 0 ||
          [string first "path2" ${tcl_buf}] < 0} {
        continue
      }
      scan $tcl_buf "%s %s %s" junk s_var s_path
      lappend pathlist $s_path
      lappend varlist $s_var
    }
    close $fp
  }

  # collect shared paths
  set xml_file [file join ${hls_dir} xdsdata.xml]
  set tcl_file [file join ${hls_dir} ${accel}_tb.tcl]
  set fp [open ${tcl_file} w]
  foreach obj $objects {
    set ec [extract_sdsoc_metadata_xml $obj ".xdsdata" $xml_file]
    if { $ec != 0 } {
      continue
    }
    set srcname [xpath_get_value $xml_file "xd:data/xd:source/@name"]
    set srcpath [xpath_get_value $xml_file "xd:data/xd:source/@srcpath"]
    set flags   [xpath_get_value $xml_file "xd:data/xd:source/@flags"]
    set hls_flags [filter_hls_flags $flags]
    append hls_flags " " [get_implicit_flags_for_vhls]
    set sbuf "add_files -tb [file join $srcpath $srcname] -cflags \"$hls_flags\""
    set i 0
    foreach curpath $pathlist {
      set s_var [lindex $varlist $i]
      set sbuf [string map [list ${curpath} "\$\{$s_var\}"] ${sbuf}]
      incr i
    }
    puts $fp $sbuf
  } 
  close $fp
  if {[file exists $xml_file]} {
    delete_file $xml_file
  }
}

##############################################################################
# Compiler flow
###############################################################################

# run simple checks at the start of the compile flow
proc run_compile_flow_checks {source_file incl_flags other_mf_mt_flags other_flags} {
  global outfile outfile_str toolchain compiler run_hls hls_dir accels xsd_platform vlnv

  # Early exit if SDSoC toolchain query
  if { [apc_get_global APCC_IS_TOOLCHAIN_QUERY] } {
    set command "[get_cc] -c $incl_flags $other_flags $other_mf_mt_flags [get_implicit_flags_for_gcc] $source_file $outfile_str"
    exec_command_and_print $command
    if { [file exists $outfile] } {
      delete_file $outfile
    }
    exit 0
  }
  if {$run_hls} {
    file mkdir $hls_dir

    # 2015.2 SDSoC allows more than one top-level accelerator
    # function in a source file, so don't error out here.
    # Make sure $accels is a single list item
    if {[llength $accels] > 1 } {
      if {[apc_get_global APCC_DRC_ONE_ACCEL_PER_SOURCE]} {
        MSG_ERROR $::sdsoc::msg::idSCMultipleHwBad "Multiple '-hw' switches not allowed"
        sdscc_on_exit 1
      }
    }

    # Make sure we have a platform specified
    if {([string length $xsd_platform] == 0) && ([string length $vlnv] == 0)} {
      MSG_ERROR $::sdsoc::msg::idSCMissingSdsHw "Missing [apc_get_global APCC_OPT_PLATFORM] switch. Required when [apc_get_global APCC_OPT_HW_BLOCK] is used"
      sdscc_on_exit 1
    }
  }

  # Disable this check, since -pf may be specified to add platform
  # header files, but this isn't necessarily an accelerator.

# if {[string length $xsd_platform] != 0} {
#   # Make sure there was an accelerator specified
#   if {!$run_hls} {
#     MSG_ERROR $::sdsoc::msg::id "Missing '-hw' switch"
#     sdscc_on_exit 1
#   }
# }
}

###################################by Zhenman###############################################
# Replace the -perf-funcs option in case of a template function, mainly for SW estimation
# this will be called by 1) run_perf_instrumenter_on_source at compile time: get template
# functions from -sds-hw arguments and 2) before stitch_perf_file_fragments at link time,
# get template functions from temporary template.dat file generated in compile time

proc replaceTemplatePerfFuncsAtCompile {} {
    global accels backup_accels perf_funcs

    # one of the two lists accels and backup_accels is empty, join them together
    set allAccels [list {*}$accels {*}$backup_accels]

    foreach accel $allAccels {
        if { [::sdsoc::template::isTemplateFunction ${accel}] } {
            set funcName [::sdsoc::template::getMapMangled2Original ${accel}]
            if {[apc_is_windows]} {
                set funcName [::sdsoc::template::getWindowsEscapedName ${funcName}]
            } else {
                set funcName \"${funcName}\"
            }
            # replace the original name in perf_funcs with new wrapper name $accel
            set perf_funcs [::sdsoc::template::replaceSWPerfFunc ${perf_funcs} ${funcName} ${accel}]
        }
    }
}
proc replaceTemplatePerfFuncsAtLink {} {
    global perf_funcs
    # if the file containing function instantiation names is not known, return
    # an empty string
    set dataFile $::sdsoc::template::templateDataFile
    if {[string length $dataFile] < 1} {
        return
    }

    # read file containing template instantiation names (i.e., accels) in their original form
    # no locking issue at link time
    set templateNames [list]
    if {[file exists $dataFile]} {
        set fp [open ${dataFile} r]
        while {[gets $fp sbuf] > -1} {
            lappend templateNames [lindex ${sbuf} 0]
        }
        close $fp
    }

    foreach funcName $templateNames {
        if { [::sdsoc::template::isTemplateFunction ${funcName}] } {
            set wrapperFunc [::sdsoc::template::originalName2MangledName ${funcName}]
            if {[apc_is_windows]} {
                set funcName [::sdsoc::template::getWindowsEscapedName ${funcName}]
            } else {
                set funcName \"${funcName}\"
            }
            # replace the original name in perf_funcs with new wrapper name $accel
            set perf_funcs [::sdsoc::template::replaceSWPerfFunc ${perf_funcs} ${funcName} ${wrapperFunc}]
        }
    }
}
# replace all mangled function names with original template function names
proc getTemplatePerfFuncs {perfFuncs} {
    # iterate all existing funcs in perfFuncs list, and
    # replace all mangled names with original template names
    set functions [split ${perfFuncs} ","]
    set i 0
    foreach func ${functions} {
        if { [::sdsoc::template::isTemplateFunction ${func}] } {
            set funcName [::sdsoc::template::getMapMangled2Original ${func}]
        } else {
            set funcName ${func}
        }

        if {$i == 0} {
            set newPerfFuncs ${funcName}
        } else {
            append newPerfFuncs ";" ${funcName}
        }

        incr i
    }

    if {[apc_is_windows]} {
        set newPerfFuncs [::sdsoc::template::getWindowsEscapedName ${newPerfFuncs}]
    } else {
        set newPerfFuncs \"${newPerfFuncs}\"
    }

    return ${newPerfFuncs}
}

###################################by Zhenman###############################################

# instrument a source file for performance estimation
proc run_perf_instrumenter_on_source {source_file incl_flags other_flags} {
  global accels backup_accels run_hls run_bitstream perf_root perf_funcs est_dir compiler

  ###################################by Zhenman###############################################
  set llvm_other_flags [lregremove $other_flags {\-O[0-3]}]
  set tmp_source_file $source_file
  # one of the two lists accels and backup_accels is empty, join them together
  set allAccels [list {*}$accels {*}$backup_accels]
  foreach accel $allAccels {
    if { [::sdsoc::template::isTemplateFunction ${accel}] } {
      set wrapperFile [::sdsoc::template::getMapMangled2TemplateWrapper ${accel}]
      set tmp_dest_file [file join ${est_dir} $wrapperFile]
      set funcName [::sdsoc::template::getMapMangled2Original ${accel}]
      set compiler_type [set_compiler_type $tmp_source_file]
      if {[apc_is_windows]} {
        set funcName [::sdsoc::template::getWindowsEscapedName ${funcName}]
      } else {
        set funcName \"${funcName}\"
      }
      set command "[::sdsoc::utils::getCommandPath template_wrapper_gen] \
        -caller ${funcName} \
        -wrapper_name ${accel} \
        -wrapper_file ${tmp_dest_file} \
        $tmp_source_file \
        -- \
        -c \
        -I [file dirname $source_file] \
        $incl_flags \
        $llvm_other_flags \
        [get_implicit_flags_for_clang $compiler_type 0 0]"
      exec_command_and_print $command
      set tmp_source_file $tmp_dest_file
    }
  }
  # replace the original name in perf_funcs with new wrapper name
  replaceTemplatePerfFuncsAtCompile
  set templatePerfFuncs [getTemplatePerfFuncs ${perf_funcs}]
  ###################################by Zhenman###############################################
    
  set output_source [file join ${est_dir} [file tail $source_file]]
  set translated_source [file join [file dirname $output_source] unix_[file tail $output_source]]
  copy_file_translate_to_unix $tmp_source_file $translated_source    
  set compiler_type [set_compiler_type $translated_source]
  set command "[::sdsoc::utils::getCommandPath perf_instrumenter] \
    -r $perf_root \
    -funclist $perf_funcs \
    -tempfunclist $templatePerfFuncs \
    -w $est_dir \
    -o $output_source \
    $translated_source \
    -- \
    -c \
    -I [file dirname $source_file] \
    $incl_flags \
    $llvm_other_flags \
    [get_implicit_flags_for_clang $compiler_type 0 0]"
  exec_command_and_print $command
  #delete_file $translated_source
  set accels {}
  set run_hls 0
  set run_bitstream 0
}

# create clang intermediate representation file (_sds/.llvm/<source>.s
proc create_clang_intermediate_representation {source_file ctype incl_flags other_flags} {
  global dev_run_llvm llvm_dir outfile compiler

  set asm_file "NA"
  if {$dev_run_llvm && ! [apc_get_global APCC_IS_HLS_OPENCL] } {
    # Process all source files with clang
    set outfile_s [file join $llvm_dir [file rootname $outfile].s]

    # Ensure the directory for the output file exists
    file mkdir [file dirname $outfile_s]

    # Disable optimizations for llvm or clang (may need a better solution).
    # Also, disable exception handling, which affects the control flow graph
    # and therefor data flow analysis.
    MSG_PRINT "Create data motion intermediate representation"
    set llvm_other_flags [lregremove $other_flags {\-O[0-3]}]
    if {[string length $ctype] < 1} {
      set compiler_type [set_compiler_type $source_file]
    } else {
      set compiler_type $ctype
    }

    # Hacked here, the is_preprocessed parameter for get_implicit_flags_for_clang is changed from 0 to 1.
    # and specify the include file path here to avoid the header conflict between sdx's clang and sdk's gcc.
    # [apc_get_global APCC_IFLAGS_TOOLCHAIN_GCC] is removed from origin list.
    # MSG_PRINT "The include flag for clang is hacked."
    # set clang_hacked_include_flags " [apc_get_global APCC_IFLAGS_PLATFORM] \
    #        [apc_get_global APCC_IFLAGS_SDSLIB] \
    #        [apc_get_global APCC_MACRO_HLS_FPO] \
    #        [apc_get_global APCC_IFLAGS_VHLS] "
    # MSG_PRINT "clang_hacked_include_flags are $clang_hacked_include_flags"

    set command "[::sdsoc::utils::getCommandPath clang_wrapper] $incl_flags $llvm_other_flags [get_implicit_flags_for_clang $compiler_type 0 1] -emit-llvm -S $source_file -o $outfile_s"
    set clang_ec [execpipe_command $command 1 exec_success]
    
    # If clang errors out, delete any .s file created and exit.
    if {$clang_ec != 0} {
        MSG_ERROR $::sdsoc::msg::idSCClangError "clang exited with non-zero code processing $source_file"
        if {[file exists $outfile_s]} {
            delete_file $outfile_s
        }
        sdscc_on_exit 1
    }
    set asm_file $outfile_s
  } else {
    MSG_PRINT "Not running LLVM due to the -mdev-no-llvm switch"
  }
}

# create a preprocessed version of a source file using clang
proc create_clang_preprocessed_source_file {source_file pp_dir incl_flags other_flags} {
  global compiler

  set clang_incl_flags  [lregremove $incl_flags  {\-O[0-3]}]
  set clang_other_flags [lregremove $other_flags {\-O[0-3]}]
  set src_root [file rootname [file tail $source_file]]
  set src_ext [file extension $source_file]
  set pp_ext "_pp"
  set pp_file [file join ${pp_dir} ${src_root}${pp_ext}${src_ext}]

  set compiler_type [set_compiler_type $source_file]
  set command "[::sdsoc::utils::getCommandPath clang_wrapper] -E $clang_incl_flags $clang_other_flags [get_implicit_flags_for_clang $compiler_type 0 0] $source_file -o $pp_file"
  set clang_ec [execpipe_command $command 1 exec_success]
    
  # If clang errors out, delete any .s file created and exit.
  if {$clang_ec != 0} {
    MSG_ERROR $::sdsoc::msg::idSCClangErrorPreProcess "clang exited with non-zero code pre-processing $source_file"
    if {[file exists ${pp_file}]} {
      delete_file ${pp_file}
    }
    sdscc_on_exit 1
  }
  return $pp_file
}

# run SDSoC lint on each accelerator associated with a source file
proc run_sdsoc_lint_on_accelerators {source_file incl_flags other_flags} {
  # hack
  MSG_PRINT [stacktrace]
  # end hack
  global accels run_sdslint dev_run_llvm compiler

  if { [apc_get_global APCC_IS_HLS_OPENCL] } {
    return
  }
  if {! $run_sdslint} {
    return
  }
  if {! $dev_run_llvm} {
    return
  }
  foreach accel $accels {
    MSG_PRINT "Performing accelerator source linting for $accel"
    set llvm_other_flags [lregremove $other_flags {\-O[0-3]}]
    set compiler_type [set_compiler_type $source_file]
    if { [::sdsoc::template::isTemplateFunction ${accel}] } {
      set funcName [::sdsoc::template::getMapMangled2Original ${accel}]
      if {[apc_is_windows]} {
        set funcName [::sdsoc::template::getWindowsEscapedName ${funcName}]
      } else {
        set funcName \"${funcName}\"
      }
    } else {
      set funcName \"${accel}\"
    }
    set command "[::sdsoc::utils::getCommandPath sdslint] -target [apc_get_global APCC_PROC_TYPE] -func ${funcName} $source_file -- -c $incl_flags $llvm_other_flags [get_implicit_flags_for_clang $compiler_type 0 0]"
    set lint_ec [execpipe_command $command 0 exec_success]

    # If lint returns a non-zero code, ignore it initially to see
    # what happens withe the regressions.
    if {$lint_ec != 0} {
      MSG_ERROR $::sdsoc::msg::idSCSdslintError "sdslint exited with non-zero code processing $source_file for accelerator $accel"
      # sdslint returns -1 if there are compilation errors, positive
      # integers for lint issues, but unfortunately we lint_ec only
      # contains 0 or 1 (error)
      puts_command "Please correct any compilation or [apc_get_global APCC_COMMAND_NAME] compatibility issues."
      sdscc_on_exit 1
    }
  }
}

# compile a source file that has no accelerators
proc compile_source_without_accelerator {source_file incl_flags incl_flags_abs other_mf_mt_flags other_flags} {
  global perf_prepass perf_est est_dir toolchain compiler run_dir outfile outfile_str swstubs_dir

  MSG_PRINT "Compiling $source_file"
  if { $perf_prepass } {
    if { [file exists [file join ${est_dir} [file tail $source_file] ] ] } {
      set src_name [file join ${est_dir} [file tail $source_file]]
      set instrumented_source 1
    } else {
      set instrumented_source 0
      set src_name $source_file
    }
    set command "[get_cc] -c $incl_flags $other_flags $other_mf_mt_flags -I [file dirname $source_file] -I $run_dir [get_implicit_flags_for_gcc] $src_name $outfile_str"
    exec_command_and_print $command
    if { $instrumented_source } {
      copy_file_force_writeable $outfile [file join ${est_dir} [file tail ${outfile} ] ]
    }
    return
  } elseif { $perf_est } {
    if {![file exists $outfile]} {
      set command "[get_cc] -c $incl_flags $other_flags $other_mf_mt_flags [get_implicit_flags_for_gcc] $source_file $outfile_str"
      exec_command_and_print $command
    }
  } else {
    set command "[get_cc] -c $incl_flags $other_flags $other_mf_mt_flags [get_implicit_flags_for_gcc] $source_file $outfile_str"
        exec_command_and_print $command
  }

  # Special case : not generating .o file
  if { [apc_get_global APCC_COMPILER_NOOP_FLOW]} {
    return
  }

  # Save compiler command line information in case needed for caller rewrite
  #
  # If the file is moved, non-absolute paths need to be normalized
  # to be absolute paths and the path to the file added:
  #   1. -I ../<path>
  #   2. -I <single_directory_name_without_dot_h>
  #   3. -I <path_to_directory_containing_original_source_file>
  #
  # Note that -I with and without spaces needs to be handled, but
  # during option parsing all of the -I options have been normalized
  # so there is always one space.

  set src_name [file tail $source_file]
  set xml_file [file join ${swstubs_dir} [file rootname $src_name].o.xml]
  set fp [open ${xml_file} w]
  puts $fp "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  puts $fp "<xd:data xmlns:xd=\"http://www.xilinx.com/xd\">"
  puts -nonewline $fp "  <xd:source name=\"$src_name\""
  puts -nonewline $fp " compiler=\"$compiler\""
  puts -nonewline $fp " objfile=\"$outfile\""
  set srcpath [file dirname $source_file]
  puts -nonewline $fp " srcpath=\"$srcpath\""
  puts -nonewline $fp " flags=\"-I$srcpath $incl_flags_abs $other_flags\""
  puts $fp "/>"
  puts $fp "</xd:data>"
  close $fp

  # Package metadata into object file
    set command "[get_objcopy] --add-section .xdsdata=${xml_file} $outfile"
  exec_command $command
}

# Create Vivado HLS IP
proc create_vivado_hls_ip {accel acc_clk source_file incl_flags incl_flags_abs other_flags use_adapter} {
  # hack
  MSG_PRINT [stacktrace]
  # end hack
  global dev_run_pragmagen hls_dir compiler xsd_platform run_dir
  global other_pragmagen_switches debug_hls
  global shared_aximm

  # 2015.2 SDSoC allows more than one top-level accelerator
  # function in a source file, so need to handle that here.
  # Get period from platform file
  set period [get_clock_period $acc_clk]
  set hls_flags ""
  append hls_flags $incl_flags_abs " " $other_flags 
  append hls_flags " " [get_implicit_flags_for_vhls]

  # run pragma_gen on the accelerator source
  # (assumes you are in ${run_dir}
  set tcl_directives_file ""
  if {$shared_aximm} {
    set multi_aximm ""
  } else {
    set multi_aximm "-multi_aximm"
  }

  if { ${dev_run_pragmagen} } {
    append hls_flags " -I" [file normalize [file dirname $source_file]]
    if {! [apc_get_global APCC_IS_HLS_OPENCL] } {
      set tcl_directives_file [file join ${hls_dir} ${accel}.tcl]
      MSG_PRINT "Performing pragma generation"
      set hls_macros "-D [apc_get_global APCC_MACRO_VHLS]"
      # hack
      MSG_PRINT "hls_flags is ${hls_flags}"
      MSG_PRINT "dev_run_pramagen is ${dev_run_pragmagen} "
      # end hack
      set adapter_option ""
      if {! $use_adapter} {
        set adapter_option "-no_hls_adapter"
      }
      set pp_file [create_clang_preprocessed_source_file ${source_file} ${hls_dir} $hls_flags $hls_macros]
      if { [::sdsoc::template::isTemplateFunction ${accel}] } {
        set funcName [::sdsoc::template::getMapMangled2Original ${accel}]
        if {[apc_is_windows]} {
          set funcName [::sdsoc::template::getWindowsEscapedName ${funcName}]
        } else {
          set funcName \"${funcName}\"
        }
        set wrapper_switches "-wrapper_name ${accel}"
      } else {
        set funcName \"${accel}\"
        set wrapper_switches ""
      }
      set compiler_type [set_compiler_type $source_file]
      set command "[::sdsoc::utils::getCommandPath pragma_gen] \
        -func ${funcName} $adapter_option \
        -tcl $tcl_directives_file $wrapper_switches \
        $pp_file $multi_aximm $other_pragmagen_switches \
        -- \
        -c \
        ${hls_macros} ${hls_flags} \
        [get_implicit_flags_for_clang $compiler_type 0 0]"
      exec_command_and_print $command
    }
  }

  MSG_PRINT "Moving function $accel to Programmable Logic"

  # Create file _sds/vhls/${accel}_run.tcl using $source_file

  if { [::sdsoc::template::isTemplateFunction ${accel}] } {
    set wrapperFile [::sdsoc::template::getMapMangled2TemplateWrapper ${accel}]
    set hls_source_file [file join ${hls_dir} $wrapperFile]
    set funcName [::sdsoc::template::getMapMangled2Original ${accel}]
    set compiler_type [set_compiler_type $source_file]
    if {[apc_is_windows]} {
      set funcName [::sdsoc::template::getWindowsEscapedName ${funcName}]
    } else {
      set funcName \"${funcName}\"
    }
    set command "[::sdsoc::utils::getCommandPath hls_wrapper_gen] \
      -caller ${funcName} \
      -wrapper_name ${accel} \
      -wrapper_file ${hls_source_file} \
      $source_file \
      -- \
      -c \
      ${hls_macros} ${hls_flags} \
      [get_implicit_flags_for_clang $compiler_type 0 0]"
    exec_command_and_print $command
  } else {
    set hls_source_file $source_file
  }
  set tcl_file [file join ${hls_dir} ${accel}_run.tcl]
  write_hls_run_tcl $tcl_file $xsd_platform $period $accel $hls_source_file $tcl_directives_file $hls_flags

  # Run Vivado HLS to create ${accel}_top_v1_00_a IP core
  # For now remove any files from previous runs
  delete_directory [file join ${hls_dir} ${accel}]
  cd_command $hls_dir
  # set debug_hls 1
  MSG_PRINT "debug_hls is $debug_hls"
  if {$debug_hls} {
    set tcl_file [string map {"_run.tcl" "_run_test.tcl"} $tcl_file]
  }
  MSG_PRINT "tcl_file is $tcl_file"
  set hls_log "${accel}_vivado_hls.log"
  set command "[apc_get_global APCC_PATH_VHLS] $tcl_file -l ${hls_log}"
  exec_command $command
  MSG_PRINT "run_dir is $run_dir"
  cd_command $run_dir

  set component_xml [file join ${hls_dir} ${accel} solution impl ip component.xml]
  # 2014.2 workaround for CR801670, CR801797
  # Obsolete CR, but leave in Vivado HLS checks for now.
  set hls_ip_dir [file join ${hls_dir} ${accel} solution impl ip]
  set sol_log_file [file join ${hls_dir} ${accel} solution solution.log]
  set viv_log_file [file join ${hls_dir} ${hls_log}]
  global hls_log_list
  lappend hls_log_list ${viv_log_file}
  if {! [file exists $hls_ip_dir]} {
    set log_files "Vivado HLS messages"
    if { [file exists $sol_log_file]} {
      set log_files ${sol_log_file}
      if { [file exists $viv_log_file]} {
        append log_files " or ${viv_log_file}"
      }
    } elseif { [file exists $viv_log_file]} {
      set log_files ${viv_log_file}
    }
    MSG_ERROR $::sdsoc::msg::idSCHlsError "Problem detected in Vivado HLS run - unable to find solution implementation directory for ${accel} $hls_ip_dir. For possible causes, review ${log_files}."
    if {[file exists $viv_log_file]} {
      tail_file $viv_log_file 20
    } else {
      tail_file $sol_log_file 20
    }
    sdscc_on_exit 1
  }
  cd_command $hls_ip_dir
  if {! [file exists component.xml]} {
    MSG_ERROR $::sdsoc::msg::idSCHlsNoComponentXml "Problem detected in Vivado HLS run - unable find ${accel} file $hls_ip_dir/component.xml. See ${sol_log_file} or ${viv_log_file} for possible causes."
    if {[file exists $viv_log_file]} {
      tail_file $viv_log_file 20
    } else {
      tail_file $sol_log_file 20
    }
    sdscc_on_exit 1
  }
  cd_command $hls_dir
  # end workaround

  # change namespace to xidane in auxiliary.xml and copy to llvm directory
  set hls_auxiliary_xml [file join ${hls_dir} ${accel} solution impl ip auxiliary.xml]
  if {! [file exists $hls_auxiliary_xml]} {
    MSG_ERROR $::sdsoc::msg::idSCHlsNoAuxXml "Problem detected in Vivado HLS run - unable find ${accel} file $hls_auxiliary_xml. See [file join ${hls_dir} ${accel} solution solution.log] or [file join ${hls_dir} ${hls_log}] for possible causes."
    sdscc_on_exit 1
  }
  set command "[::sdsoc::utils::getCommandPath sed] -i -e {s/xilinx\\.com\\/xidane/xilinx\\.com\\/xd/g} ${hls_auxiliary_xml}"
  exec_command $command

  # Return the component XML file for the Vivado HLS IP
  return $component_xml
}

# create HLS accelerator IP database files
proc build_hls_accelerator_ip_database {accel acc_clk hls_aux_xml ip_requires_adapter} {
  global llvm_dir 

  set acc_aux_xml "[file join ${llvm_dir} ${accel}_auxiliary.xml]"
  copy_file_force ${hls_aux_xml} ${acc_aux_xml}
  cd_command ${llvm_dir}

  # TO DO: refactor XSLT processing into compile step in ${xsd_dir} rather than ${llvm_dir}
  # rename attributes for xdrepo APIs
  set hlsmap1_xml [file join ${llvm_dir} ${accel}.hlsmap1.xml]
  if { [apc_get_global APCC_IS_HLS_OPENCL] } {
    set fcnmap_type "hls_opencl"
  } else {
    set fcnmap_type "hls"
  }

  set template_arg ""
  if {[::sdsoc::template::isTemplateFunction ${accel}]} {
    set templateInstName [::sdsoc::template::getMapMangled2Original ${accel}]
    if {[apc_is_windows]} {
      set templateInstName [::sdsoc::template::getWindowsEscapedName ${templateInstName}]
    } else {
      set templateInstName \"${templateInstName}\"
    }
    set template_arg "--stringparam P_TEMPLATE_INSTANTIATION ${templateInstName}"
  }

  # 2015.2 SDSoC allows more than one top-level accelerator
  # function in a source file, so need to handle that here.
  set command "[::sdsoc::utils::getCommandPath xsltproc] \
    --output ${hlsmap1_xml} \
    --stringparam P_CLKID ${acc_clk} \
    --stringparam P_HLS_TYPE ${fcnmap_type} ${template_arg} \
    [file join [apc_get_global APCC_PATH_XILINX_XD] scripts xsd xdHlsmapRenameAttr.xsl] \
    ${acc_aux_xml}"
  exec_command $command

  set hlsmap_xml [file join ${llvm_dir} ${accel}.hlsmap.xml]
  if {$ip_requires_adapter} {
    set command "[::sdsoc::utils::getCommandPath xsltproc] \
      --output ${hlsmap_xml} \
      [file join [apc_get_global APCC_PATH_XILINX_XD] scripts xsd xdHlsmapAdapter.xsl] \
      ${hlsmap1_xml}"
    exec_command $command
  } else {
    set command "[::sdsoc::utils::getCommandPath xsltproc] \
      --output ${hlsmap_xml} \
      [file join [apc_get_global APCC_PATH_XILINX_XD] scripts xsd xdHlsmapDataPack.xsl] \
      ${hlsmap1_xml}"
    exec_command $command
  }

  # HLS axi cleanup, e.g., filter out dummy args
  set fcnmap_xml [file join ${llvm_dir} ${accel}.fcnmap.xml]

  # Workaround until HLS front end compiles opencl kernels with native aximm
  set hls_opencl_flag ""
  if { [apc_get_global APCC_IS_HLS_OPENCL] } {
    set hls_opencl_flag "--stringparam P_XD_OPENCL t"
  }
  set command "[::sdsoc::utils::getCommandPath xsltproc] \
    ${hls_opencl_flag} \
    --output ${fcnmap_xml} \
    [file join [apc_get_global APCC_PATH_XILINX_XD] scripts xsd xdHlsmapAxi4.xsl] \
    ${hlsmap_xml}"
  exec_command $command
  set hls_adapter_comp_xml [file join ${llvm_dir} ${accel}_if.xml] 
  if {$ip_requires_adapter} {
      set tmp_exp_adapter "--stringparam P_ADAPTER_COMPREF adapter_v3_0"
      set command "[::sdsoc::utils::getCommandPath xsltproc] \
        --output ${hls_adapter_comp_xml} \
        ${tmp_exp_adapter} \
        [file join [apc_get_global APCC_PATH_XILINX_XD] scripts xsd xdHlsAdapterComp.xsl] \
        ${fcnmap_xml}"
    exec_command $command
    # include this file in the object to handle library + non-library flows
    # file copy -force ${hls_adapter_comp_xml} ${xsd_dir} 
  }
}

# create accelerator metadata XML file, which will be embedded into
# an object file as a section
proc create_accelerator_metadata_xml {accel acc_clk source_file incl_flags_abs other_flags ip_requires_adapter ip_is_rtl ip_has_repo ip_is_pfunc vlnv asm_file} {
  global swstubs_dir xsd_platform compiler

  set xml_file [file join ${swstubs_dir} ${accel}.xml]
  set fp [open ${xml_file} w]
  puts $fp "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  puts $fp "<xd:data xmlns:xd=\"http://www.xilinx.com/xd\">"
  puts -nonewline $fp "  <xd:accel name=\"${accel}\""
  puts -nonewline $fp " platform=\"${xsd_platform}\""
  # Stub generation flow : save command line options for compiling
  #                        generated stub created with rewrite
  #
  # If the file is moved, non-absolute paths need to be normalized
  # to be absolute paths and the path to the file added:
  #   1. -I ../<path>
  #   2. -I <single_directory_name_without_dot_h>
  #   3. -I <path_to_directory_containing_original_source_file>
  #
  # Note that -I with and without spaces needs to be handled, but
  # during option parsing all of the -I options have been normalized
  # so there is always one space.
  puts -nonewline $fp " compiler=\"$compiler\""
  puts -nonewline $fp " srcfile=\"[file tail $source_file]\""
  set srcpath [file dirname $source_file]
  puts -nonewline $fp " srcpath=\"$srcpath\""
  puts -nonewline $fp " flags=\"-I$srcpath $incl_flags_abs $other_flags\""
  puts -nonewline $fp " clk_id=\"${acc_clk}\""
  puts -nonewline $fp " ip_requires_adapter=\"${ip_requires_adapter}\""
  puts -nonewline $fp " ip_is_rtl=\"${ip_is_rtl}\""
  puts -nonewline $fp " ip_has_repo=\"${ip_has_repo}\""
  puts -nonewline $fp " ip_is_pfunc=\"${ip_is_pfunc}\""
  puts -nonewline $fp " vlnv=\"${vlnv}\""
  puts -nonewline $fp " is_opencl=\"[apc_get_global APCC_IS_HLS_OPENCL]\""
  if {[file exists $asm_file]} {
    puts -nonewline $fp " asmfile=\"[file tail $asm_file]\""
  } else {
    puts -nonewline $fp " asmfile=\"NA\""
  }
  set originalFunctionName [::sdsoc::template::getMapMangled2Original $accel]
  set escName [::sdsoc::template::originalName2EscapedXml $originalFunctionName]
  puts -nonewline $fp " esc_original_name=\"${escName}\""
  if {[::sdsoc::template::isTemplateFunction $originalFunctionName]} {
    set templateSource [::sdsoc::template::getMapMangled2TemplateSource $accel]
    puts -nonewline $fp " template_source_file=\"${templateSource}\""
  } else {
    puts -nonewline $fp " template_source_file=\"NA\""
  }
  puts $fp "/>"
  puts $fp "</xd:data>"
  close $fp
  return $xml_file
}

# create a preprocessed version of a source file
proc create_preprocessed_source_file {source_file incl_flags other_flags other_mf_mt_flags} {
  global toolchain compiler pp_dir

  if {[string equal $compiler "gcc"]} {
    set pp_ext "i"
  } else {
    set pp_ext "ii"
  }
  set pp_file [file join ${pp_dir} [file rootname [file tail $source_file]].${pp_ext}]
  set pp_file_temp ${pp_file}x
  set command "[get_cc] -E $incl_flags $other_flags $other_mf_mt_flags [get_implicit_flags_for_gcc] $source_file -o ${pp_file_temp}"
  exec_command $command

  # strip out lines that begin with the pound character - annotations
  # are removed, but pragmas remain
  copy_file_remove_pp_lines ${pp_file_temp} ${pp_file}
  delete_file ${pp_file_temp}

  # return the modified file
  return $pp_file
}

# Zip vivado core
proc create_vivado_core_zip {vlnv component_xml} {
  global hw_dir run_dir

  regsub -all {(\.|\:)} $vlnv  "_" vlnv_under
  set core_path [file dirname $component_xml]
  set core_zip [file join ${hw_dir} ${vlnv_under}.zip]
  cd_command $core_path
  set command "[::sdsoc::utils::getCommandPath zip] -r $core_zip ."
  exec_command $command
  cd_command $run_dir
  return $core_zip
}

# Zip vivado IP repo if -ip-repo was specified
proc create_vivado_repo_ip_names {vlnv component_xml} {

  set ip_repo_names ""
  if {! [::sdsoc::opt::getOptAddIpRepo]} {
    return $ip_repo_names
  }

  # list all folders except the top-level IP
  set core_path [file dirname $component_xml]
  set core_dir [file tail $core_path]
  set repo_parent [file dirname $core_path]
  set ip_repo_names ""
  foreach dirName [glob -nocomplain -type d -directory $repo_parent *] {
    set ipDirName [file tail $dirName]
    if {[string equal $core_dir $ipDirName]} {
      # skip the original IP directory
      continue
    }
    append ip_repo_names " $ipDirName"
  }

  # return the IP folder names for the repo
  return $ip_repo_names
}

# Zip vivado IP repo if -ip-repo was specified
proc create_vivado_repo_zip {vlnv component_xml ip_repo_names} {
  global hw_dir run_dir

  set repo_zip ""
  if {[string length $ip_repo_names] < 1} {
    return $repo_zip
  }

  # get repo directory containing dependent IP
  set core_path [file dirname $component_xml]
  set repo_parent [file dirname $core_path]

  # create IP repo zip
  regsub -all {(\.|\:)} $vlnv  "_" vlnv_under
  set repo_name ${vlnv_under}_repo
  set repo_zip [file join ${hw_dir} ${repo_name}.zip]
  cd_command $repo_parent
  set command "[::sdsoc::utils::getCommandPath zip] -r $repo_zip $ip_repo_names"
  exec_command $command
  cd_command $run_dir
  return $repo_zip
}

# copy a data file into an object file as a section
proc object_add_section_data {obj_file section_name data_file} {
  # hack
  MSG_PRINT [stacktrace]
  # end hack
  global toolchain

    set command "[get_objcopy] --add-section ${section_name}=${data_file} $obj_file"
  exec_command $command
}

proc accel_section_name {base_name id_number} {
  set section_name ${base_name}
  if {$id_number > 0} {
    set section_name ${base_name}${id_number}
  }
  return $section_name
}

# create metadata file for the object containing a list of accelerators
# and other information, including file format version
proc create_object_metadata {metadata_file accels} {
  set fp [open ${metadata_file} w]
  puts $fp "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  puts $fp "<xd:data xd:num_accels=\"[llength $accels]\" xd:format=\"1\" xmlns:xd=\"http://www.xilinx.com/xd\">"
  set accel_id 0
  foreach accel $accels {
    puts $fp "  <xd:accel name=\"${accel}\" id=\"${accel_id}\"/>"
    incr accel_id
  }
  puts $fp "</xd:data>"
  close $fp
}

# Compile for the Vivado/IPI flow only
proc sdscc_compile {} {
  global toolchain compiler run_hls
  global accelmap_clkid accelmap_hls_tcl_directive_file
  global run_dir sdscc_dir hls_dir hw_dir llvm_dir swstubs_dir pp_dir est_dir
  global accels asms stubs infiles outfile outfile_str other_switches other_mf_mt_switches
  global xsd_platform platform_hw_xml xsd_dir
  global vlnv platform_func fcnmap_file params_file
  global dev_run_llvm dev_run_hls dev_run_pragmagen
  global perf_root perf_funcs perf_prepass perf_est
  global ininclpaths use_hls_adapter

  # Initialize values
  set ip_is_pfunc $platform_func
  set ip_is_rtl 0
  set ip_has_repo 0
  set is_opencl 0
  set hls_auxiliary_xml ""
  set asm_file "NA"
  set asm_file_pp "NA"

  # Create include switches
  set incl_switches ""
  set incl_switches_abs ""
  foreach inclpath $ininclpaths {
    lappend incl_switches -I$inclpath
    lappend incl_switches_abs -I[file normalize [file join $run_dir $inclpath]]
  }

  # Do upfront compile flow checks
  run_compile_flow_checks $infiles $incl_switches $other_mf_mt_switches $other_switches

  # Create flow directories
  file mkdir $pp_dir

  # create log file directory for Sprite, if specified
  initialize_sprite_log_directory

  # Initialize performance estimation flow
  if {$perf_est} {
    set accdata_dir [file join $est_dir [apc_get_global APCC_DIR_SDS_EST_ACCDATA]]
    set accdata_obj [file join $accdata_dir [file tail $outfile]]
    # delete file from old run
    if {[file exists $accdata_obj]} {
      delete_file $accdata_obj
    }
  }

  # instrument source for performance estimation
  if {$perf_prepass} {
    run_perf_instrumenter_on_source $infiles $incl_switches $other_switches
  }

  set is_opencl [ string match *.cl $infiles ]
  apc_set_global APCC_IS_HLS_OPENCL $is_opencl

  # create clang intermediate representation file (_sds/.llvm/<source>.s)
  if {! [apc_get_global APCC_COMPILER_NOOP_FLOW]} {
    set asm_file [create_clang_intermediate_representation $infiles "" $incl_switches $other_switches]
  }

  # If an accelerator is not associated with this source file,
  # compile the source as a software only input.
  MSG_PRINT "run_hls is $run_hls."
  if {! $run_hls} {
    compile_source_without_accelerator $infiles $incl_switches $incl_switches_abs $other_mf_mt_switches $other_switches
    return
  }

  # Process the source as an accelerator of some type. It may be
  # source that needs to be run through Vivado HLS, an RTL IP, etc.

  if {!$dev_run_hls} {
    MSG_PRINT "Not running Vivado HLS due to the -mdev-no-hls switch"
    # For now just return
    return
  }

  # Run SDSoC lint on each accelerator, if any, associated with a source file 
  # hacking 
  # set gcc_incl_path "D:/Xilinx/SDK/2018.1/gnu/aarch32/nt/gcc-arm-linux-gnueabi/lib/gcc/arm-linux-gnueabihf/7.2.1/include"
  # lappend incl_switches -I$gcc_incl_path
  # end hacking
  MSG_PRINT "incl_switches is $incl_switches"
  run_sdsoc_lint_on_accelerators $infiles $incl_switches $other_switches
  MSG_PRINT "I retured from run_sdsoc_lint_on_accelerators"

  # Create an accelerator stub file (initially empty), which is used
  # to build an object and store sections containing metadata.
  if {[string first "\.cl" [file tail $infiles]] } {
    set swstub_source_file [file join ${swstubs_dir} [file rootname [file tail $infiles]].cpp]
  } else {
    set swstub_source_file [file join ${swstubs_dir} [file tail $infiles]]
  }
  set swstub_object_file [file rootname ${swstub_source_file}].o
  create_empty_file ${swstub_source_file}

  # Compile the accelerator stub file into object file
  set command "[get_cc] -c ${swstub_source_file} -o ${swstub_object_file}"
  exec_command $command

  # Object metadata sections added if there are no accelerators
  #   .xdsdata    source info and compilation flags
  # Object metadata sections added if source is associated with accelerators
  # - all accelerators (one per source file)
  #   .xdinfo     source level metadata and tool information
  #   .xdasm      .s file created by clang_wrapper if there are no errors
  # - all accelerators (one per accelerator)
  #   .xddata     accelerator info and compilation flags
  #   .xdfcnmap   accelerator function map
  # - accelerators that do not contain HLS OpenCL source (one per source file)
  #   .xdpp       source file run through gcc pre-processor
  # - accelerators that are not RTL IP (one per accelerator)
  #   .xdhlscore  HLS IP core zip
  #   .xdif       HLS IP interface information (if adapter is required)
  # - accelerators that are RTL IP (one per accelerator)
  #   .xdparams   RTL IP parameter info
  #   .xdcore     RTL IP core zip

  # Add object level metadata file listing the accelerators associated with it
  set xml_file ${swstub_object_file}.xml
  create_object_metadata $xml_file $accels
  object_add_section_data $swstub_object_file ".xdinfo" ${xml_file}

  # Process each accelerator associated with this source file.
  set accel_id 0
  foreach accel $accels {

    # resolve the clock ID
    set acc_clk $accelmap_clkid($accel)
    if {[string length $accelmap_clkid($accel)] < 1} {
      set acc_clk [get_default_clock_id]
    }

    # hack, hls still need clang's header. 
    # We add this tmp clang path here since we will move clang header later after hls for every accel.
    MSG_PRINT [stacktrace]
    set tmp_clang_inclpath "-ID:/Xilinx/SDx/2018.1/llvm-clang/win64/llvm/lib/clang/3.9.0/include"
    lappend incl_switches $tmp_clang_inclpath
    lappend incl_switches_abs $tmp_clang_inclpath
    MSG_PRINT "tmp_clang_inclpath is $tmp_clang_inclpath"
    # end hack
    
    # set flag to run pragma_gen if a TCL directives file was not specified
    set dev_run_pragmagen 1
#   The -hls-tcl option is additive to pragmagen directives
#   if {[string length $accelmap_hls_tcl_directive_file($accel)] > 0} {
#     set dev_run_pragmagen 0
#   }
    # Create Vivado HLS IP or initial setup for RTL IP
    set repo_ip_names ""
    if {[string length $vlnv] == 0} {
      set component_xml [create_vivado_hls_ip $accel $acc_clk $infiles $incl_switches $incl_switches_abs $other_switches $use_hls_adapter]
      set hls_auxiliary_xml [file join ${hls_dir} ${accel} solution impl ip auxiliary.xml]
      # Check if accelerator adapter is needed
      set ip_requires_adapter [check_ip_requires_adapter $hls_auxiliary_xml]
    } else {
	MSG_PRINT "Using IP core $vlnv for function $accel"
	MSG_PRINT "Fcnmap file $fcnmap_file"
	MSG_PRINT "Parameters file $params_file"
	set component_xml [find_component_xml $vlnv]
	if {[string length $component_xml] == 0} {
	    MSG_ERROR $::sdsoc::msg::idSCNoIPMatchVlnv "Could not find IP core that matches VLNV $vlnv"
	    sdscc_on_exit 1
	}
	MSG_PRINT "IP core is $component_xml"
	set ip_is_rtl 1
	set ip_requires_adapter 0
        set repo_ip_names [create_vivado_repo_ip_names $vlnv $component_xml]
        if {[string length ${repo_ip_names}] > 0} {
          set ip_has_repo 1
        }
    }
    #puts "\$ip_requires_adapter = $ip_requires_adapter"
    cd_command $run_dir

    # Build XML IP database for XidanePass, cf2xd, and cf_xsd
    if {!$ip_is_rtl} {
      build_hls_accelerator_ip_database $accel $acc_clk $hls_auxiliary_xml $ip_requires_adapter
      set ip_name ${accel}
    } else {
      # This else corresponds to 'if {!$ip_is_rtl}'
      set vlnv_list [split $vlnv ":"]
      set ip_name [lindex $vlnv_list 2]

      # RTL IP use .s based on pre-processed source - if you use the
      # .s based on the original source, the line numbers are off and
      # caller rewrite will fail. The source usually contains only
      # the wrappers for the RTL IP, but if it contains a caller to
      # provide a fixed context, the IR needs to be based on the
      # pre-processed source with annotations removed (except pragmas).
      set compilerType [set_compiler_type $infiles]
      set pp_file [create_preprocessed_source_file $infiles $incl_switches $other_switches $other_mf_mt_switches]
      set asm_file_pp [create_clang_intermediate_representation $pp_file $compilerType $incl_switches $other_switches]
      set asm_file ${asm_file_pp}
      
      # Write given fcnmap and params files to the llvm directory to be packaged
      copy_file_force ${fcnmap_file} [file join ${llvm_dir} ${ip_name}.fcnmap.xml]
      copy_file_force ${params_file} [file join ${llvm_dir} ${ip_name}.params.xml]
    }
    cd_command $run_dir

    # hack, remove clang headers from gcc
    MSG_PRINT [stacktrace]

    MSG_PRINT "The original incl_switches is $incl_switches"
    MSG_PRINT "incl_switches have [llength $incl_switches] element(s)"
    set incl_switches [lsearch -all -inline -not $incl_switches "*clang*"]
    # MSG_PRINT "search result idx is $idx"
    # set incl_switches [lreplace $incl_switches $idx $idx]
    MSG_PRINT "The final incl_switches is $incl_switches"

    MSG_PRINT "The original incl_switches_abs is $incl_switches_abs"
    MSG_PRINT "incl_switches_abs have [llength $incl_switches_abs] element(s)"
    set incl_switches_abs [lsearch -all -inline -not $incl_switches_abs "*clang*"]
    # MSG_PRINT "search result idx is $idx"
    # set incl_switches_abs [lreplace $incl_switches_abs $idx $idx]
    MSG_PRINT "The final incl_switches_abs is $incl_switches_abs"
    # end hack

    # Create accelerator metadata XML file, which will be
    # embedded in an object file section (xddata)
    set xml_file [create_accelerator_metadata_xml $accel $acc_clk $infiles $incl_switches_abs $other_switches $ip_requires_adapter $ip_is_rtl $ip_has_repo $ip_is_pfunc $vlnv $asm_file]

    # Package xddata into object file
    set section_name [accel_section_name ".xddata" $accel_id]
    object_add_section_data $swstub_object_file $section_name ${xml_file}

    # Package xdasm into object file for library objects
    if {$accel_id < 1 && [file exists $asm_file]} {
      set section_name ".xdasm"
      object_add_section_data $swstub_object_file $section_name ${asm_file}
    }

    # Preprocess and package source file
    if {$accel_id < 1 && ! [apc_get_global APCC_IS_HLS_OPENCL] } {
      set pp_file [create_preprocessed_source_file $infiles $incl_switches $other_switches $other_mf_mt_switches]
      set section_name ".xdpp"
      object_add_section_data $swstub_object_file $section_name ${pp_file}
    }

    # Package fcnmap.xml file
    set fcnmap_file [file join ${llvm_dir} ${ip_name}.fcnmap.xml]
    set section_name [accel_section_name ".xdfcnmap" $accel_id]
    object_add_section_data $swstub_object_file $section_name ${fcnmap_file}
    
    if {$ip_is_rtl} {  
      # Package params.xml file
      set params_file [file join ${llvm_dir} ${ip_name}.params.xml]
      set section_name [accel_section_name ".xdparams" $accel_id]
      object_add_section_data $swstub_object_file $section_name ${params_file}

      # Zip and package Vivado core
      set core_zip [create_vivado_core_zip $vlnv $component_xml]
      set section_name [accel_section_name ".xdcore" $accel_id]
      object_add_section_data $swstub_object_file $section_name ${core_zip}

      # Zip and package IP repo cores (optional)
      if {[string length $repo_ip_names] > 0} {
        set repo_zip [create_vivado_repo_zip $vlnv $component_xml ${repo_ip_names}]
        set section_name [accel_section_name ".xdrepo" $accel_id]
        object_add_section_data $swstub_object_file $section_name ${repo_zip}
      }
    } else {
      # Package HLS core
      set core_zip [file join ${hls_dir} ${accel} solution impl ip xilinx_com_hls_${accel}_1_0.zip]
      set section_name [accel_section_name ".xdhlscore" $accel_id]
      object_add_section_data $swstub_object_file $section_name ${core_zip}
    }

    # package interface metadata file
    if {$ip_requires_adapter} {
      set xdif_file [file join ${llvm_dir} ${accel}_if.xml] 
      set section_name [accel_section_name ".xdif" $accel_id]
      object_add_section_data $swstub_object_file $section_name ${xdif_file}
    }
    # next accelerator ID
    incr accel_id
  }
  # end accelerator loop

  # Copy to $outfile
  if {!$perf_est} {
    copy_file_force $swstub_object_file $outfile
  } else {
    file mkdir $accdata_dir
    copy_file_force $swstub_object_file [file join $accdata_dir [file tail $outfile]]
  }
}

proc stitch_perf_file_fragments {} {
    global est_dir
    global perf_root perf_funcs

    ###################################by Zhenman###############################################
    # replace the original name in perf_funcs with new wrapper name
    replaceTemplatePerfFuncsAtLink
    ###################################by Zhenman###############################################
    
    set functions [split $perf_funcs ","]
    lappend functions $perf_root
    
    set sw_perf_est_file [file join ${est_dir} sw_perf_est.c]
    set fp [open ${sw_perf_est_file} w]
    puts $fp "#include \"sds_perf_instrumentation.h\"\n"

    foreach func $functions {
        set decls_file [file join ${est_dir} ${func}_decls.fragment]
        
        if {! [file exists ${decls_file}]} {
            MSG_ERROR $::sdsoc::msg::idSCPerfStitch "Exiting [apc_get_global APCC_COMMAND_NAME] : Expected file ${decls_file} not found"
            sdscc_on_exit 1
        }

        set fp_d [open ${decls_file} r]
        puts $fp [read $fp_d]
        close $fp_d
    }

    puts $fp ""
    puts $fp "void add_sw_estimates()"
    puts $fp "{"
    
    foreach func $functions {
        set calls_file [file join ${est_dir} ${func}_calls.fragment]
        
        if {! [file exists ${calls_file}]} {
            MSG_ERROR $::sdsoc::msg::idSCPerfCallsFile "Exiting [apc_get_global APCC_COMMAND_NAME] : Expected file ${calls_file} not found"
            sdscc_on_exit 1
        }
        
        set fp_c [open ${calls_file} r]
        puts $fp [read $fp_c]
        close $fp_c
    }
    
    puts $fp "}"
    close $fp
}

# return 1 if the .mss file appears to specify xilffs
proc mss_contains_xilffs {mss_file} {
  # If the file doesn't exist, didn't find xilffs
  if {! [file exists ${mss_file}]} {
    return 0
  }

  # Look for a xilffs line in the .mss file, and assume the line
  # could look like this : PARAMETER LIBRARY_NAME = xilffs
  set fp [open ${mss_file} r]
  while {[gets $fp mssBuffer] >= 0} {
    # see if the line contains "xilffs"
    set mssLine [string tolower ${mssBuffer}]
    if {[string first "xilffs" ${mssLine}] < 0} {
      continue
    } 
    # remove the spaces and what's left should look like this
    #   "parameterlibrary_name=xilffs"
    regsub -all {\s} ${mssLine} {} paramString
    if {[string first "parameterlibrary_name=xilffs" ${paramString}] == 0} {
      return 1
    }
  }
  close $fp

  # didn't find xilffs
  return 0
}

proc update_mss_with_xilffs {mss_file} {
    if {[mss_contains_xilffs ${mss_file}]} {
      return
    }
    set fp [open ${mss_file} a]
    puts $fp ""
    puts $fp "BEGIN LIBRARY"
    puts $fp " PARAMETER LIBRARY_NAME = xilffs"
    puts $fp " PARAMETER LIBRARY_VER = 3.7"
    puts $fp " PARAMETER PROC_INSTANCE = [apc_get_global APCC_PROC_INSTANCE]"
    puts $fp "END"
    puts $fp ""
    close $fp
}

###############################################################################
# Exit code handlers passed to exec_command (optional)
###############################################################################

# Return code handler for XidanePass optionally called by exec_command
# Return 0 if the exit code should be treated as 0 (ok to continue).
# This is not a general solution, but the handler is called if the
# exit code was not 0.
proc exit_handler_xidanepass {} {
  global llvm_dir

  # process the XidanePass exit code found in the file 
  # _sds/.llvm/XidanePass_ExitCode
  # If the exit code file is not found, assume unexpected exit.
  set ec -2
  set xidanepass_ec_file [file join ${llvm_dir} XidanePass_ExitCode]
  if {[file exists $xidanepass_ec_file]} {
    set fp [open ${xidanepass_ec_file} r]
    if {[gets $fp input_line] > 0} {
      scan $input_line "%d" ec
    }
    close $fp
  }

  # XidanePass was successful 
  if { $ec == 0 || $ec == 2 || $ec == 3 } {
    puts "Data motion generation completed successfully with exit code $ec"
    log_puts "Data motion generation completed successfully with exit code $ec"
    # No accelerators found
    # 2 is the current value
    # 3 is the old value (temporary until XidanePass in sync)
    if { $ec == 2 || $ec == 3 } {
      log_puts "- No calls to any accelerators found"
      puts "- No calls to any accelerators found"
    }
    return 0
  }

  # XidanePass was not successful 
  puts "Data motion generation exited with return code $ec"
  log_puts "XidanePass exited with return code $ec"
  switch -- $ec {
    -3 { set xpmsg "- performance estimation not supported"}
    -2 { set xpmsg "- exited unexpectedly"      }
    -1 { set xpmsg "- exited unexpectedly"      }
     1 { set xpmsg "- errors detected"          }
    default {
      set xpmsg "- error detected, unrecognized return code $ec"
    }
  }
  puts $xpmsg
  log_puts $xpmsg
  return 1
}

###############################################################################
# Prebuilt hardware for software only flows
###############################################################################

# Test if pre-built hardware is available and should be used
# - User specified a platform
# - Pre-built hardware and related files are available
# - User did not specify an option to force a hardware build
# - User did not specify an option for emulation
proc prebuilt_hardware_is_available {} {
  global rebuild_empty_hardware
  global run_emulation_export

  # if the option -rebuild-hardware is specified, don't use
  # prebuilt hardware
  if { ${rebuild_empty_hardware} } {
    return 0
  }

  # if the option -emulation is specified, don't use
  # prebuilt hardware
  if { ${run_emulation_export} } {
    return 0
  }

  # if the platform includes prebuilt hardware, use it
  if { [apc_get_global APCC_PREBUILT_AVAILABLE] } {
    return 1
  }

  # need to build hardware
  return 0
}

# Populate the user data with pre-generated hardware and related
# software files
proc prebuilt_hardware_initialize {pf_name} {
  global run_dir sdscc_dir ipi_dir cf_dir llvm_dir bitstream

  # get the path to prebuilt bitstream and data files
  set pb_path [apc_get_global APCC_PREBUILT_DATA_FOLDER]

  # no metadata for prebuilt hardware
  if {[string length $pb_path] < 1} {
    return
  }

  # copy prebuilt bitstream and data files from the platform

  # IPI repo
  set dest_dir [file join ${ipi_dir} repo]
  if { ! [file exists ${dest_dir}] } {
    file mkdir ${dest_dir}
  }

  # bitstream
  # - save to _sds/ipi/<platform>.runs/impl_1 (later copied elsewhere)
  # - bitstream.bit
  set dest_dir [file join ${ipi_dir} ${pf_name}.runs impl_1]
  if { ! [file exists ${dest_dir}] } {
    file mkdir ${dest_dir}
  }
  foreach bit_file [glob -nocomplain -type f -directory $pb_path *.bit] {
    set pf_path [file normalize $bit_file]
    copy_file_force_writeable ${pf_path} [file join ${dest_dir} [file tail ${pf_path}]]
    copy_file_force_writeable ${pf_path} [file join ${run_dir} $bitstream]
  }

  # device and port registration
  # - save to _sds/cf_work (later copied elsewhere)
  # - portinfo.c, portinfo.h
  set dest_dir ${cf_dir}
  if { ! [file exists ${dest_dir}] } {
    file mkdir ${dest_dir}
  }
  set sds_file_list { portinfo.c portinfo.h }
  foreach sds_file $sds_file_list {
    set pf_file [file join $pb_path $sds_file]
    if {[file exists $pf_file]} {
      copy_file_force_writeable ${pf_file} [file join ${dest_dir} [file tail ${pf_file}]]
    }
  }

  # partitions.xml and apsys_0.xml file
  set pf_file [file join $pb_path partitions.xml]
  if {[file exists $pf_file]} {
    copy_file_force_writeable ${pf_file} [file join ${llvm_dir} partitions.xml]
  }
  set pf_file [file join $pb_path apsys_0.xml]
  if {[file exists $pf_file]} {
    copy_file_force_writeable ${pf_file} [file join ${llvm_dir} apsys_0.xml]
  }

  # common stub files
  # - cf_stub.c and cf_stub.h are actually empty if no accelerators
  create_empty_file [file join ${llvm_dir} cf_stub.c]
  create_empty_file [file join ${llvm_dir} cf_stub.h]

  # SDK export files
  set dest_dir [file join ${sdscc_dir} [apc_get_global APCC_DIR_SDS_PART]0 [apc_get_global APCC_DIR_SDS_PART_IPI] ${pf_name}.sdk]
  if { ! [file exists ${dest_dir}] } {
    file mkdir ${dest_dir}
  }
  foreach hdf_file [glob -nocomplain -type f -directory $pb_path *.hdf] {
    set pf_file [file normalize $hdf_file]
    copy_file_force_writeable ${pf_file} [file join ${dest_dir} [file tail ${pf_file}]]
  }
}

proc prebuilt_hardware_hdf { } {
  # empty string means the file wasn't found
  set pf_hdf_file ""

  # get the path to prebuilt .hdf file
  set pb_path [apc_get_global APCC_PREBUILT_DATA_FOLDER]
  if {[string length $pb_path] < 1} {
    return $pf_hdf_file
  }

  foreach pb_file [glob -nocomplain -type f -directory $pb_path *.hdf] {
    set pf_hdf_file [file normalize $pb_file]
  }

  # return the prebuilt platform .hdf file
  return $pf_hdf_file
}

proc stage_prebuilt_hardware_hdf { } {
  global sdscc_dir

  # empty string means the file wasn't found
  set hdf_file ""

  # check if there is a prebuilt .hdf file
  set pf_hdf_file [prebuilt_hardware_hdf]
  if {[string length ${pf_hdf_file}] > 1} {
    # save prebuilt .hdf where we normally tell VPL to copy export files
    set dest_dir [file join ${sdscc_dir} [apc_get_global APCC_DIR_SDS_PART][apc_get_global APCC_DEFAULT_ID] vpl]
    if { ! [file exists ${dest_dir}] } {
      file mkdir ${dest_dir}
    }
    set hdf_file [file join ${dest_dir} "system.hdf"]
    copy_file_force_writeable ${pf_hdf_file} ${hdf_file}
  }

  # return prebuilt platform .hdf file staged to where vpl normally writes it
  return $hdf_file
}

###############################################################################
# CF-based Linker Flow
###############################################################################

# check accelerator clock override option values (-ac accelerator:clockId)
# This is called after the accelerators are known, since we want to check
# if the specified functions is known or not.
proc check_ac_override_options {acList arr_ip_is_rtl} {
  upvar 1 $arr_ip_is_rtl    acRTLFlags

  set acDict [::sdsoc::opt::getOptAclkIdDict]
  if {[dict size $acDict] > 0} {
    dict for {acName acClockId} $acDict {
      # check if the clock Id is valid
      if {![clock_exists $acClockId]} {
        MSG_ERROR $::sdsoc::msg::idSCOptAclkIdNotFound "Invalid -ac ${acName}:${acClockId} option specified, clock Id ${acClockId} not found as a platform clock."
        sdscc_on_exit 1
      }
      # check if the accelerator is valid
      if {[llength $acList] > 0 && [lsearch -exact $acList ${acName}] < 0} {
        MSG_ERROR $::sdsoc::msg::idSCOptAclkNameNotFound "Invalid -ac ${acName}:${acClockId} option specified, accelerator ${acName} not found."
        sdscc_on_exit 1
      }
      # check if the accelerator is RTL IP
      if {! $acRTLFlags($acName)} {
        MSG_ERROR $::sdsoc::msg::idSCOptAclkNameNotRTL "Invalid -ac ${acName}:${acClockId} option specified, accelerator ${acName} not a C-callable RTL IP."
        sdscc_on_exit 1
      }
      # print a warning that the user is changing the clock
      MSG_WARNING $::sdsoc::msg::idSCOptAclkChanging "Changing clock ID from default value using the -ac ${acName}:${acClockId} option."
    }
  }
}

proc change_fcnmap_clock {fcnmapFile clockId} {
  global xsd_dir

  # create a temporary fcnmap.xml file with updated clock
  # from the original file
  set tempFcnmapFile [file join ${xsd_dir} temp.fcnmap.xml]
  set command "[::sdsoc::utils::getCommandPath xsltproc] \
    --output ${tempFcnmapFile} \
    --stringparam P_CLKID ${clockId} \
    [file join [apc_get_global APCC_PATH_XILINX_XD] scripts xsd xdChangeFcnmapClock.xsl] \
    ${fcnmapFile}"
  exec_command $command

  # delete the original fcnmap.xml file - assume this is OK
  set status [catch {file delete -force ${fcnmapFile}} result]
  if {$status != 0} {
    MSG_ERROR $::sdsoc::msg::idSCAclkDeleteFcnmap "Unable to delete original function map file ${fcnmapFile} after creating new version with clock update : $result."
    sdscc_on_exit 1
  }

  # rename the temporary fcnmap.xml to the original
  set status [catch {file rename -force ${tempFcnmapFile} ${fcnmapFile}} result]
  if {$status != 0} {
    MSG_ERROR $::sdsoc::msg::idSCAclkRenameFcnmap "Unable to move new function map file with clock update ${tempFcnmapFile} to ${fcnmapFile} : $result."
    sdscc_on_exit 1
  }
}

# Extract library objects containing accelerators and add to the
# global list of objects to link into the ELF. Add library objects
# to list of objects to link into the ELF, and add library name to
# a list of accelerator objects and libraries.
proc extract_library_objects {lobjects lobjs_and_libs} {
  upvar 1 $lobjects myobjects
  upvar 1 $lobjs_and_libs myobjs_and_libs
  global inlibs inlibpaths libs_dir run_dir
  global toolchain perf_prepass

  log_puts "Libraries: $inlibs"
  log_puts "Library Paths $inlibpaths"
  set myobjs_and_libs {}
  set libs_found {}
  foreach lib $inlibs {
    set libname "lib${lib}.a"
    log_puts "Searching for static library $libname"
    foreach libpath $inlibpaths {
      if {[file exists [file join $libpath $libname]]} {
        if {[lsearch -exact $libs_found $libname] >= 0} {
          continue
        }
        lappend libs_found $libname
        set libname_abs [file join [pwd] $libpath $libname]
        log_puts "Library $libname found in $libname_abs" 

        set cur_lib_dir [file join $libs_dir $lib]
        file mkdir $cur_lib_dir
        cd_command $cur_lib_dir
        
        # Get contents of archive
        set command "[get_ar] t $libname_abs"
        set lib_objects [exec_command_and_capture $command]
        log_puts "Library objects: $lib_objects"
        
        # Extract contents of archive
        set command "[get_ar] xov $libname_abs"
        exec_command $command

        # Add to list of input files
        # NOTE: For now, if this is an accelerator, the object file is created
        # from an empty source. There is no harm if we add it to the list of
        # input object files. Eventualy, this should be the real replaced function.
        foreach object $lib_objects {
          set obj_file [file join $cur_lib_dir $object]
          set obj_accels [extract_object_accel_list ${obj_file}]
          if { [llength $obj_accels] > 0 } {
            if {$perf_prepass} {
              MSG_ERROR $::sdsoc::msg::idSCPerfNotSupported "Performance estimation is not supported when using libraries that contain platform functions or accelerators: $libname_abs"
              sdscc_on_exit 1
            }
            lappend myobjects ${obj_file}
            lappend myobjs_and_libs $libname_abs
          } 
        }
        cd_command $run_dir
      }
    }
  }
}

# Extract accelerator XML file from object, return 0 if successful.
# XML data is not checked, only existence and size > 0.
proc extract_accel_xml {o_file accel_id x_file} {
  # hack
  MSG_PRINT [stacktrace]
  # end hack
  global toolchain

  set section_name [accel_section_name ".xddata" $accel_id]
    set command "[get_objcopy] -O binary --set-section-flags ${section_name}=alloc --only-section=${section_name} ${o_file} ${x_file}"
  set objcopy_ec [exec_command_always_return $command]
  if {$objcopy_ec != 0} {
    if {[file exists $x_file]} {
      if {[file size $x_file] == "0"} {
        delete_file $x_file
      }
    }
  } elseif {[file size $x_file] == "0"} {
    delete_file $x_file
  }
  if {[file exists ${x_file}]} {
    return 0
  }
  return 1
}

# Hardware checkpoint management - save file required for checking state
proc checkpoint_hw_file {ckpfile} {
  global llvm_dir

  set ckpdir [file join ${llvm_dir} [apc_get_global APCC_DIR_SDS_LLVM_CHECKPOINT]]
  if {! [file exists ${ckpdir}] } {
    file mkdir ${ckpdir}
  }
  copy_file_force ${ckpfile} ${ckpdir}
}

# Create hardware system options file
proc write_system_hardware_file {} {
  global insert_apm insert_trace_hw
  global llvm_dir
  global run_emulation_export

  set synth_strategy [apc_get_global APCC_SYNTH_STRATEGY]
  set impl_strategy [apc_get_global APCC_IMPL_STRATEGY]
  set sys_file [file join ${llvm_dir} [apc_get_global APCC_FILE_SYSTEM_HARDWARE]]
  set fp [open ${sys_file} w]
  puts $fp "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  puts $fp "<xd:sdsoc xmlns:xd=\"http://www.xilinx.com/xd\">"
  puts $fp "  <xd:debug xd:trace=\"${insert_trace_hw}\" xd:apm=\"${insert_apm}\" xd:emu=\"${run_emulation_export}\"/>"
  puts $fp "  <xd:vivado xd:synth_strategy=\"${synth_strategy}\" xd:impl_strategy=\"${impl_strategy}\"/>"
  puts $fp "</xd:sdsoc>"
  close $fp
}

proc checkpoint_system_hardware_file {} {
  global llvm_dir

  set sys_file [file join ${llvm_dir} [apc_get_global APCC_FILE_SYSTEM_HARDWARE]]
  if {[file exists ${sys_file}]} {
    checkpoint_hw_file ${sys_file}
  }
}

proc system_hardware_is_different {} {
  global sdscc_dir
  set hw_has_changed 0

  set ckp_hw_file [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_LLVM] [apc_get_global APCC_DIR_SDS_LLVM_CHECKPOINT] [apc_get_global APCC_FILE_SYSTEM_HARDWARE]]
  set cur_hw_file [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_LLVM] [apc_get_global APCC_FILE_SYSTEM_HARDWARE]]
  if {[file exists $ckp_hw_file] && [file exists $cur_hw_file]} {
    if {[diff_files $ckp_hw_file $cur_hw_file] != 0} {
      set hw_has_changed 1
    }
  } else {
    set has_trace [xpath_get_value $cur_hw_file "/xd:sdsoc/xd:debug/@xd:trace"]
    set has_apm [xpath_get_value $cur_hw_file "/xd:sdsoc/xd:debug/@xd:apm"]
    if {$has_trace || $has_apm} {
      set hw_has_changed 1
    }
    set prev_synth_strategy [xpath_get_value $cur_hw_file "/xd:sdsoc/xd:vivado/@xd:synth_strategy"]
    set prev_impl_strategy [xpath_get_value $cur_hw_file "/xd:sdsoc/xd:vivado/@xd:impl_strategy"]
    set synth_strategy [apc_get_global APCC_SYNTH_STRATEGY]
    set impl_strategy [apc_get_global APCC_IMPL_STRATEGY]
    if { ! [string equal -nocase $prev_synth_strategy $synth_strategy] ||
         ! [string equal -nocase $prev_impl_strategy $impl_strategy] } {
      set hw_has_changed 1
    }
  }

  return $hw_has_changed
}

# Determine if bitstream build is up to date or not
#
# The bitstream is found in 
#   _sds/p<part_num>/ipi/<platform>.runs/impl_1/bitstream.bit
#
# Generate a bitstream if none currently exists or the -force
# option is given (all bitstreams).
#
# Generate a bitstream if one currently exists and one of these is true
# 1. Date of any accelerator .o or library is newer (all bitstreams)
# 2. Number of partitions has changed in partitions.xml (all bitstreams)
# 3. Partition apsys_*.xml differs (specific bitstream)
proc checkpoint_build_flags {mypartitions myacc_objs_and_libs myrebuild_empty_hardware is_unified} {
  global xsd_platform
  global sdscc_dir
  global run_emulation_export

  # list of flags indexed by partition number (0 or higher)
  set partition_build_flags [dict create]

  # Determine if hardware options (trace, apm, etc) changed since last checkpoint
  set hw_system_has_changed [system_hardware_is_different]

  # Determine if the partitions.xml file has changed since the last checkpoint
  set partitions_have_changed 0
  set ckp_partitions_file [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_LLVM] [apc_get_global APCC_DIR_SDS_LLVM_CHECKPOINT] partitions.xml]
  set cur_partitions_file [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_LLVM] partitions.xml]
  if {[file exists $ckp_partitions_file] && [file exists $cur_partitions_file]} {
    if {[diff_files $ckp_partitions_file $cur_partitions_file] != 0} {
      set partitions_have_changed 1
    }
  }

  # Determine if any objects or libraries containing accelerators are
  # newer than any of the bitstreams (save the latest timestamp)
  set acc_mtime 0
  foreach accp $myacc_objs_and_libs {
    set cur_mtime [file mtime $accp]
    if { $cur_mtime > $acc_mtime } {
        set acc_mtime $cur_mtime
    }
  }
  # Set build flags for individual partitions
  foreach {part_num part_name} $mypartitions {
    if {$is_unified} {
      set bitfile [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num} vpl system.bit]
      set emufile [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num} vpl behav xsim simulate.log]
    } else {
      set bitfile [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num} [apc_get_global APCC_DIR_SDS_PART_IPI] ${xsd_platform}.runs impl_1 bitstream.bit]
      set emufile "check_not_supported"
    }

    # Do any of the accelerators have a later date than any bitstream?
    set accs_have_changed 0
    if {$is_unified && $run_emulation_export} {
      set hwfile ${emufile}
    } else {
      set hwfile ${bitfile}
    }
    if {[file exists ${hwfile}]} {
      set hw_mtime [file mtime ${hwfile}]
      if { $acc_mtime > $hw_mtime } {
        set accs_have_changed 1
      }
    }

    # Has the system changed?
    set apsys_has_changed 0
    set ckp_apsys_file [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_LLVM] [apc_get_global APCC_DIR_SDS_LLVM_CHECKPOINT] apsys_${part_num}.xml]
    set cur_apsys_file [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_LLVM] apsys_${part_num}.xml]
    if {[file exists $ckp_apsys_file] && [file exists $cur_apsys_file]} {
      if {[diff_files $ckp_apsys_file $cur_apsys_file] != 0} {
        set apsys_has_changed 1
      }
    }

    # Does the bitstream need to be built?
    if { $myrebuild_empty_hardware
         || ! [file exists $hwfile]
         || $accs_have_changed
         || $hw_system_has_changed
         || $partitions_have_changed
         || $apsys_has_changed} {
      # set flag to force build
      dict set partition_build_flags $part_num 1
      # delete the existing Vivado folder if it exists
      if {$is_unified} {
        set sl_vpl_dir [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num} _vpl]
        if {[file exists $sl_vpl_dir]} {
          MSG_PRINT "Removing implementation files from previous run $sl_vpl_dir"
          delete_directory $sl_vpl_dir
        }
        set sl_vpl_dir [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num} vpl]
        if {[file exists $sl_vpl_dir]} {
          MSG_PRINT "Removing implementation files from previous run $sl_vpl_dir"
          delete_directory $sl_vpl_dir
        }
      } else {
      set sl_ipi_dir [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num} [apc_get_global APCC_DIR_SDS_PART_IPI]]
      if {[file exists $sl_ipi_dir]} {
        MSG_PRINT "Removing implementation files from previous run $sl_ipi_dir"
        delete_directory $sl_ipi_dir
      }
      }
    } else {
      dict set partition_build_flags $part_num 0
    }
  }
  return $partition_build_flags
}

# Create SDSoC IP repository
proc create_ip_repository {} {
  global accels acc_clk_ids xd_ip_database ipi_dir xsd_dir verbose platform_hw_xml dev_run_swgen

  # Clock ID can be specified using the sdscc/sds++ -clkid option
  # and read back from accelerator .xddata metadata.
  set ip_repo_switches ""
  foreach accel $accels {
    lappend ip_repo_switches "-clkid"
    lappend ip_repo_switches $acc_clk_ids($accel)
  }

  # Use the local repo directory only. All cores must be extracted
  # there upfront
  set ipi_repo_dir [file join $ipi_dir repo]
  set ipi_repo_subdirs [glob -nocomplain -type d ${ipi_repo_dir}/*]
  foreach ipi_repo_subdir $ipi_repo_subdirs {
    lappend ip_repo_switches -ip
    lappend ip_repo_switches $ipi_repo_subdir
  }

  # Add IP for platform functions that are included in the platform.
  # The IP needs to be processed by build_xd_ip_db, but not searched
  # by Vivado.
  set ipi_repo_dir [file join $ipi_dir .repo_pfunc]
  set ipi_repo_subdirs [glob -nocomplain -type d ${ipi_repo_dir}/*]
  foreach ipi_repo_subdir $ipi_repo_subdirs {
    lappend ip_repo_switches -ip
    lappend ip_repo_switches $ipi_repo_subdir
  }

  # Create IP database file before calling system_linker.
  # sdscc_compile built individual database elements (tables)
  # for each accelerator function that was compiled with -sds-hw.
  # These need to be collected with the infrastructure IP entries
  # (part of installed software) into a design specific XML database.
  set xd_ip_database [file join ${xsd_dir} xd_ip_db.xml]
  set build_xd_ip_db_verbose [expr {$verbose ? "-v" : ""}]

  # Check for valid platform (this can be moved out of this proc)
  if {[string length $platform_hw_xml] == 0} {
    MSG_ERROR $::sdsoc::msg::idSCSpecifyPlatform "Please specify the platform using the [apc_get_global APCC_OPT_PLATFORM] switch"
    sdscc_on_exit 1
  }

  # call build_xd_ip_db to create XML database files
  set command "[::sdsoc::utils::getCommandPath build_xd_ip_db] \
    [apc_get_global APCC_OPT_PLATFORM] ${platform_hw_xml} \
    $ip_repo_switches \
    -o $xd_ip_database \
    $build_xd_ip_db_verbose"
  if {$dev_run_swgen} {
    exec_command $command
  }
}

# Build the data motion network and system by calling XidanePass.
# This also creates caller rewrite and stub rewrite metadata files.
proc remove_dm_network_intermediate_files {} {
  global llvm_dir dev_run_llvm

  if {! $dev_run_llvm } {
    return
  }

  # If cfrewrite files exist from a previous run, delete them
  foreach cfrewrite_file [glob -nocomplain -type f -directory ${llvm_dir} *.cfrewrite] {
    delete_file $cfrewrite_file
  }
  set rewrite_xml_file [file join ${llvm_dir} caller_rewrites.xml]
  if {[file exists $rewrite_xml_file]} {
    delete_file $rewrite_xml_file
  }
}

# Given a list of .s files created by clang, confirm they all have the same
# target triples. If any value differs, a possible cause is a library with
# C-callable IP was created with a different target or tool release.
# The .s files have target triple lines of the form:
#  target triple = "armv7-none--eabi"
# They also include a source file line of the form:
#  source_filename = "/home/sdsocuser/mmultadd/main.cpp"

proc get_dm_input_module_info { asmFile } {
  set infoList [list]
  set sourceFile ""
  set targetTriple ""
  set clangVersion ""
  set fp [open ${asmFile} r]
  while {[gets $fp asmBuffer] >= 0} {
    if {[string first "ModuleID" ${asmBuffer}] >= 0} {
      # string inside of quotes
      regexp {'(.*)'} ${asmBuffer} -> sourceFile
    }
    if {[string first "target triple" ${asmBuffer}] >= 0} {
      regexp {"(.*)"} ${asmBuffer} -> targetTriple
    }
    if {[string first "clang version" ${asmBuffer}] >= 0} {
      regexp {"clang version (.*)"} ${asmBuffer} -> verString
      set verTokens [regexp -inline -all -- {\S+} $verString]
      if {[llength $verTokens] > 0} {
        set clangVersion [lindex $verTokens 0]
      }
    }
    if {[string length ${sourceFile}] > 0 &&
        [string length ${targetTriple}] > 0 &&
        [string length ${clangVersion}] > 0} {
      lappend infoList ${sourceFile}
      lappend infoList ${targetTriple}
      lappend infoList ${clangVersion}
#     puts "source ${sourceFile}, triple ${targetTriple}, clang ${clangVersion}"
      break;
    }
  }
  close $fp
  return $infoList
}

proc check_dm_input_modules { asmList } {
  set sFile ""
  set sourceFile ""
  set tripleName ""
  set clangVersion ""
  foreach asmFile $asmList {
    if {! [file exists ${asmFile}]} {
      MSG_ERROR $::sdsoc::msg::idSCDmInputModuleExists "Data motion network generation input module ${asmFile} does not exist."
      sdscc_on_exit 1
    }
    set asmModuleInfo [get_dm_input_module_info ${asmFile}]
    if {[llength $asmModuleInfo] < 3} {
      MSG_ERROR $::sdsoc::msg::idSCDmInputModuleInfo "Data motion network generation input module ${asmFile} containing the source file intermdiate representation (IR) could not be validated - unable to read one or more fields: ModuleID, target triple and clang version. Confirm that object files and C-callable IP libraries were created with the same SDx release."
      sdscc_on_exit 1
    }
    set asmSourceFile   [lindex $asmModuleInfo 0]
    set asmTripleName   [lindex $asmModuleInfo 1]
    set asmClangVersion [lindex $asmModuleInfo 2]
    # save the info for the first module, compare the rest to this one
    if {[string length ${tripleName}] < 1} {
      set sFile ${asmFile}
      set sourceFile ${asmSourceFile}
      set tripleName ${asmTripleName}
      set clangVersion ${asmClangVersion}
      continue
    }
    if {! [string equal ${tripleName} ${asmTripleName}]} {
      MSG_ERROR $::sdsoc::msg::idSCTargetTripleMismatch "Target triple mismatch detected between modules used for data motion network generation, possibly caused by differences in the SDx release, platform, system configuration or processor used. A C-callable IP module in a library must use the same target. Target triple ${tripleName} (module ${sFile}, source ${sourceFile}) differs from ${asmTripleName} (module ${asmFile}, source ${asmSourceFile})."
      sdscc_on_exit 1
    }
    if {! [string equal ${clangVersion} ${asmClangVersion}]} {
      MSG_ERROR $::sdsoc::msg::idSCClangVersionMismatch "Clang version mismatch detected between modules used for data motion network generation, possibly caused by differences in the SDx release. C-callable IP modules in libraries must use the same SDx release. Clang version ${clangVersion} (module ${sFile}, source ${sourceFile}) differs from ${asmClangVersion} (module ${asmFile}, source ${asmSourceFile})."
      sdscc_on_exit 1
    }
  }
}

proc create_dm_network_and_system {} {
  global dev_run_llvm run_dir llvm_dir rpt_dir xsd_platform clk_id xd_ip_database target_os_type other_xidanepass_switches verbose asms llvm_link_exclude_list lib_asms

  if {$dev_run_llvm} {
    MSG_PRINT "Generating data motion network"

    # Get frequency from platform file
    # FIX : where is this used?
    set freq [get_clock_frequency $clk_id]

    # puts "1. Generate system.xml and xd_dm_system.xml using llvm"
    set llvm_asms {}
    foreach asm_file $lib_asms {
      if { [file exists $asm_file] } {
        lappend llvm_asms $asm_file
      }
    }
    foreach asm_file $asms {
      set exclude_asm 0
      if {[llength $llvm_link_exclude_list] > 0} {
        foreach excl $llvm_link_exclude_list {
          if { [string first $excl $asm_file] >= 0 } {
            set exclude_asm 1
            break
          }
        }
      }
      if {$exclude_asm} {
        continue
      }
      if { [file exists $asm_file] } {
        lappend llvm_asms [file join ${llvm_dir} $asm_file]
      }
    }
    check_dm_input_modules $llvm_asms
    set command "[::sdsoc::utils::getCommandPath llvm-link] -o [file join ${llvm_dir} sds_all.o] $llvm_asms"
    exec_command_and_print $command

    # TODO: need to make platform dependent call here
    cd_command ${llvm_dir}
    set XidanePass_verbose [expr {$verbose ? "--verbose" : ""}]

    cd_command ${llvm_dir}

    # XidanePass Linux loader accepts sds_all.o as a positional argument
    # or < sds_all.o in a shell window, but running it from TCL doesn't
    # (breaks somewhere along the command line, using backslash, curly brace).
    set proc_type [apc_get_global APCC_PROC_TYPE]
    set command "[::sdsoc::utils::getCommandPath XidanePass] \
      --platform $xsd_platform \
      --dmclkid ${clk_id} \
      --repo $xd_ip_database \
      --dmdb [file join [apc_get_global APCC_PATH_XILINX_XD] data DM.db] \
      $XidanePass_verbose -os $target_os_type -processor $proc_type -partition [apc_get_global APCC_DEFAULT_ID] \
      $other_xidanepass_switches"
    execpipe_command $command 1 exit_handler_xidanepass

    # XidanePass creates the following report files, data_motion.csv
    # and data_motion.html in _sds/.llvm - copy these files to 
    # _sds/reports. If they need to be inserted into an existing
    # report file later, e.g. sds.rpt, they will need to be reformatted.
    set dm_report_file [file join ${llvm_dir} data_motion.csv]
    if { [file exists ${dm_report_file}] } {
      copy_file_force ${dm_report_file} ${rpt_dir}
    }
    set dm_report_file [file join ${llvm_dir} data_motion.html]
    if { [file exists ${dm_report_file}] } {
      copy_file_force ${dm_report_file} ${rpt_dir}
    }
  } else {
    MSG_PRINT "Not running LLVM due to the -mdev-no-llvm switch"
  }
  cd_command ${run_dir}
}

# Run performance estimation. Valid only after XidanePass.
proc run_performance_estimation {num_partitions partitions} {
  global xsd_dir perf_sw_file llvm_dir est_dir

  if {$num_partitions > 1} {
    MSG_ERROR $::sdsoc::msg::idSCPerfPartitions "Performance estimation not available when using multiple partitions. Please disable one of the two."
    sdscc_on_exit 1
  } else {
    set repo_flags [file join ${xsd_dir} xd_ip_db.xml]
    # Grab the apsys file for the first (and only) partition
    set apsys_file [lindex $partitions 1]
    if {[string length $perf_sw_file] > 0} {
      set command "[::sdsoc::utils::getCommandPath perf_est] \
        -s ${perf_sw_file} \
        -hw [file join $llvm_dir hw_perf_est.xml] \
        -r ${repo_flags} \
        -est_ws $est_dir \
        -apsys [file join $llvm_dir $apsys_file]"
    } else {
      set command "[::sdsoc::utils::getCommandPath perf_est] \
        -hw [file join $llvm_dir hw_perf_est.xml] \
        -r ${repo_flags} \
        -est_ws $est_dir \
        -apsys [file join $llvm_dir $apsys_file]"
    }
    exec_command_and_print $command
  }
}
    
# create system metadata file containing list of accelerators
proc create_system_metadata {xdsystem accels} {
  global dev_run_xsd xsd_dir xsd_platform

  if {$dev_run_xsd} {
    # Metadata from sdscc
    set data_file [file join ${xsd_dir} xd_data_${xdsystem}.xml]
    set fp [open ${data_file} w]
    puts $fp "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
    puts $fp "<xd:data xmlns:xd=\"http://www.xilinx.com/xd\">"
    foreach accel $accels {
      puts $fp "  <xd:accel name=\"${accel}\" platform=\"${xsd_platform}\"/>"
    }
    puts $fp "</xd:data>"
    close $fp
  } else {
    MSG_PRINT "Not running XSD due to the -mdev-no-xsd switch"
  }
}

# Insert accelerator stub functions:
# For each accelerator, call rewrite to replace the original
# function with the stub function.
#   rewrite <input_file> <func_name> <func>.cpp.rewrite <output_file>
proc create_accelerator_stub_functions {accels arr_ip_is_rtl arr_sources arr_pp_sources arr_source_paths arr_compiler arr_flags list_rewrites} {
  upvar 1 $arr_ip_is_rtl    my_ip_is_rtl
  upvar 1 $arr_sources      my_sources
  upvar 1 $arr_pp_sources   my_pp_sources
  upvar 1 $arr_compiler     my_compiler
  upvar 1 $arr_source_paths my_source_paths
  upvar 1 $arr_flags        my_flags
  global swstubs_dir dev_run_swgen llvm_dir run_dir

  MSG_PRINT "Create accelerator stub functions"
  cd_command ${swstubs_dir}
  set my_rewrites {}
  set my_rewrites $list_rewrites
  set stub_list {}
  set nop_command "nop"

  # stub_gen Linux command line (original loader)
  # stub_gen $arg_other 
  # --
  # -c -I${LLVM_INSTALL}/llvm/lib/clang/3.1/include 
  # -I${LLVM_INSTALL}/gcc-4.8.0/include/c++/4.8.0 
  # -I${LLVM_INSTALL}/gcc-4.8.0/include/c++/4.8.0/x86_64-unknown-linux-gnu 
  # -I${LLVM_INSTALL}/gcc-4.8.0/include/c++/4.8.0/backward 
  # $arg_include

  if {! $dev_run_swgen} {
    cd_command ${run_dir}
    return
  }

  # hack
  MSG_PRINT [stacktrace]
  set tmp_clang_inclpath "-ID:/Xilinx/SDx/2018.1/llvm-clang/win64/llvm/lib/clang/3.9.0/include"
  MSG_PRINT "tmp_clang_inclpath is $tmp_clang_inclpath"
  # end hack

  foreach accel $accels {
    set translated_source ""
    set temp_file ""
    set stub_file [file join ${llvm_dir} $accel.cfrewrite]
    if {[::sdsoc::template::isTemplateFunction ${accel}]} {
      set funcName [::sdsoc::template::getMapMangled2Original ${accel}]
      set srcName [::sdsoc::template::getMapMangled2TemplateSource ${accel}]
      set stubName [::sdsoc::template::getMapMangled2TemplateStub ${accel}]
      set output_source [file join ${swstubs_dir} $stubName]
      if { [lobject_item_found $my_rewrites $stubName] } {
        set temp_file [file join ${swstubs_dir} temp_$stubName]
        copy_file_force ${output_source} ${temp_file}
        set srcName ${temp_file}
      } else {
        lappend my_rewrites $stubName
      }
      set compiler_type [set_compiler_type $output_source]
      if {[apc_is_windows]} {
        set funcName [::sdsoc::template::getWindowsEscapedName ${funcName}]
      } else {
        set funcName \"${funcName}\"
      }

      set command "[::sdsoc::utils::getCommandPath stub_gen] \
        -func ${funcName} \
        -stub ${stub_file} \
        -o $output_source \
        $srcName \
        -- \
        -c \
        $my_flags($accel) \
        $tmp_clang_inclpath \
        [get_implicit_flags_for_clang $compiler_type 0 0]"
      if {[lsearch -exact $stub_list $output_source] < 0} {
        lappend stub_list $output_source
      }
    } elseif {$my_ip_is_rtl($accel)} {
      #puts "IP IS RTL: $accel"
      #puts "acc_sources: $my_sources($accel)"
      # File is preprocessed. Rewritten file must not contain any preprocessor directives
      set output_source [file join ${swstubs_dir} $my_sources($accel)]
      if { [file exists ${stub_file}] } {
        # if the source contained a caller, caller rewrite already
        # happened using the preprocessed source found in swstubs,
        # so use that for stub insertion rather than the orignal source
        if { [lobject_item_found $my_rewrites [file tail $my_pp_sources($accel)]] } {
          set original_source [file join ${swstubs_dir} $my_sources($accel)]
        } else {
          # pre-processed source contains no callers, just stubs
          set original_source $my_pp_sources($accel)
          lappend my_rewrites $my_pp_sources($accel)
        }
        set translated_source [file join [file dirname $output_source] unix_[file tail $output_source]]
        copy_file_translate_to_unix $original_source $translated_source
        set compiler_type [set_compiler_type $translated_source]
        set command "[::sdsoc::utils::getCommandPath stub_gen] \
          -func \"${accel}\" \
          -stub ${stub_file} \
          -o $output_source \
          $translated_source \
          -- \
          -c \
          $tmp_clang_inclpath \
          [get_implicit_flags_for_clang $compiler_type 0 0]"
        if {[lsearch -exact $stub_list $output_source] < 0} {
          lappend stub_list $output_source
        }
      } else {
        set command "[::sdsoc::utils::getCommandPath cp] \
          $my_pp_sources($accel) \
          $output_source"
        if {[lsearch -exact $stub_list $output_source] >= 0} {
          set command $nop_command
        }
      }
    } else {
      if {[string match *.cl $my_sources($accel)]} {
        set acc_file $my_sources($accel)
        set acc_file [string map {.cl .cpp} $acc_file]
        set command "[::sdsoc::utils::getCommandPath cp] \
          [file join ${llvm_dir} $accel.cfrewrite] \
          $tmp_clang_inclpath \
          [file join ${swstubs_dir} ${acc_file}]"
      } else {
        # Check if source path still exists, otherwise the stub_gen command will fail
        if {[file isdirectory $my_source_paths($accel)]} {
          set output_source [file join ${swstubs_dir} $my_sources($accel)]
          if { [file exists ${stub_file}] } {
            set input_file [file join $my_source_paths($accel) $my_sources($accel)]
            if { [lobject_item_found $my_rewrites $my_sources($accel)] } {
              set temp_file [file join ${swstubs_dir} temp_$my_sources($accel)]
              copy_file_force ${output_source} ${temp_file}
              set input_file ${temp_file}
            } else {
              lappend my_rewrites $my_sources($accel)
            }
            set original_source ${input_file}
            set translated_source [file join [file dirname $output_source] unix_[file tail $output_source]]
            copy_file_translate_to_unix $original_source $translated_source
            set compiler_type [set_compiler_type $translated_source]
            set command "[::sdsoc::utils::getCommandPath stub_gen] \
              -func \"${accel}\"\
              -stub ${stub_file} \
              -o $output_source \
              $translated_source \
              -- \
              -c \
              $my_flags($accel) \
              $tmp_clang_inclpath \
              [get_implicit_flags_for_clang $compiler_type 0 0]"
            if {[lsearch -exact $stub_list $output_source] < 0} {
              lappend stub_list $output_source
            }
          } else {
            set command "[::sdsoc::utils::getCommandPath cp] \
              [file join $my_source_paths($accel) $my_sources($accel)] \
              $tmp_clang_inclpath \
              $output_source"
            if {[lsearch -exact $stub_list $output_source] >= 0} {
              set command $nop_command
            }
          }
        } else {
          # Attempt to use the preprocessed file. This will be the case for libraries generated by sdscc.
          set output_source [file join ${swstubs_dir} $my_sources($accel)]
          if { [file exists ${stub_file}] } {
            set original_source $my_pp_sources($accel)
            set translated_source [file join [file dirname $output_source] unix_[file tail $output_source]]
            copy_file_translate_to_unix $original_source $translated_source
            set compiler_type [set_compiler_type $translated_source]
            set command "[::sdsoc::utils::getCommandPath stub_gen] \
              -func \"${accel}\" \
              -stub ${stub_file} \
              -o $output_source \
              $translated_source \
              -- \
              -c \
              $tmp_clang_inclpath \
              [get_implicit_flags_for_clang $compiler_type 0 0]"
            if {[lsearch -exact $stub_list $output_source] < 0} {
              lappend stub_list $output_source
            }
          } else {
            set command "[::sdsoc::utils::getCommandPath cp] \
              $my_pp_sources($accel) \
              $tmp_clang_inclpath \
              $output_source"
            if {[lsearch -exact $stub_list $output_source] >= 0} {
              set command $nop_command
            }
          }
          # Since a preprocessed is being used, clear the flags
          set my_flags($accel) ""
        }
      }
    }
    if {! [string equal $command $nop_command]} {
      exec_command $command
    }
    if { [file exists ${temp_file}] } {
      delete_file ${temp_file}
    }
    if {[string length $translated_source] > 1} {
      delete_file $translated_source
    }
  }
  cd_command ${run_dir}
}

proc create_partition_folders {partitions xd_ip_database is_unified} {
  global sdscc_dir llvm_dir verbose ipi_dir

  foreach {part_num part_name} $partitions {

    set part_dir [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num}]
    set part_ipi_dir [file join $part_dir [apc_get_global APCC_DIR_SDS_PART_IPI]]
    file mkdir $part_dir
    if {! $is_unified} {
    file mkdir $part_ipi_dir
    }

    # End for each partiton
  }
}

proc compile_stub_base_code {dbg_stub_flag fpic_flag} {
  global run_dir swstubs_dir toolchain perf_prepass est_dir

  cd_command ${swstubs_dir}
  MSG_PRINT "Compile hardware access API functions"

  set perf_flags ""
  if {$perf_prepass} {
    set perf_flags "-DPERF_EST"
  }

    set command "[get_compiler gcc] $dbg_stub_flag $perf_flags [get_implicit_flags_for_gcc] -c $fpic_flag [file join $swstubs_dir portinfo.c]"
  exec_command $command

    set command "[get_compiler g++] $dbg_stub_flag [get_implicit_flags_for_gcc] -c $fpic_flag [file join $swstubs_dir cf_stub.c]"
  exec_command $command

  set perf_extra_object ""
  if {$perf_prepass} {
    set perf_extra_object [file join $est_dir sw_perf_est.o]
      set command "[get_compiler gcc] [get_implicit_flags_for_gcc] -c $fpic_flag [file join $est_dir sw_perf_est.c] -o $perf_extra_object"
    puts $command
    exec_command_and_print $command
  }
  apc_set_global APCC_PERF_EXTRA_OBJECT ${perf_extra_object}
}

proc create_stub_base_library { debug_flag fpic_flag } {
  global swstubs_dir toolchain

  set calling_dir [pwd]
  compile_stub_base_code $debug_flag $fpic_flag
  set stubs_o [list \
                   [file join $swstubs_dir portinfo.o] \
                   [file join $swstubs_dir cf_stub.o] ]
  set command "[get_ar] crs [file join $swstubs_dir libxlnk_stub.a] $stubs_o"
  exec_command $command   
  cd_command ${calling_dir}
  return $stubs_o
}

# SDS library name, without the "lib" prefix or the ".a" suffix
proc get_sds_library_name { } {
  global   debug_xlnk

  if {$debug_xlnk} {
    set sds_library sds_lib_dbg
  } else {
    set sds_library sds_lib
  }
  return $sds_library
}

# SDS extra library name, without the "lib" prefix or the ".a" suffix
# Contains DMA stubs for linking ELF before bitstream generation,
# unified platform only
proc get_sds_dma_library_name { } {
  global run_test_link

  set dma_library ""
  if {! [apc_get_global APCC_USE_STANDALONE_BSP] } {
    return $dma_library
  }
  if {! $run_test_link} {
    return $dma_library
  }
  set dmalib sds_link
  set lib_file [file join [apc_get_global APCC_PATH_XILINX_XD] [apc_get_global APCC_SDS_SOFTWARE_DIR] lib lib${dmalib}.a]
  if {[file exists $lib_file]} {
    set dma_library $dmalib
  }
  return $dma_library
}

# Create design-specfic static library that includes sds_lib
# and rewritten stub files
proc create_static_design_library { stubs_o accels_o } {
  global toolchain swstubs_dir outfile

  # save the calling directory and cd to _sds/swstubs
  set calling_dir [pwd]
  cd_command ${swstubs_dir}

  # build static library
  set sds_library [get_sds_library_name]
  set libname "lib[file rootname [file tail $outfile]].a"
  copy_file_force [file join [apc_get_global APCC_PATH_XILINX_XD] [apc_get_global APCC_SDS_SOFTWARE_DIR] lib lib${sds_library}.a] [file join $swstubs_dir $libname]
  set command "[get_ar] crs [file join $swstubs_dir $libname] $stubs_o $accels_o"
  exec_command $command

  # return to the calling directory
  cd_command ${calling_dir}
}

proc create_bsp_library { hdf_file num_partitions force_build prebuilt_hdf_file} {
  global toolchain
  global target_os_name
  global swstubs_dir

  # by default, no BSP library is created
  set bsplib_dir ""

  # set the hsi recognized -os name (this really shouldn't be hard-coded)
  set hsi_os_name $target_os_name
  if {[string equal -nocase $target_os_name "freertos"]} {
    set hsi_os_name "freertos10_xilinx"
  }

  # if it's not a bare-metal OS, return
  if {! [apc_get_global APCC_USE_STANDALONE_BSP] } {
    return $bsplib_dir
  }

  # partitions aren't supported on a bare-metal OS, so return
  if {$num_partitions > 1} {
    MSG_ERROR $::sdsoc::msg::idSCBspPartitions "Bare-metal board support packages (BSP) not supported when using multiple partitions. Please modify your application to use a single partition or use a different target OS."
    sdscc_on_exit 1
  }

  # check if the hardware handoff file (.hdf) exists
  if {[string length $hdf_file] < 1 || ! [file exists $hdf_file]} {
    MSG_ERROR $::sdsoc::msg::idSCHdfMissing "Hardware handoff file $hdf_file not found, unable to create board support package"
    sdscc_on_exit 1
  }

  # save the calling directory and cd to _sds/swstubs
  set calling_dir [pwd]
  cd_command ${swstubs_dir}

  # define files and directories
  set bspwork_dir [file join ${swstubs_dir} standalone_bsp]
  set bspscratch_dir [file join ${swstubs_dir} standalone_bsp scratch]
  set bsplib_path "[file join ${bspwork_dir} [apc_get_global APCC_PROC_INSTANCE] lib]"
  set bsplib_file "[file join ${bsplib_path} libxil.a]"
  set bsplib_dir "${bsplib_path}"

  # build the standalone BSP libxil.a

  # create HSI TCL files for BSP generation
  file mkdir ${bspwork_dir}
  file mkdir ${bspscratch_dir}
  set bsp_tcl_file [file join ${bspwork_dir} create_bsp.tcl]
  set bsp_tcl_post_file [file join ${bspwork_dir} create_bsp_post.tcl]
  set mss_local [file join ${bspwork_dir} system.mss]
  set mss_scratch [file join ${bspscratch_dir} system.mss]
  set bsp_repo [apc_get_global APCC_BSP_REPOSITORY_PATH]

  set fp_bsp_tcl [open ${bsp_tcl_file} w]
  set fp_bsp_post_tcl [open ${bsp_tcl_post_file} w]

  set prebuilt_mss_file [apc_get_global APCC_BSP_CONFIGURATION_MSS]
  if {[string length $prebuilt_mss_file] > 1 &&
      [string length $prebuilt_hdf_file] > 1} {
    # merge .mss from platform .hdf and update based on .hdf with accelerators
    puts $fp_bsp_tcl "hsi::open_hw_design ${prebuilt_hdf_file}"
    if {[string length $bsp_repo] > 1} {
      puts $fp_bsp_tcl "hsi::set_repo_path ${bsp_repo}"
    } else {
      puts $fp_bsp_tcl "# optionally set repo path here"
    }
    puts $fp_bsp_tcl "hsi::open_sw_design ${prebuilt_mss_file}"
    puts $fp_bsp_tcl "hsi::open_hw_design ${hdf_file}"
    puts $fp_bsp_tcl "hsi::internal::update_sw_design"
    puts $fp_bsp_tcl "write_mss -force -name system -dir ${bspscratch_dir}"
    puts $fp_bsp_tcl "hsi::generate_bsp -dir ${bspscratch_dir} -sw_mss [file join ${bspscratch_dir} system.mss]"
  } else {
    # create a basic .mss file
    puts $fp_bsp_tcl "hsi::open_hw_design ${hdf_file}"
    puts $fp_bsp_tcl "set hw_design \[hsi::current_hw_design\]"
    if {[string length $bsp_repo] > 1} {
      puts $fp_bsp_tcl "hsi::set_repo_path ${bsp_repo}"
    } else {
      puts $fp_bsp_tcl "# optionally set repo path here"
    }
    puts $fp_bsp_tcl "hsi::generate_bsp -dir ${bspscratch_dir} -hw \$\{hw_design\} -os $hsi_os_name -proc [apc_get_global APCC_PROC_INSTANCE]"
  }
  puts $fp_bsp_tcl "quit"
  close $fp_bsp_tcl

  puts $fp_bsp_post_tcl "hsi::open_hw_design ${hdf_file}"
  puts $fp_bsp_post_tcl "set hw_design \[hsi::current_hw_design\]"
  if {[string length $bsp_repo] > 1} {
    puts $fp_bsp_post_tcl "hsi::set_repo_path ${bsp_repo}"
  }
  puts $fp_bsp_post_tcl "hsi::open_sw_design ${mss_local}"
    puts $fp_bsp_post_tcl "set_property -name VALUE -value [get_compiler gcc] -objects \[hsi::get_comp_params -filter \"NAME == compiler\"\]"
  puts $fp_bsp_post_tcl "set_property -name VALUE -value [get_ar] -objects \[hsi::get_comp_params -filter \"NAME == archiver\"\]"
  set copts [apc_get_global APCC_SDS_ARCHFLAGS]
  puts $fp_bsp_post_tcl "set_property -name VALUE -value \"-O2 -c ${copts}\" -objects \[hsi::get_comp_params -filter \"NAME == compiler_flags\"\]"
  puts $fp_bsp_post_tcl "hsi::generate_bsp -dir ${bspwork_dir} -compile"
  puts $fp_bsp_post_tcl "quit"
  close $fp_bsp_post_tcl

  cd_command ${bspwork_dir}

  # Create the MSS file
  set mss_user [apc_get_global APCC_BSP_CONFIGURATION_MSS_USER]
  set mss_merge ""
  set mss_user_merge [apc_get_global APCC_BSP_CONFIGURATION_MSS_USER_MERGE]
  set mss_platform_merge [apc_get_global APCC_BSP_CONFIGURATION_MSS]
  if {[string length $mss_user_merge] > 1} {
    set mss_merge $mss_user_merge
  } elseif {[string length $mss_platform_merge] > 1} {
    set mss_merge $mss_platform_merge
  }
  if {[string length $mss_user] > 1} {
    # user defines the .mss file
    copy_file_force_writeable ${mss_user} ${mss_local}
  } elseif {[string length $mss_merge] > 1 &&
            [string length $prebuilt_hdf_file] < 1} {
    # use platform .mss file if it exists and the BSP being generated
    # is for the preliminary ELF linking (hdf_file is actually the
    # platform hdf and prebuilt_hdf_file is empty). If a platform .mss
    # exists, a platform hdf must also exist).
    copy_file_force_writeable ${mss_merge} ${mss_local}
  } else {
    # generate a .mss file for platform and design (merged .mss) or
    # the general case of creating a default mss file
    set command "[::sdsoc::utils::getCommandPath hsi] \
      -mode batch -notrace -quiet -source ${bsp_tcl_file}" 
    exec_command $command
    copy_file_force $mss_scratch $mss_local
  }

  # Add xilffs to the MSS file
  update_mss_with_xilffs [file join ${bspwork_dir} system.mss]

  # Check if the MSS has changed from the previous run
  set bsp_is_stale 0
  set mss_old ${mss_local}_prev
  if {[file exists $mss_old]} {
    if {[diff_files $mss_local $mss_old] != 0} {
      set bsp_is_stale 1
    }
  } else {
    set bsp_is_stale 1
  }
  if {! [file exists $bsplib_file]} {
    set bsp_is_stale 1
  }

  # if the checking for stale BSP isn't updated for the unified platform
  # flow, then always force a rebuild to be safe
  if {$force_build} {
    set bsp_is_stale 1
  }

  # Create the BSP
  if { $bsp_is_stale } {
    MSG_PRINT "Create board support package library"

    # Configure source, compile and build BSP
    set command "[::sdsoc::utils::getCommandPath hsi] \
      -mode batch -notrace -quiet -source ${bsp_tcl_post_file}"
    exec_command $command

    # Save the MSS file for comparison with the next run
    if {[file exists $mss_local]} {
      copy_file_force $mss_local $mss_old
    }
  }

  # return to the calling directory 
  cd_command ${calling_dir}

  # return the BSP library path
  return $bsplib_dir
}

proc link_application_elf { accels_o stubs_o bsplib_dir prelim_link } {
  global toolchain compiler shared swstubs_dir
  global infiles outfile other_switches
  global accels
  global target_os_type

  # get the SDS library name
  set sds_library [get_sds_library_name]

  # swonly_o contains portinfo.o for software only designs,
  # which would not otherwise link them in from the xlnk_library. Keep
  # xlnk_library to preserve library searches for resolving references.
  # See CR 765121.
  set swonly_o {}
  if {[llength $accels] < 1 } {
    lappend swonly_o [file join ${swstubs_dir} portinfo.o]
  }

  # add platform library, if any (only FreeRTOS so far libfreertos.a)
  set oslib " "
  set lib_param [apc_get_global APCC_OS_LINKER_LIBRARY_NAME]
  if {[string length $lib_param] > 1} {
    set lib_list [split $lib_param :]
    foreach libName $lib_list {
      append oslib " -l$libName"
    }
  }

  # set BSP library option if needed
  set bsplib_opt ""
  if {[string length ${bsplib_dir}] > 0} {
    set bsplib_opt "-L ${bsplib_dir}"
  } 

  # set additional linker flags
  if { [apc_get_global APCC_USE_STANDALONE_BSP] } {
    set sadma ""
    if {$prelim_link} {
      set dma_library [get_sds_dma_library_name]
      if { [string length $dma_library] > 0} {
        set sadma "-l${dma_library}"
      }
    }
    set pthreadlib ""
    set ldscript "-Wl,-T -Wl,[apc_get_global APCC_LINKER_SCRIPT]"
    set salib_pre "-lxilffs -lgcc -lc -lstdc++"  
    set salib "-lxilffs -lxil ${sadma} -lgcc -lc"
    set salibc "-lgcc -lc"
  } else {
    set pthreadlib "-lpthread"
    set ldscript ""
    set salib ""
    set salib_pre ""
    set salibc ""
  }

  # save the ELF temporary and final file names
  # delete previous ELF created in temporary location if it exists

  set elf_temp [file join ${swstubs_dir} [file tail ${outfile}]]
  if { [file exists $elf_temp] } {
    set status [catch {file delete -force $elf_temp} result]
    if {$status != 0} {
      MSG_ERROR $::sdsoc::msg::idSCDeleteTempElf "Cannot delete temporary ELF file '$elf_temp' because it is being used. Ensure the file is closed and is not being used."
    }
  }
  apc_set_global APCC_ELF_TEMP_PATH $elf_temp

  if {$shared} {
    # Do not link against pthread when creating a shared library
    set command "[get_cc] [get_implicit_link_flags] $ldscript [apc_get_global APCC_PERF_EXTRA_OBJECT] $accels_o $infiles $stubs_o $other_switches ${bsplib_opt} [apc_get_global APCC_LFLAGS_PLATFORM] -L [file join [apc_get_global APCC_PATH_XILINX_XD] [apc_get_global APCC_SDS_SOFTWARE_DIR] lib] -L${swstubs_dir} -l${sds_library} -o [apc_get_global APCC_ELF_TEMP_PATH]"
  } else {
    set command "[get_cc] [get_implicit_link_flags] $ldscript [apc_get_global APCC_PERF_EXTRA_OBJECT] $accels_o $infiles $swonly_o $other_switches ${bsplib_opt} [apc_get_global APCC_LFLAGS_PLATFORM] -L [file join [apc_get_global APCC_PATH_XILINX_XD] [apc_get_global APCC_SDS_SOFTWARE_DIR] lib] -L${swstubs_dir} -Wl,--start-group ${salib_pre} -Wl,--end-group -Wl,--start-group ${oslib} ${salib} $pthreadlib -l${sds_library} -lxlnk_stub ${salibc} -Wl,--end-group -o [apc_get_global APCC_ELF_TEMP_PATH]"
  }
  exec_command_and_print $command

  # Strip out all sections added as a side effect of sdsoc flows
    set command "[get_objcopy] -R .xdinfo -R .xddata -R .xdasm -R .xdfcnmap -R .xdhlscore -R .xdif -R .xdparams -R .xdcore -R .xdrepo -R .xdsdata -R .xdpp [apc_get_global APCC_ELF_TEMP_PATH]"
  exec_command $command
}

# If found, remove an object file from a list of object files.
# The list is modified in place. The paths are not compared,
# only the file name.
proc lobject_remove_item {lobjects target_obj} {
  upvar 1 $lobjects myobjects
  set target_obj_name [file tail $target_obj]
  set myobjects_new {}
  foreach obj $myobjects {
    set obj_name [file tail $obj]
    if {[string equal $target_obj_name $obj_name]} {
      # use new object file in place of the original file,
      # omit it here
    } else {
      # keep original object file
      lappend myobjects_new $obj
    }
  }
  if {[llength $myobjects_new] < [llength $myobjects]} {
    set myobjects $myobjects_new
  }
}

# Test if an object file is found in a list of object files.
# The paths are not compared, only the file name.
proc lobject_item_found {lobjects target_obj} {
  set target_obj_name [file tail $target_obj]
  foreach obj $lobjects {
    set obj_name [file tail $obj]
    if {[string equal $target_obj_name $obj_name]} {
      return 1
    }
  }
  return 0
}

# Extract information from metadata stored in object file sections
proc extract_object_accel_list {obj_file} {
  global data_dir

  set accel_list {}

  # If the object contains a .xdinfo section, it was created with
  # SDSoC 2015.2 (or later) and contains one or more accelerators.
  set xml_file [file join ${data_dir} xdinfo.xml]
  set ec [extract_sdsoc_metadata_xml $obj_file ".xdinfo" $xml_file]
  if { $ec == 0 } {
    set accel_num [xpath_get_value $xml_file "number(/xd:data/@xd:num_accels)"]
    # puts "*** $obj_file .xdinfo section, number of accelerators $accel_num"
    for {set i 0} {$i < $accel_num} {incr i} {
      set xpath "/xd:data/xd:accel\[@id='$i']/@name"
      set accel_name [xpath_get_value $xml_file $xpath]
      lappend accel_list $accel_name
      # puts "    accelerator id $i $accel_name"
    }
    # delete temporary metadata file
    if {[file exists $xml_file]} {
      delete_file $xml_file
    }
    return $accel_list
  }

  # The object does not contain a .xdinfo section. If it contains a
  # .xddata section, the object is associated with only one accelerator.
  set xml_file [file join ${data_dir} xddata.xml]
  set ec [extract_sdsoc_metadata_xml $obj_file .xddata $xml_file]
  if { $ec == 0 } {
    set accel_name [xpath_get_value $xml_file "xd:data/xd:accel/@name"]
    lappend accel_list $accel_name
    # puts "*** $obj_file contains one accelerator $accel_name"
    # delete temporary metadata file
    if {[file exists $xml_file]} {
      delete_file $xml_file
    }
    return $accel_list
  }

  # The object contains no accelerators
  # puts "*** $obj_file contains no accelerators"
  return $accel_list
}

proc trace_hardware {partition_num} {
    global trace_dir sdscc_dir
    #get the number of hardware trace points (monitor cores, hardware IDs, etc.)
    set hasTrace_dir  [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${partition_num} [apc_get_global APCC_DIR_SDS_CFWORK] ".hwTraceMapping"]
    set fp [open $hasTrace_dir r]
    set str [read $fp]
    set num_trace_cores [llength [split $str "\n"]]
    
    #has hardware, use the mdm tcl script
    set trace_tcl [file join [apc_get_global APCC_PATH_XILINX_XD] scripts trace "trace_hw_mdm.tcl"]
    set sds_trace [file join $trace_dir "sdsoc_trace.tcl"]
    MSG_PRINT "Inserted $num_trace_cores hardware monitor cores"
    copy_file_force_writeable $trace_tcl $sds_trace
    
    #read in the mdm address
    set fp [open [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${partition_num} [apc_get_global APCC_DIR_SDS_CFWORK] ".hwTraceInfo"] r]
    set file_data [read $fp]
    set mdmAddr [string range $file_data 0 7]
    set file_lines [split $file_data "\n"]
    set traceClkInfo [split [lindex $file_lines 2]]
    set traceClkID [lindex $traceClkInfo 0]
    set traceClkFreq [lindex $traceClkInfo 1]
    close $fp
    
    #read in the hw trace ID map
    set hwMap [open [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${partition_num} [apc_get_global APCC_DIR_SDS_CFWORK] ".hwTraceMapping"] r]
    set hwMap_data [read $hwMap]
    set hwMap_data [split $hwMap_data "\n"]
    close $hwMap
    
    #read in the sw trace ID map
    set swMap [open [file join $sdscc_dir ".llvm" ".swTraceMapping"] r]
    set swMap_data [read $swMap]
    set swMap_data [split $swMap_data "\n"]
    close $swMap
    
    #append mdm address code to tcl file
    set fp [open $sds_trace a]
    puts $fp ""
    puts $fp "set mdmAddr $mdmAddr"
    puts $fp ""
    
    #append ID mapping function to tcl file
    puts -nonewline $fp "set idmap { "
    #loop over entries in hw map
    foreach line $hwMap_data {
	set map_line [split $line " "]
	#check type of entry
	if { [string equal "axi_stream" [lindex $map_line 0]] } {
	    set id [lindex $map_line 3]
	    set name [lindex $map_line 1]:[lindex $map_line 2]
	    puts -nonewline $fp "$id $name "
	} elseif { [string equal "accelerator" [lindex $map_line 0]] } {
	    set id [lindex $map_line 2]
	    set name [lindex $map_line 1]
	    puts -nonewline $fp "$id $name "
	} elseif { [string equal "axi_master" [lindex $map_line 0]] } {
	    set read_id [lindex $map_line 3]
	    set write_id [lindex $map_line 4]
	    set name [lindex $map_line 1]:[lindex $map_line 2]
	    puts -nonewline $fp "$read_id $name "
	    puts -nonewline $fp "$write_id $name "
	}
    }
    #loop over entries in sw map
    foreach line $swMap_data {
	set map_line [split $line " "]
	#check type of entry
	set id [lindex $map_line 1]
	set name [lindex $map_line 0]
	puts -nonewline $fp "$id $name "
    }
    puts $fp "}"
    puts $fp ""
    
    #generate type mapper code
    puts -nonewline $fp "set typemap { "
    #loop over entries in hw map
    foreach line $hwMap_data {
	set map_line [split $line " "]
	#check type of entry
	set type [lindex $map_line 0]
	if { [string equal "axi_stream" $type] } {
	    set id [lindex $map_line 3]
	    puts -nonewline $fp "$id $type "
	} elseif { [string equal "accelerator" $type] } {
	    set id [lindex $map_line 2]
	    puts -nonewline $fp "$id $type "
	} elseif { [string equal "axi_master" $type] } {
	    set read_id [lindex $map_line 3]
	    set write_id [lindex $map_line 4]
	    puts -nonewline $fp "$read_id ${type}_read "
	    puts -nonewline $fp "$write_id ${type}_write "
	}
    }
    puts $fp "}"
    puts $fp ""
    
    #close the tcl file
    close $fp
    set clk_freq [format {%.0f} [expr $traceClkFreq * 1000000]]
    trace_metadata $clk_freq
}

proc trace_software {} {
    global trace_dir
    MSG_PRINT "Software tracing enabled"
    set trace_tcl [file join [apc_get_global APCC_PATH_XILINX_XD] scripts trace "trace_sw_ddr.tcl"]
    set sds_trace [file join $trace_dir "sdsoc_trace.tcl"]
    
    copy_file_force $trace_tcl $sds_trace
    
    #get the CPU clock frequency (which the Global timer runs at)
    set clk_freq [format {%.0f} [expr [get_cpu_frequency] * 1000000]]
  
    trace_metadata $clk_freq
}

proc trace_metadata {clkFreq} {
    global trace_dir 
    #copy metadata file
    set metadata_first [file join [apc_get_global APCC_PATH_XILINX_XD] scripts trace "metadata_first"]
    set fp [open $metadata_first r]
    set first [read $fp]
    set metadata_second [file join [apc_get_global APCC_PATH_XILINX_XD] scripts trace "metadata_second"]
    set fp [open $metadata_second r]
    set second [read $fp]
    set meta_trace [file join $trace_dir "metadata"]
    set fp [open $meta_trace w]
    puts -nonewline $fp $first
    #insert the trace clock freq.
    puts $fp "    freq = $clkFreq;"
    puts $fp $second
    close $fp
}

# Force exit early if running DM tests
proc check_dmtest_early_exit { usePrebuilt } {
  global dev_dmtest_early_exit
  global run_emulation_export

  if {! $dev_dmtest_early_exit} {
    return
  }
  if { $run_emulation_export } {
    return
  }
  if { $usePrebuilt } {
    return
  }
  # Warn the user that the generated files may be incomplete or have errors
  MSG_WARNING $::sdsoc::msg::idSCDMTestEarlyExit "User running data motion network tests, forcing early termination with exit code 0. Files that are normally generated may be missing or functionally incorrect."

  # Copy the ELF to where the user expects it so regression tests don't
  # all have to be changed, but this ELF won't run.
  set elf_temp [apc_get_global APCC_ELF_TEMP_PATH]
  if { [file exists $elf_temp] } {
    # copy the ELF to the user's location
    set elf_final [apc_get_global APCC_ELF_FINAL_PATH]
    set status [catch {file copy -force $elf_temp $elf_final} result]
    if {$status != 0} {
      MSG_ERROR $::sdsoc::msg::idSCCopyTempElf "Cannot copy temporary ELF file '$elf_temp' to final location '$elf_final' because it is being used. Ensure the file is closed and is not being used."
    }
  }

  # Force exit now so we don't generated more errors because there is
  # no bitstream
  sdscc_on_exit 0
}

# Link flow for Vivado/IPI only
proc sdscc_link1 {} {
  global target_os_name target_os_type toolchain compiler run_hls run_boot_files run_bitstream run_emulation_export emulation_mode
  global insert_apm insert_trace_hw insert_trace_sw num_trace_cores trace_depth debug verbose optimize_flag debug_xlnk shared
  global run_dir sdscc_dir data_dir rpt_dir trace_dir hasTrace_dir \
      hw_dir libs_dir llvm_dir swstubs_dir xsd_dir cf_dir ipi_dir pp_dir sdscc_dir_name est_dir
  global asms bitstream infiles outfile outfile_str other_switches inlibs inlibpaths
  global xsd_platform xsd_platform_path platform_hw_xml clk_id
  global dev_run_llvm dev_run_xsd
  global dev_run_swgen
  global xd_ip_database
  global other_xidanepass_switches
  global other_syslink_switches
  global perf_root perf_funcs perf_prepass
  global perf_est perf_sw_file
  global backup_perf_est backup_perf_prepass
  global partitions
  global rebuild_empty_hardware
  global disable_multi_clks
  global lib_asms
  global found_hw_trace found_sw_trace trace_axilite

  set xdsystem "xdsystem"
  apc_set_global APCC_RUN_BITSTREAM ${run_bitstream}
  apc_set_global APCC_PERF_EXTRA_OBJECT ""
  apc_set_global APCC_ELF_FINAL_PATH [file normalize ${outfile}]

  # =========================================================
  # Propagate platform options to system_linker
  # =========================================================
  set platform_syslink_switches ""
  set pfm_config [apc_get_global APCC_PFM_CONFIG]
  if {[string length $pfm_config] > 0} {
    append platform_syslink_switches " -sds-sys-config $pfm_config"
  }
  set pfm_proc [apc_get_global APCC_PFM_PROC]
  if {[string length $pfm_proc] > 0} {
    append platform_syslink_switches " -sds-proc $pfm_proc"
  }

  # =========================================================
  # Start with a clean IP repository to avoid stale data
  # =========================================================
  if { $dev_run_xsd } {
    if {[file exists $xsd_dir]} {
      delete_directory $xsd_dir
    }
    file mkdir $xsd_dir
  }

  # =========================================================
  # If the IPI folder exists, decide if in this run we should
  # try to start a clean run and remove it.
  # =========================================================
  if { [file exists $ipi_dir] } {
    global run_apf_clean

    # By default, don't delete the IPI folder
    set delete_ipi_folder 0

    # If the user did not specify -mno-bitstream, it's ok to start a clean run
    if { $run_bitstream } {
      set delete_ipi_folder 1
    }

    # If the user did specify -mno-bitstream and a bitstream does not exist,
    # it's ok to start a clean run
    if { $run_bitstream == 0 && ![file exists $bitstream]} {
      set delete_ipi_folder 1
    }

    # delete IPI folder if not overridden by -mno-clean
    if { $delete_ipi_folder && $run_apf_clean } {
      MSG_PRINT [stacktrace]
      MSG_PRINT "Removing implementation files from previous run"
      delete_directory $ipi_dir

	    #     PA2: defer cleanup of p<n>/ipi, only happens if bitstream regenerated
	    #     set sl_ipi_dirs [glob -nocomplain -type d -directory ${sdscc_dir} [file join [apc_get_global APCC_DIR_SDS_PART]* [apc_get_global APCC_DIR_SDS_PART_IPI]]]
	    #     foreach dir $sl_ipi_dirs { 
	    #       delete_directory $dir
	    #     }
    }
  }

  # Create implementation folder if it doesn't exist
  file mkdir $ipi_dir

  # ========================================
  # Local variables filled in from xml files
  # ========================================
  set accels {}
  set srcfile ""
  set srcpath ""
  set compiler_str ""
  set flags_str ""
  set ip_requires_adapter 0
  set ip_is_rtl 0
  set ip_has_repo 0
  set ip_is_pfunc 0
  set is_opencl 0
  set vlnv ""
  array set acc_flags {}
  array set acc_sources {}
  array set acc_pp_sources {}
  array set acc_source_paths {}
  array set acc_compiler {}
  array set acc_clk_ids {}
  array set acc_ip_is_rtl {}
  array set acc_ip_has_repo {}
  array set acc_ip_is_pfunc {}
  set accels_o {}
  set run_xsd 0

  # bitstream build management
  # - list of accelerator objects and libraries
  # - partition bitstream build needed or not (index by partition number)
  set acc_objs_and_libs {}
  set partition_build_needed [dict]

  # clang-processed .s files from library accelerators
  set lib_asms {}

  #set partitions [list]
  set num_partitions 0

  # Create flow directories
  file mkdir $pp_dir

  # If platform is specified on the link command, it triggers the creation
  # of a bitstream even if there are no functions in the PL
  if {[string length $xsd_platform] != 0} {
    set run_xsd 1
  }

  if { $perf_prepass } {
    stitch_perf_file_fragments
  }
   
  # Look for libraries and extract object files associated with accelerators.
  # infiles contains objects from the link command plus accelerator objects
  # (if any) from libraries and acc_objs_and_libs contains a list of these
  # libraries. Later, accelerator objects from infiles is added to
  # acc_objs_and_libs, which will be used for build state checking.
  # add libraries specified in the platform to the list of libraries.
  set lib_param [apc_get_global APCC_OS_LINKER_LIBRARY_NAME]
  if {[string length $lib_param] > 1} {
    set lib_list [split $lib_param :]
    foreach libName $lib_list {
      if {$libName ni $inlibs} {
        lappend inlibs $libName
      }
    }
  }
  lappend inlibpaths [split [apc_get_global APCC_LPATHS_PLATFORM] ;] 
  extract_library_objects infiles acc_objs_and_libs

  # Grab files from object files 
  if {[llength $infiles] > 0} {
    MSG_PRINT "Analyzing object files"
  }
    
  if {$perf_prepass} {  
    set tmpinfiles ""  
    foreach object $infiles {
      if { [file exists [file join $est_dir [file tail $object]]] } {
        lappend tmpinfiles [file join $est_dir [file tail $object]]
      } else {
        lappend tmpinfiles $object
      }
    }
    set infiles $tmpinfiles
  }
  
  if {$perf_est} {  
    set tmpinfiles ""  
    foreach object $infiles {
	if { [file exists [file join $est_dir [apc_get_global APCC_DIR_SDS_EST_ACCDATA] [file tail $object]]] } {
        lappend tmpinfiles [file join $est_dir [apc_get_global APCC_DIR_SDS_EST_ACCDATA] [file tail $object]]
      } else {
        lappend tmpinfiles $object
      }
    }
    set infiles $tmpinfiles
  }
  
  foreach object $infiles {

    puts "... $object"

    # Collect information about accelerators, if any, associated with
    # the source object, for example the accelerator count.
    set accel_id 0
    set obj_accels [extract_object_accel_list ${object}]
	# start accelerator loop
    foreach obj_accel $obj_accels {
      # Process accelerator
      set xml_file [file join ${data_dir} ${obj_accel}.xml]

      # Grab xddata from object files
      set acc_xml_ec [extract_accel_xml ${object} $accel_id ${xml_file}]

    if {$perf_prepass} {
        MSG_PRINT "Passing through file without processing (due to performance estimation flow): $object"
    } elseif { $acc_xml_ec != 0 } {
        if {$verbose} {
          puts "Passing through file without processing (no SDSoC data): $object"
        }
    } else {
      lappend acc_objs_and_libs $object

      # Grab information from xml file
      set name                [xpath_get_value $xml_file "xd:data/xd:accel/@name"]
      set platform            [xpath_get_value $xml_file "xd:data/xd:accel/@platform"]
      set compiler_str        [xpath_get_value $xml_file "xd:data/xd:accel/@compiler"]
      set srcfile             [xpath_get_value $xml_file "xd:data/xd:accel/@srcfile"]
      set srcpath             [xpath_get_value $xml_file "xd:data/xd:accel/@srcpath"]
      set flags_str           [xpath_get_value $xml_file "xd:data/xd:accel/@flags"]
      set aclk_id             [xpath_get_value $xml_file "xd:data/xd:accel/@clk_id"]
      set ip_requires_adapter [xpath_get_value $xml_file "xd:data/xd:accel/@ip_requires_adapter"]
      set ip_is_rtl           [xpath_get_value $xml_file "xd:data/xd:accel/@ip_is_rtl"]
      set ip_has_repo         [xpath_get_value $xml_file "xd:data/xd:accel/@ip_has_repo"]
      set ip_is_pfunc         [xpath_get_value $xml_file "xd:data/xd:accel/@ip_is_pfunc"]
      set vlnv                [xpath_get_value $xml_file "xd:data/xd:accel/@vlnv"]
      set is_opencl           [xpath_get_value $xml_file "xd:data/xd:accel/@is_opencl"]
      set asmfile             [xpath_get_value $xml_file "xd:data/xd:accel/@asmfile"]
      set esc_funcName        [xpath_get_value $xml_file "xd:data/xd:accel/@esc_original_name"]
      set template_source     [xpath_get_value $xml_file "xd:data/xd:accel/@template_source_file"]
      if {[string length $esc_funcName] > 0} {
        set orig_funcName [::sdsoc::template::escapedXml2OriginalName $esc_funcName]
        set mangled_funcName [::sdsoc::template::originalName2MangledName ${orig_funcName}]
      } else {
        set orig_funcName $name
        set mangled_funcName $name
      }
      ::sdsoc::template::addTemplateMap ${orig_funcName} $mangled_funcName
      if {[string length $template_source] > 0} {
        ::sdsoc::template::addTemplateSource $mangled_funcName $template_source
      }
      if {[string length $asmfile] < 1} {
        set asmfile "NA"
      }
      
      # Checks 
      if {[string length $srcfile] == 0} {
        MSG_ERROR $::sdsoc::msg::idSCCorruptObject "Corrupt object file. The xd:data description for accelerator $name is missing the srcfile attribute."
        sdscc_on_exit 1
      }

      # Resolve defaults
      if  {[string length $ip_requires_adapter] == 0} {
        set ip_requires_adapter 0
      }
      if {[string length $ip_is_rtl] == 0} {
        set ip_is_rtl 0
      }
      if {[string length $ip_has_repo] == 0} {
        set ip_has_repo 0
      }
      if {[string length $ip_is_pfunc] == 0} {
        set ip_is_pfunc 0
      }
      if {[string length $aclk_id] == 0} {
        set aclk_id [get_default_clock_id]
      }
      if {[string length $compiler_str] == 0} {
        if { [is_cpp_source $srcfile] } {
          set compiler_str g++
        } else {
          set compiler_str gcc
        }
      }

      lappend accels $name

      if { $verbose } {
        puts "NAME: $name"
        puts "SRCFILE: $srcfile"
        puts "SRCPATH: $srcpath"
        puts "COMPILER: $compiler_str"
        puts "FLAGS: $flags_str"
      }

      set acc_compiler($name) $compiler_str
      set acc_flags($name)  $flags_str
      set acc_sources($name) $srcfile
      set acc_source_paths($name) $srcpath
      set acc_clk_ids($name) $aclk_id
      set acc_ip_requires_adapter($name) $ip_requires_adapter
      set acc_ip_is_rtl($name) $ip_is_rtl
      set acc_ip_has_repo($name) $ip_has_repo
      set acc_ip_is_pfunc($name) $ip_is_pfunc

      if {$ip_is_rtl} {
        set vlnv_list [split $vlnv ":"]
        set ip_name [lindex $vlnv_list 2]
      } else {
        set ip_name $name
      }

      if {[string length $platform] != 0} {
        if {[string length $xsd_platform] == 0} {
          set_xsd_platform $platform
			resolve_platform_configuration $xsd_platform 0
          set platform_hw_xml [resolve_hw_platform_file $xsd_platform]
        } else {
          if {[string compare $xsd_platform $platform]} {
            MSG_ERROR $::sdsoc::msg::idSCMismatchPlatform "Mismatch in platform names. $object was compiled for platform '$platform' using the '-hw' switch while other object files were compiled for '$xsd_platform'"
          }
        }
        # If platform is not in the object, leave xsd_platform empty for next object to resolve
      }

      set run_xsd 1

      # Extract clang .s if available for a library accelerator
      if {$accel_id < 1 && [string first ${libs_dir} ${object}] >= 0} {
        if {! [string equal $asmfile "NA"]} {
          set s_file [file join [file dirname ${object}] $asmfile]
          lappend lib_asms ${s_file}
	    set command "[get_objcopy] -O binary --set-section-flags .xdasm=alloc --only-section=.xdasm ${object} ${s_file}"
          exec_command $command
        }
      }

      # Grab preprocessed file
      if {$accel_id < 1 && !$is_opencl} {
        if {[string equal $compiler_str "gcc"]} {
          set pp_ext "i"
        } else {
          set pp_ext "ii"
        }
        set pp_file [file join ${pp_dir} [file rootname [file tail ${srcfile}]].${pp_ext}]
        set acc_pp_sources($name) $pp_file
	  set command "[get_objcopy] -O binary --set-section-flags .xdpp=alloc --only-section=.xdpp ${object} ${pp_file}"
        exec_command $command
      }

      # Grab fcnmap.xml file
      set fcnmap_file [file join ${xsd_dir} ${ip_name}.$name.fcnmap.xml]
      set section_name [accel_section_name ".xdfcnmap" $accel_id]
	set command "[get_objcopy] -O binary --set-section-flags ${section_name}=alloc --only-section=${section_name} ${object} ${fcnmap_file}"
      exec_command $command

      # Change fcnmap.xml clock ID if overridden by the user
      set aclkId [::sdsoc::opt::getOptAclkId $name]
      if {$ip_is_rtl && $aclkId >= 0 && [clock_exists $aclkId]} {
        change_fcnmap_clock ${fcnmap_file} $aclkId
      }

      if {!$ip_is_rtl} {
        # Grab HLS core zip file
        set ipi_core_dir [file join $ipi_dir repo xilinx_com_hls_${name}_1_0]
        file mkdir $ipi_core_dir
        set core_zip [file join $ipi_core_dir xilinx_com_hls_${name}_1_0.zip]
        set section_name [accel_section_name ".xdhlscore" $accel_id]
        set command "[get_objcopy] -O binary --set-section-flags ${section_name}=alloc --only-section=${section_name} ${object} ${core_zip}"
        exec_command $command
        
        # Extract core zip file
        set command "[::sdsoc::utils::getCommandPath unzip] \
          -u -o $core_zip -d $ipi_core_dir"
        exec_command $command
      } else {
        # Grab params.xml file
        set params_file [file join ${xsd_dir} ${ip_name}.params.xml]
        set section_name [accel_section_name ".xdparams" $accel_id]
        set command "[get_objcopy] -O binary --set-section-flags ${section_name}=alloc --only-section=${section_name} ${object} ${params_file}"
        exec_command $command

        # Grab IP core zip file
        regsub -all {(\.|\:)} $vlnv  "_" vlnv_under
        if {$ip_is_pfunc} {
          set ipi_core_dir [file join $ipi_dir .repo_pfunc ${vlnv_under}]
        } else {
          set ipi_core_dir [file join $ipi_dir repo ${vlnv_under}]
        }
        file mkdir $ipi_core_dir
        set core_zip [file join $ipi_core_dir ${vlnv_under}.zip]
        set section_name [accel_section_name ".xdcore" $accel_id]
        set command "[get_objcopy] -O binary --set-section-flags ${section_name}=alloc --only-section=${section_name} ${object} ${core_zip}"
        exec_command $command
        
        # Extract core zip file
        set command "[::sdsoc::utils::getCommandPath unzip] \
          -u -o $core_zip -d $ipi_core_dir"
        exec_command $command
      }

      if {$ip_requires_adapter} {
	  set xdif_file [file join $xsd_dir ${ip_name}_if.xml]
        set section_name [accel_section_name ".xdif" $accel_id]
	  set command "[get_objcopy] -O binary --set-section-flags ${section_name}=alloc --only-section=${section_name} ${object} ${xdif_file}"
        exec_command $command
      }

      # Workaround to remove FREQ_HZ
      set xsl_file [file join [apc_get_global APCC_PATH_XILINX_XD] scripts xsd rm_freq_hz.xsl]
      set xml_file [file join $ipi_core_dir component.xml]
      set temp_xml_file [file join $ipi_core_dir temp_component.xml]
      copy_file_force $xml_file $temp_xml_file
      delete_file $xml_file
      set command "[::sdsoc::utils::getCommandPath xsltproc] \
        -o $xml_file $xsl_file $temp_xml_file"
      #if { $verbose } {
      #  puts "Removing FREQ_HZ from $xml_file"
      #  puts $command
      #}
      regsub -all {\[} $command "\\\[" escaped_command
      catch { eval exec $escaped_command 2>@ stderr } result
      #puts "DELETING $xml_file"
      #delete_file $xml_file
      #copy_file_force $new_xml_file $xml_file
    }
      incr accel_id
    }
	# end accelerator loop

}
    puts "Accelerators: $accels"

  # Check -ac options if used
  check_ac_override_options $accels acc_ip_is_rtl

  # Create Vivado HLS testbench TCL files for cosimulation
  global debug_hls
  if {$debug_hls && [llength $accels] > 0} {
    foreach accel $accels {
      write_hls_tb_tcl_file $accel $infiles
    }
  }

  # Create empty repo directory if there is none, keeps system_linker quiet
  set ip_repo_dir [file join $ipi_dir repo]
  if {! [file exists $ip_repo_dir]} {
    file mkdir $ip_repo_dir
  }

  # Resolve clk_id if not given
  if {[string length $clk_id] == 0} {
    set clk_id [get_default_clock_id]
  }

  # Check clock IDs. Multiple clock systems are not supported in
  # the Public Access 1 release due to a bug in the axis_accelerator_adapter,
  # which should be fixed in the 2015.1 release. The clock IDs for
  # accelerators and the data motion network need to be the same.
  if {[llength $accels] > 0} {
    foreach accel $accels {
      set aclk_id $acc_clk_ids($accel)
      if {$aclk_id != $clk_id && $disable_multi_clks != 0} {
        MSG_ERROR $::sdsoc::msg::idSCMultiClock "Multiple clock systems are not supported, use the same clock ID for accelerators (-clkid options) and data motion network (-dmclkid option); specify all clocks if the default is not used. Data motion network uses clock ID $clk_id, accelerator $accel uses clock ID $aclk_id."
        sdscc_on_exit 1
      }
    }
  }

  # =============================================================
  # If building a software-only application with no hardware
  # platform specified, call the compiler toolchain to link the
  # ELF and return. There is no bitstream or SD card image.
  # =============================================================
  if {! $run_xsd} {
    MSG_PRINT "Link application ELF file"
    # Call ARM Linker
    set command "[get_cc] $infiles [get_implicit_link_flags] [apc_get_global APCC_LFLAGS_PLATFORM] $other_switches $outfile_str"
    exec_command_and_print $command
    return
  }

  # =============================================================
  # Whether or not any functions are targeted for hardware, a
  # bitstream is produced (prebuilt for the platform when the
  # design contains no accelerators) as well as an SD card image.
  # =============================================================
  apc_set_global APCC_PREBUILT_USED 0

  # If there are no hardware functions, assume this is a
  # software only flow and see if we can use pre-built
  # hardware if it exists
  set use_prebuilt_hardware 0
  if {[llength $accels] < 1} {
    set use_prebuilt_hardware [prebuilt_hardware_is_available]
    if { ${use_prebuilt_hardware} } {
      prebuilt_hardware_initialize $xsd_platform
    }
  }
  apc_set_global APCC_PREBUILT_USED ${use_prebuilt_hardware}

  # Create SDSoC IP repository
  create_ip_repository

  # XidanePass creates the data motion network, system description,
  # (including partition information), caller rewrite and stub
  # generation XML files.
  remove_dm_network_intermediate_files
  if { ! ${use_prebuilt_hardware} } {
    create_dm_network_and_system
    write_system_hardware_file
  }

  # Read partitions files (canned data for the prebuilt hardware platform
  # if there are no accelerators, or generated data from XidanePass)
  set partitions_file [file join ${llvm_dir} partitions.xml]
  set partitions [get_partitions $partitions_file]
  set num_partitions [get_num_partitions $partitions_file]
  set first_partition [get_first_partition $partitions_file]

  # For generated systems, perform initial processing required
  # to implement hardware.
  if { ! ${use_prebuilt_hardware} } {
    if {$perf_est} {
      # For performance estimation flows, we won't generate the
      # actual hardware, so return after reports are produced.
      run_performance_estimation $num_partitions $partitions
      if {$backup_perf_prepass} {
        set elf_temp [apc_get_global APCC_ELF_TEMP_PATH]
        if { [file exists $elf_temp] } {
          # copy the ELF to the user's location
          set elf_final [apc_get_global APCC_ELF_FINAL_PATH]
          set status [catch {file copy -force $elf_temp $elf_final} result]
          if {$status != 0} {
            MSG_ERROR $::sdsoc::msg::idSCCopyTempElf "Cannot copy temporary ELF file '$elf_temp' to final location '$elf_final' because it is being used. Ensure the file is closed and is not being used."
          }
        }
      }
      return
    }
    create_system_metadata $xdsystem $accels

    # set flags to build bitstream or not, remove old partitions and
    # create partition folders
    set partition_build_needed [checkpoint_build_flags $partitions $acc_objs_and_libs $rebuild_empty_hardware 0]
    remove_old_partitions $num_partitions
    create_partition_folders $partitions $xd_ip_database 0
  } else {
    MSG_PRINT "Using prebuilt hardware"
    set run_bitstream 0
    set partition_build_needed "0 0"
    append other_syslink_switches " " -mdev-no-swgen
    append other_syslink_switches " " -mdev-no-xsd
  }

  # =============================================================
  # Run system_linker to create software files
  # =============================================================

  # Previously, system_linker was called once:
  #
  # If system_linker is called only once, then flags need to be passed
  # to it controlling what it does.
  #
  # sdscc                               system_linker
  #   -mdev-no-swgen                      -mdev-no-swgen
  #
  #   -rebuild-sw-only
  #     -mno-bitstream                    [-bitstream not specified]
  #     -mdev-no-hls
  #     -mdev-no-swgen                    -mdev-no-swgen
  #     -mdev-no-llvm
  #     -mdev-no-xsd                      -mdev-no-xsd
  #     -apm                              -apm <dmclkid>
  # For EA, system_linker is called twice:
  # 1. system_linker -software-only (with $dev_run_swgen)
  #    create portinfo files
  # 2. create the ELF file
  # 3. system_linker (-bitstream, -boot-files)
  #    create bitstream and sd_card

  cd_command ${run_dir}
  set sl_verbose [expr {$verbose ? "-v" : ""}]
    append other_syslink_switches " " -trace-buffer " " $trace_depth

    if {$insert_apm} {
	append other_syslink_switches " " -apm
    }
    if {$insert_trace_hw} {
	append other_syslink_switches " " -trace
    }
    if {$trace_axilite} {
	append other_syslink_switches " " -trace-axilite
    }
    if {$disable_multi_clks == 1} {
	append other_syslink_switches " " -disable-multi-clks
    }

    foreach {part_num part_name} $partitions {
	set part_dir [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num}]
	set part_xsd_dir [file join $part_dir [apc_get_global APCC_DIR_SDS_PART_XSD]]
	set part_ipi_dir [file join $part_dir [apc_get_global APCC_DIR_SDS_PART_IPI]]
	
	file mkdir $part_xsd_dir
	
	set cf_sys_file [file join ${llvm_dir} $part_name]
	
	# system_linker expects certain files to be located in the -cf-output-dir. Hence it
	# is not really an output directory, but a working directory
	
	# For now copy files to make system_linker/cf_xsd happy
	copy_file_force $xd_ip_database $part_xsd_dir
	
	set build_needed [dict get $partition_build_needed $part_num]

	# co-simulation options
        set emulation_export_options ""
        if {$run_emulation_export} {
           set emulation_export_options "-emulation $emulation_mode -elf [apc_get_global APCC_ELF_FINAL_PATH]"
        }

        set synth_strategy [apc_get_global APCC_SYNTH_STRATEGY]
        set synth_strategy_default [apc_get_global APCC_SYNTH_STRATEGY_DEFAULT]
        if {! [string equal -nocase $synth_strategy $synth_strategy_default] } {
          append other_syslink_switches " " -synth-strategy " " $synth_strategy
        }

        set impl_strategy [apc_get_global APCC_IMPL_STRATEGY]
        set impl_strategy_default [apc_get_global APCC_IMPL_STRATEGY_DEFAULT]
        if {! [string equal -nocase $impl_strategy $impl_strategy_default] } {
          append other_syslink_switches " " -impl-strategy " " $impl_strategy
        }
	
	if {($dev_run_swgen && ! ${use_prebuilt_hardware} && $build_needed) 
            || $run_emulation_export} {
	    MSG_PRINT "Creating block diagram (BD), address map, port information and device registration for partition $part_num (this may take a few minutes)"
	    set command "[::sdsoc::utils::getCommandPath system_linker] -cf-input $cf_sys_file -cf-output-dir [file join $sdscc_dir_name [apc_get_global APCC_DIR_SDS_PART]$part_num] -ip-db $xd_ip_database -ip-repo [file join ${ipi_dir} repo] [apc_get_global APCC_OPT_PLATFORM] ${xsd_platform_path}:${target_os_name} $platform_syslink_switches -software-only $sl_verbose $other_syslink_switches [apc_get_global APCC_COMPATIBILITY_OPTS] $emulation_export_options"
	    exec_command_and_print $command

		} else {
	    MSG_PRINT "Skipping block diagram (BD), address map, port information and device registration for partition $part_num"
		}

	#check if trace breadcrumbs exist
	if {[file exists [file join $sdscc_dir $llvm_dir ".swTraceMapping"]]} {
	    set found_sw_trace 1
	}
	if {[file exists [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num} [apc_get_global APCC_DIR_SDS_CFWORK] ".hwTraceMapping"]]} {
	    set found_hw_trace 1
	}
		
	#create trace dir if needed
	if { ![file exists $trace_dir] } {
	    file mkdir $trace_dir
	}
		    
	if { $found_hw_trace } {
	    trace_hardware $part_num
	} else {
	    trace_software 
	}
    }	    
    
    # =============================================================
    # Rewrite caller files and compile, if any
    # =============================================================

  if {! [apc_get_global APCC_PREBUILT_USED] } {
    MSG_PRINT "Rewrite caller functions"
  }
  cd_command ${swstubs_dir}

  # FIX : don't perform caller rewrite if the user specified
  # an option saying they modifed swstubs/<caller_source>,
  # similar to the option for stub generation (user modifies
  # the generated source)
  set caller_rewrite_count      0
  set caller_build_xml_metadata {}
  set caller_sources            {}
  set caller_objects            {}
  set caller_compiler_str       {}
  set caller_flags_str          {}
  set caller_rewrite_sources    {}
  set caller_rewrite_objects    {}
  set caller_rewrite_rules      {}
  set swstubs_sources           {}

  # read the number of files containing callers to be rewritten
  set rewrite_xml_file [file join ${llvm_dir} caller_rewrites.xml]
  set caller_rewrite_count [get_num_rewrites $rewrite_xml_file]

  if {$perf_prepass} {
      set caller_rewrite_count 0
  }
    
  # get information about caller file to be rewritten
  for {set i 0} {$i < $caller_rewrite_count} {incr i} {
    set xpath "/xd:XidanePass/xd:caller\[@xd:no='$i']/@xd:file"
    set source_file [xpath_get_value $rewrite_xml_file $xpath]
    set source_tail [file tail $source_file]
    set source_tail_root [file rootname $source_tail]

    # original source and object files
    set source_object [get_obj_file $infiles ${source_tail_root}.o]
    if {! [file exists $source_object] } {
      # try cmake default naming
      set source_object [get_obj_file $infiles ${source_tail}.o]
    }
    if {! [file exists $source_object] } {
      MSG_ERROR $::sdsoc::msg::idSCLocateObject "Unable to locate original object corresponding to caller source file $source_file."
      sdscc_on_exit 1
    }

    # metadata containing compiler arguments
    set obj_accels [extract_object_accel_list ${source_object}]
    if {[llength $obj_accels] > 0} {
      # source contains caller and callee (accelerator)
      set obj_accel [lindex $obj_accels 0]
      set xml_file [file join ${data_dir} ${obj_accel}.xml]
      set xd_tag "xd:accel"
      set xd_source "srcfile"
    } else {
      # source contains caller only
      set xml_file [file join ${data_dir} ${source_tail_root}.o.xml]
      set xd_tag "xd:source"
      set xd_source "name"
      set command "[get_objcopy] -O binary --set-section-flags .xdsdata=alloc --only-section=.xdsdata $source_object ${xml_file}"
      exec_command $command
    }
    lappend caller_build_xml_files $xml_file

    set srcname      [xpath_get_value $xml_file "xd:data/$xd_tag/@$xd_source"]
    set srcpath      [xpath_get_value $xml_file "xd:data/$xd_tag/@srcpath"]
    set compiler_str [xpath_get_value $xml_file "xd:data/$xd_tag/@compiler"]
    set flags_str    [xpath_get_value $xml_file "xd:data/$xd_tag/@flags"]
    lappend caller_sources [file join $srcpath $srcname]
    lappend caller_objects $source_object
    lappend caller_compiler_str $compiler_str
    lappend caller_flags_str $flags_str

    # rewritten caller source and object files
    lappend swstubs_sources $source_tail
    lappend caller_rewrite_sources [file join ${swstubs_dir} $source_tail]
    lappend caller_rewrite_objects [file join ${swstubs_dir} ${source_tail_root}.o]

    # rules for performing rewrite
    set xpath  "/xd:XidanePass/xd:caller\[@xd:no='$i']/@xd:rewrite"
    set rule_file [file join ${llvm_dir} [xpath_get_value $rewrite_xml_file $xpath] ]
    lappend caller_rewrite_rules $rule_file
  }

  # remove the original caller object files from the list of
  # objects used to link the ELF
  foreach obj $caller_objects {
    lobject_remove_item infiles $obj
  }

  # rewrite caller files
  if {$dev_run_llvm} {
  for {set i 0} {$i < $caller_rewrite_count} {incr i} {
    set original_source [lindex $caller_sources $i]
    set output_source [lindex $caller_rewrite_sources $i]
    set translated_source [file join [file dirname $output_source] unix_[file tail $output_source]]
    copy_file_translate_to_unix $original_source $translated_source
    set compiler_type [set_compiler_type $translated_source]
    set command "[::sdsoc::utils::getCommandPath caller_rewrite] \
      -rewrite [lindex $caller_rewrite_rules $i] \
      -o $output_source \
      $translated_source \
      -- \
      -c \
      [lindex $caller_flags_str $i] \
      [get_implicit_flags_for_clang $compiler_type 0 0]"
    exec_command_and_print $command
    delete_file $translated_source
  }
  }

  # compile rewritten caller source files
  for {set i 0} {$i < $caller_rewrite_count} {incr i} {
    MSG_PRINT "Compile caller rewrite file [lindex $caller_rewrite_sources $i]"

    set command "[get_compiler [lindex $caller_compiler_str $i]] \
      -c [lindex $caller_rewrite_sources $i] \
      [lindex $caller_flags_str $i] \
      [get_implicit_flags_for_gcc] \_str
      -o [lindex $caller_rewrite_objects $i]"
    exec_command_and_print $command

    # add the rewritten object file to the link line for the ELF
    lappend infiles [lindex $caller_rewrite_objects $i]
  }

  cd_command ${run_dir}

  # =============================================================
  # Build stub utility library
  # =============================================================

  MSG_PRINT "Prepare hardware access API functions"

  cd_command ${run_dir}

  if {$dev_run_swgen} {
    copy_file_force [file join ${llvm_dir} cf_stub.c]   ${swstubs_dir}
    copy_file_force [file join ${llvm_dir} cf_stub.h]   ${swstubs_dir}
    if { ${use_prebuilt_hardware} } {
      copy_file_force [file join ${cf_dir} portinfo.c]  ${swstubs_dir}
      copy_file_force [file join ${cf_dir} portinfo.h]  ${swstubs_dir}
    } else {
      combine_partition_portinfo $sdscc_dir [file join [apc_get_global APCC_SDCARD_MOUNT_DIRECTORY] [apc_get_global APCC_SDCARD_PARTITION_DIRECTORY]] $partitions_file
    }
  }

  # =============================================================
  # Compile the stub base objects and accelerator functions
  # =============================================================

  # create accelerator stubs
  create_accelerator_stub_functions $accels acc_ip_is_rtl acc_sources acc_pp_sources acc_source_paths acc_compiler acc_flags $swstubs_sources

  # Compile stub base code
  set dbg_stub_flag ""
  if {$debug} {
    set dbg_stub_flag -g
  }
  set fpic_flag ""
  if {$shared} {
    set fpic_flag "-fPIC"
  }
  set stubs_o [create_stub_base_library $dbg_stub_flag $fpic_flag]

  # Compile accelerator stub code
  cd_command ${swstubs_dir}
  MSG_PRINT "Compile accelerator stub functions"
  foreach accel $accels {
    set acc_file $acc_sources($accel)
    set acc_file [string map {.cl .cpp} $acc_file]
    set obj_name [file rootname $acc_sources($accel)].o

    if {$acc_ip_is_rtl($accel)} {
	set command "[get_compiler $acc_compiler($accel)] -c $acc_file $dbg_stub_flag [get_implicit_flags_for_gcc] -o $obj_name"
    } elseif {[::sdsoc::template::isTemplateFunction ${accel}]} {
      # add the location of the template source to include search path
      set templateSrcName [::sdsoc::template::getMapMangled2TemplateSource ${accel}]
      set templateIncludeOption "-I [file dirname $templateSrcName]"
      # compile generated stub for the template
      set acc_file [::sdsoc::template::getMapMangled2TemplateStub ${accel}]
      set obj_name [file rootname $acc_file].o
      set command "[get_compiler $acc_compiler($accel)] -c $acc_file $acc_flags($accel) $templateIncludeOption $dbg_stub_flag [get_implicit_flags_for_gcc] -o $obj_name"
    } else {
	set command "[get_compiler $acc_compiler($accel)] -c $acc_file $acc_flags($accel) $dbg_stub_flag [get_implicit_flags_for_gcc] -o $obj_name"
    }
    exec_command_and_print $command

    # remove callee object in original link line, add rewritten stub
    # to the command line
    lobject_remove_item infiles $obj_name

    # add the stub if it isn't already in the list of accelerators
    if {! [lobject_item_found $accels_o $obj_name] } {
      lappend accels_o [file join ${swstubs_dir} $obj_name]
    }
  }
  cd_command ${run_dir}

  # =============================================================
  # Create the application ELF
  # =============================================================

  if {$debug_xlnk} {
    set sds_library sds_lib_dbg
  } else {
    set sds_library sds_lib
  }

  # Create design-specfic static library that includes sds_lib and rewritten stub files
  cd_command ${swstubs_dir}
  set libname "lib[file rootname [file tail $outfile]].a"
  copy_file_force [file join [apc_get_global APCC_PATH_XILINX_XD] [apc_get_global APCC_SDS_SOFTWARE_DIR] lib lib${sds_library}.a] [file join $swstubs_dir $libname]
  set command "[get_ar] crs [file join $swstubs_dir $libname] $stubs_o $accels_o"
  exec_command $command
  cd_command ${run_dir}

  # swonly_o contains portinfo.o for software only designs,
  # which would not otherwise link them in from the xlnk_library. Keep
  # xlnk_library to preserve library searches for resolving references.
  # See CR 765121.
  set swonly_o {}
  if {[llength $accels] < 1 } {
    lappend swonly_o [file join ${swstubs_dir} portinfo.o]
  }

  # standalone support required
  set ldscript ""
  set pthreadlib "-lpthread"
  set salib ""
  set salib_pre ""
  set salibc ""
  set bsplib_dir ""
  if { [apc_get_global APCC_USE_STANDALONE_BSP] } {

    if {$num_partitions > 1} {
      MSG_ERROR $::sdsoc::msg::idSCBspPartitions "Standalone mode not available when using multiple partitions. Please disable one of the two."
      sdscc_on_exit 1
    }

    set bspwork_dir [file join ${swstubs_dir} standalone_bsp]
    set bspscratch_dir [file join ${swstubs_dir} standalone_bsp scratch]
    set bsplib_path "[file join ${bspwork_dir} [apc_get_global APCC_PROC_INSTANCE] lib]"
    set bsplib_file "[file join ${bsplib_path} libxil.a]"
    set bsplib_dir "-L ${bsplib_path}"

    # build the standalone BSP libxil.a
    # Use the first (and only) partition for some paths below

    set hwdef_dir [file join ${sdscc_dir} [apc_get_global APCC_DIR_SDS_PART]${first_partition} [apc_get_global APCC_DIR_SDS_PART_IPI] ${xsd_platform}.sdk]
    set hwdef_file ""
    set pf_hdffile [file join ${hwdef_dir} ${xsd_platform}.hdf]
    if {[file exists $pf_hdffile]} {
      set hwdef_file $pf_hdffile
    } else {
      foreach hdffile [glob -nocomplain -type f -directory ${hwdef_dir} *.hdf] {
        # error possible if more than one hdf exists and incorrect one is used
        set hwdef_file $hdffile
      }
    }
    if {[string length $hwdef_file] < 1} {
      MSG_ERROR $::sdsoc::msg::idSCHdfMissing "Hardware handoff file $pf_hdffile not found, unable to create board support package"
      sdscc_on_exit 1
    }

    # create HSI TCL files for BSP generation
    file mkdir ${bspwork_dir}
    file mkdir ${bspscratch_dir}
    set bsp_tcl_file [file join ${bspwork_dir} create_bsp.tcl]
    set bsp_tcl_post_file [file join ${bspwork_dir} create_bsp_post.tcl]
    set mss_local [file join ${bspwork_dir} system.mss]
    set mss_scratch [file join ${bspscratch_dir} system.mss]
    set bsp_repo [apc_get_global APCC_BSP_REPOSITORY_PATH]

    set fp_bsp_tcl [open ${bsp_tcl_file} w]
    set fp_bsp_post_tcl [open ${bsp_tcl_post_file} w]

    puts $fp_bsp_tcl "hsi::open_hw_design ${hwdef_file}"
    puts $fp_bsp_tcl "set hw_design \[hsi::current_hw_design\]"
    if {[string length $bsp_repo] > 1} {
      puts $fp_bsp_tcl "hsi::set_repo_path ${bsp_repo}"
    }
    puts $fp_bsp_tcl "hsi::generate_bsp -dir ${bspscratch_dir} -hw \$\{hw_design\} -os standalone -proc [apc_get_global APCC_PROC_INSTANCE]"
    puts $fp_bsp_tcl "quit"
    close $fp_bsp_tcl

    puts $fp_bsp_post_tcl "hsi::open_hw_design ${hwdef_file}"
    puts $fp_bsp_post_tcl "set hw_design \[hsi::current_hw_design\]"
    if {[string length $bsp_repo] > 1} {
      puts $fp_bsp_post_tcl "hsi::set_repo_path ${bsp_repo}"
    }
    puts $fp_bsp_post_tcl "hsi::open_sw_design ${mss_local}"
    puts $fp_bsp_post_tcl "set_property -name VALUE -value [get_compiler gcc] -objects \[hsi::get_comp_params -filter \"NAME == compiler\"\]"
    puts $fp_bsp_post_tcl "set_property -name VALUE -value [get_ar] -objects \[hsi::get_comp_params -filter \"NAME == archiver\"\]"
    set copts [apc_get_global APCC_SDS_ARCHFLAGS]
    puts $fp_bsp_post_tcl "set_property -name VALUE -value \"-O2 -c ${copts}\" -objects \[hsi::get_comp_params -filter \"NAME == compiler_flags\"\]"
    puts $fp_bsp_post_tcl "hsi::generate_bsp -dir ${bspwork_dir} -compile"
    puts $fp_bsp_post_tcl "quit"
    close $fp_bsp_post_tcl

    cd_command ${bspwork_dir}

    # Create the MSS file
    set mss_user [apc_get_global APCC_BSP_CONFIGURATION_MSS_USER]
    set mss_platform [apc_get_global APCC_BSP_CONFIGURATION_MSS]
    if {[string length $mss_user] > 1} {
      copy_file_force_writeable ${mss_user} ${mss_local}
    } elseif {[string length $mss_platform] > 1} {
      copy_file_force_writeable ${mss_platform} ${mss_local}
    } else {
      set command "[::sdsoc::utils::getCommandPath hsi] \
        -mode batch -notrace -quiet -source ${bsp_tcl_file}" 
      exec_command $command
      copy_file_force $mss_scratch $mss_local
    }

    # Add xilffs to the MSS file
    update_mss_with_xilffs [file join ${bspwork_dir} system.mss]

    # Check if the MSS has changed from the previous run
    set bsp_is_stale 0
    set mss_old ${mss_local}_prev
    if {[file exists $mss_old]} {
      if {[diff_files $mss_local $mss_old] != 0} {
        set bsp_is_stale 1
      }
    } else {
      set bsp_is_stale 1
    }
    if {! [file exists $bsplib_file]} {
      set bsp_is_stale 1
    }

    # Create the BSP
    if { $bsp_is_stale } {
      MSG_PRINT "Create board support package library"

      # Configure source, compile and build BSP
      set command "[::sdsoc::utils::getCommandPath hsi] \
        -mode batch -notrace -quiet -source ${bsp_tcl_post_file}"
      exec_command $command

      # Save the MSS file for comparison with the next run
      if {[file exists $mss_local]} {
        copy_file_force $mss_local $mss_old
      }
    }

    cd_command ${run_dir}

    set ldscript "-Wl,-T -Wl,[apc_get_global APCC_LINKER_SCRIPT]"
    set pthreadlib ""
    set salib_pre "-lxilffs -lgcc -lc -lstdc++"  
    set salib "-lxilffs -lxil -lgcc -lc"
    set salibc "-lgcc -lc"
  }

  # add platform library, if any (only FreeRTOS so far libfreertos.a)
  set oslib " "
  set lib_param [apc_get_global APCC_OS_LINKER_LIBRARY_NAME]
  if {[string length $lib_param] > 1} {
    set lib_list [split $lib_param :]
    foreach libName $lib_list {
      append oslib " -l$libName"
    }
  }

  # Link the ELF file, including tool-defined libraries

  MSG_PRINT "Link application ELF file"

  # save the ELF temporary and final file names
  # delete previous ELF created in temporary location if it exists

  set elf_temp [file join ${swstubs_dir} [file tail ${outfile}]]
  if { [file exists $elf_temp] } {
    set status [catch {file delete -force $elf_temp} result]
    if {$status != 0} {
      MSG_ERROR $::sdsoc::msg::idSCDeleteTempElf "Cannot delete temporary ELF file '$elf_temp' because it is being used. Ensure the file is closed and is not being used."
    }
  }
  apc_set_global APCC_ELF_TEMP_PATH $elf_temp

  if {$shared} {
    # Do not link against pthread when creating a shared library
    set command "[get_cc] [get_implicit_link_flags] $ldscript [apc_get_global APCC_PERF_EXTRA_OBJECT] $accels_o $infiles $stubs_o $other_switches ${bsplib_dir} [apc_get_global APCC_LFLAGS_PLATFORM] -L [file join [apc_get_global APCC_PATH_XILINX_XD] [apc_get_global APCC_SDS_SOFTWARE_DIR] lib] -L${swstubs_dir} -l${sds_library} -o [apc_get_global APCC_ELF_TEMP_PATH]"
  } else {
    set command "[get_cc] [get_implicit_link_flags] $ldscript [apc_get_global APCC_PERF_EXTRA_OBJECT] $accels_o $infiles $swonly_o $other_switches ${bsplib_dir} [apc_get_global APCC_LFLAGS_PLATFORM] -L [file join [apc_get_global APCC_PATH_XILINX_XD] [apc_get_global APCC_SDS_SOFTWARE_DIR] lib] -L${swstubs_dir} -Wl,--start-group ${salib_pre} -Wl,--end-group -Wl,--start-group ${oslib} ${salib} $pthreadlib -l${sds_library} -lxlnk_stub ${salibc} -Wl,--end-group -o [apc_get_global APCC_ELF_TEMP_PATH]"
  }
  exec_command_and_print $command

  # Strip out all sections added as a side effect of sdsoc flows
    set command "[get_objcopy] -R .xdinfo -R .xddata -R .xdasm -R .xdfcnmap -R .xdhlscore -R .xdif -R .xdparams -R .xdcore -R .xdrepo -R .xdsdata -R .xdpp [apc_get_global APCC_ELF_TEMP_PATH]"
  exec_command $command

  # Check for early termination if running internal tests
  check_dmtest_early_exit 0

  # =============================================================
  # Run system_linker to create hardware bitstream and boot files
  # =============================================================
  cd_command ${run_dir}

  set syslink_bitstream [dict create]
  foreach {part_num part_name} $partitions {
    dict set syslink_bitstream $part_num " "
  }

  set syslink_boot_files ""

  if {!$run_bitstream} {
    if {! [apc_get_global APCC_PREBUILT_USED] } {
      MSG_PRINT "Not creating bitstream due to the -mno-bitstream switch"
    }
  } else {
    MSG_PRINT "Enable generation of hardware programming files"

    foreach {part_num part_name} $partitions {
      set build_needed [dict get $partition_build_needed $part_num]
      if { $build_needed } {
        dict set syslink_bitstream $part_num "-bitstream"
      }
    }
  }
  if {$run_boot_files} {
    MSG_PRINT "Enable generation of boot files"
    set syslink_boot_files "-bit-name $bitstream -boot-files"
  } else {
    set syslink_boot_files "-bit-name $bitstream"
  }

  #MSG_PRINT "Calling system_linker"

  apc_set_global APCC_RUN_BITSTREAM ${run_bitstream}
  if {$run_bitstream || $run_boot_files || $dev_run_swgen} {

    foreach {part_num part_name} $partitions {
        
      set part_dir [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num}]
      set part_ipi_dir [file join $part_dir [apc_get_global APCC_DIR_SDS_PART_IPI]]
        
      set cf_sys_file [file join ${llvm_dir} $part_name]
        
      MSG_PRINT "Calling system_linker for partition $part_num"
        
      # Run the system_linker command
      # FIX - -ip-repo is using the pcores from the sdscc compile flows
      #       and assumes it exists
      # FIX: if using generated IP DB XML, temporarily add -ip-db <path_to_xml>
      set command "[::sdsoc::utils::getCommandPath system_linker] -cf-input $cf_sys_file -cf-output-dir [file join $sdscc_dir_name [apc_get_global APCC_DIR_SDS_PART]$part_num] -ip-db $xd_ip_database -ip-repo [file join ${ipi_dir} repo] [apc_get_global APCC_OPT_PLATFORM] ${xsd_platform_path}:${target_os_name} $platform_syslink_switches [dict get $syslink_bitstream $part_num] $syslink_boot_files $sl_verbose $other_syslink_switches -mdev-no-swgen -mdev-no-xsd [apc_get_global APCC_COMPATIBILITY_OPTS] -sd-output-dir [file join $sdscc_dir_name [apc_get_global APCC_DIR_SDS_PART]$part_num [apc_get_global APCC_DIR_SDS_PART_SDCARD]] -bit-binary -elf [apc_get_global APCC_ELF_TEMP_PATH]"
      exec_command_and_print $command
      checkpoint_hw_file $cf_sys_file
    }
    checkpoint_hw_file $partitions_file
    checkpoint_system_hardware_file
  } else {
    MSG_PRINT "Skipping system_linker"
  }

  # =============================================================
  # Assemble SD card folder
  # =============================================================

  set sd_card_folder [file join $run_dir [apc_get_global APCC_DIR_SDCARD]]
  set part_sd_card_folder [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${first_partition} [apc_get_global APCC_DIR_SDS_PART_SDCARD]]

  if {$run_boot_files} {
    if {[file isdirectory $part_sd_card_folder]} {
      if {[file isdirectory $sd_card_folder]} {
        delete_directory $sd_card_folder
      }
      copy_file_force $part_sd_card_folder $run_dir
      # CR 877781 delete files user doesn't want (.bif, .bit.bin)
      set sd_bif_file [file join $sd_card_folder boot.bif]
      if { [file exists $sd_bif_file] } {
        delete_file $sd_bif_file
      }
      set sd_bit_bin_file [file join $sd_card_folder [file tail [apc_get_global APCC_ELF_TEMP_PATH]].bit.bin]
      if { [file exists $sd_bit_bin_file] } {
        delete_file $sd_bit_bin_file
      }
    } else {
      MSG_ERROR $::sdsoc::msg::idSCLocateSdCard "Unable to locate sd_card folder created by system linker"
    }

    # Copy bin files for each partition when not in standalone mode
    if { ![apc_get_global APCC_USE_STANDALONE_BSP] } {
      set sd_sds_dir [file join ${run_dir} [apc_get_global APCC_DIR_SDCARD] [apc_get_global APCC_SDCARD_PARTITION_DIRECTORY]]
      file mkdir $sd_sds_dir
      foreach {part_num part_name} $partitions {
        set part_bin_file [file join ${sdscc_dir} [apc_get_global APCC_DIR_SDS_PART]${part_num} [apc_get_global APCC_DIR_SDS_PART_SDCARD] [file tail [apc_get_global APCC_ELF_TEMP_PATH]].bit.bin]
        set sd_card_bin_file [file join ${sd_sds_dir} _p${part_num}_.bin]
        if {[file exists $part_bin_file]} {
          copy_file_force $part_bin_file $sd_card_bin_file
        }
      }
    }
  }

  # copy the ELF file to the SD card folder if it exists
  if {[file isdirectory $sd_card_folder] &&
        [string equal -nocase $target_os_type "linux"] } {
    copy_file_force [apc_get_global APCC_ELF_TEMP_PATH] $sd_card_folder
  }

  # Copy the ELF from the temporary location to the user-expected location.
  # Do this at the end, so the ELF isn't present if sdscc failed earlier
    # (that would cause Make to think the target is up to date).
    if {! ($perf_prepass && $backup_perf_est) } {
    set elf_temp [apc_get_global APCC_ELF_TEMP_PATH]
    if { [file exists $elf_temp] } {
      # copy the ELF to the user's location
      set elf_final [apc_get_global APCC_ELF_FINAL_PATH]
      set status [catch {file copy -force $elf_temp $elf_final} result]
      if {$status != 0} {
        MSG_ERROR $::sdsoc::msg::idSCCopyElfFinal "Cannot copy temporary ELF file '$elf_temp' to final location '$elf_final' because it is being used. Ensure the file is closed and is not being used."
      }
    }
  }
}

proc sdscc_link2 {} {
  global target_os_name target_os_type toolchain compiler run_hls run_boot_files run_bitstream run_emulation_export emulation_mode
  global insert_apm insert_trace_hw insert_trace_sw num_trace_cores trace_depth debug verbose optimize_flag debug_xlnk shared
  global run_dir sdscc_dir data_dir rpt_dir trace_dir hasTrace_dir \
      hw_dir libs_dir llvm_dir swstubs_dir xsd_dir cf_dir ipi_dir pp_dir sdscc_dir_name est_dir
  global asms bitstream infiles outfile outfile_str other_switches inlibs inlibpaths
  global xsd_platform xsd_platform_path platform_hw_xml clk_id
  global dev_run_llvm dev_run_xsd
  global dev_run_swgen
  global xd_ip_database
  global other_xidanepass_switches
  global other_syslink_switches other_vpl_switches
  global perf_root perf_funcs perf_prepass
  global perf_est perf_sw_file
  global backup_perf_est backup_perf_prepass
  global partitions
  global rebuild_empty_hardware use_dsa_for_bsp
  global disable_multi_clks
  global lib_asms
  global found_hw_trace found_sw_trace trace_axilite

  set xdsystem "xdsystem"
  apc_set_global APCC_RUN_BITSTREAM ${run_bitstream}
  apc_set_global APCC_PERF_EXTRA_OBJECT ""
  apc_set_global APCC_ELF_FINAL_PATH [file normalize ${outfile}]

  # Early checks 
  set implTcl [::sdsoc::opt::getOptImplTcl]
  if {[string length $implTcl] > 0} {
    MSG_ERROR $::sdsoc::msg::idSCNoImplTclSupport "The -impl-tcl option is unsupported for DSA-based platforms and the file $implTcl cannot be used. Remove the -impl-tcl option before building the application."
    sdscc_on_exit 1
  }

  # create log file directory for Sprite, if specified
  initialize_sprite_log_directory

  # =========================================================
  # Propagate platform options to system_linker
  # =========================================================
  set platform_syslink_switches ""
  set pfm_config [apc_get_global APCC_PFM_CONFIG]
  if {[string length $pfm_config] > 0} {
    append platform_syslink_switches " -sds-sys-config $pfm_config"
  }
  set pfm_proc [apc_get_global APCC_PFM_PROC]
  if {[string length $pfm_proc] > 0} {
    append platform_syslink_switches " -sds-proc $pfm_proc"
  }

  # =========================================================
  # Start with a clean IP repository to avoid stale data
  # =========================================================
  if { $dev_run_xsd } {
    if {[file exists $xsd_dir]} {
      delete_directory $xsd_dir
    }
    file mkdir $xsd_dir
  }

  # =========================================================
  # If the IPI folder exists, decide if in this run we should
  # try to start a clean run and remove it.
  # =========================================================
  if { [file exists $ipi_dir] } {
    global run_apf_clean

    # By default, don't delete the IPI folder
    set delete_ipi_folder 0

    # If the user did not specify -mno-bitstream, it's ok to start a clean run
    if { $run_bitstream } {
      set delete_ipi_folder 1
    }

    # If the user did specify -mno-bitstream and a bitstream does not exist,
    # it's ok to start a clean run
    if { $run_bitstream == 0 && ![file exists $bitstream]} {
      set delete_ipi_folder 1
    }

    # delete IPI folder if not overridden by -mno-clean
    if { $delete_ipi_folder && $run_apf_clean } {
      MSG_PRINT [stacktrace]
      MSG_PRINT "Removing implementation files from previous run"
      delete_directory $ipi_dir

	    #     PA2: defer cleanup of p<n>/ipi, only happens if bitstream regenerated
	    #     set sl_ipi_dirs [glob -nocomplain -type d -directory ${sdscc_dir} [file join [apc_get_global APCC_DIR_SDS_PART]* [apc_get_global APCC_DIR_SDS_PART_IPI]]]
	    #     foreach dir $sl_ipi_dirs { 
	    #       delete_directory $dir
	    #     }
    }
  }

  # Create implementation folder if it doesn't exist
  file mkdir $ipi_dir

  # ========================================
  # Local variables filled in from xml files
  # ========================================
  set accels {}
  set srcfile ""
  set srcpath ""
  set compiler_str ""
  set flags_str ""
  set ip_requires_adapter 0
  set ip_is_rtl 0
  set ip_has_repo 0
  set ip_is_pfunc 0
  set is_opencl 0
  set vlnv ""
  array set acc_flags {}
  array set acc_sources {}
  array set acc_pp_sources {}
  array set acc_source_paths {}
  array set acc_compiler {}
  array set acc_clk_ids {}
  array set acc_ip_is_rtl {}
  array set acc_ip_has_repo {}
  array set acc_ip_is_pfunc {}
  set accels_o {}
  set run_xsd 0

  # bitstream build management
  # - list of accelerator objects and libraries
  # - partition bitstream build needed or not (index by partition number)
  set acc_objs_and_libs {}
  set partition_build_needed [dict create]

  # clang-processed .s files from library accelerators
  set lib_asms {}

  #set partitions [list]
  set num_partitions 0

  # Create flow directories
  file mkdir $pp_dir

  # If platform is specified on the link command, it triggers the creation
  # of a bitstream even if there are no functions in the PL
  if {[string length $xsd_platform] != 0} {
    set run_xsd 1
  }

  if { $perf_prepass } {
    stitch_perf_file_fragments
  }
   
  # Look for libraries and extract object files associated with accelerators.
  # infiles contains objects from the link command plus accelerator objects
  # (if any) from libraries and acc_objs_and_libs contains a list of these
  # libraries. Later, accelerator objects from infiles is added to
  # acc_objs_and_libs, which will be used for build state checking.
  # add libraries specified in the platform to the list of libraries.
  set lib_param [apc_get_global APCC_OS_LINKER_LIBRARY_NAME]
  if {[string length $lib_param] > 1} {
    set lib_list [split $lib_param :]
    foreach libName $lib_list {
      if {$libName ni $inlibs} {
        lappend inlibs $libName
      }
    }
  }
  lappend inlibpaths [split [apc_get_global APCC_LPATHS_PLATFORM] ;] 
  extract_library_objects infiles acc_objs_and_libs

  # Grab files from object files 
  if {[llength $infiles] > 0} {
    MSG_PRINT "Analyzing object files"
  }
    
  if {$perf_prepass} {  
    set tmpinfiles ""  
    foreach object $infiles {
      if { [file exists [file join $est_dir [file tail $object]]] } {
        lappend tmpinfiles [file join $est_dir [file tail $object]]
      } else {
        lappend tmpinfiles $object
      }
    }
    set infiles $tmpinfiles
  }
  
  if {$perf_est} {  
    set tmpinfiles ""  
    foreach object $infiles {
	if { [file exists [file join $est_dir [apc_get_global APCC_DIR_SDS_EST_ACCDATA] [file tail $object]]] } {
        lappend tmpinfiles [file join $est_dir [apc_get_global APCC_DIR_SDS_EST_ACCDATA] [file tail $object]]
      } else {
        lappend tmpinfiles $object
      }
    }
    set infiles $tmpinfiles
  }
  
  foreach object $infiles {

    puts "... $object"

    # Collect information about accelerators, if any, associated with
    # the source object, for example the accelerator count.
    set accel_id 0
    set obj_accels [extract_object_accel_list ${object}]
	# start accelerator loop
    foreach obj_accel $obj_accels {
      # Process accelerator
      set xml_file [file join ${data_dir} ${obj_accel}.xml]
      # Grab xddata from object files
      set acc_xml_ec [extract_accel_xml ${object} $accel_id ${xml_file}]

    if {$perf_prepass} {
        MSG_PRINT "Passing through file without processing (due to performance estimation flow): $object"
    } elseif { $acc_xml_ec != 0 } {
        if {$verbose} {
          puts "Passing through file without processing (no SDSoC data): $object"
        }
    } else {
      lappend acc_objs_and_libs $object

      # Grab information from xml file
      set name                [xpath_get_value $xml_file "xd:data/xd:accel/@name"]
      set platform            [xpath_get_value $xml_file "xd:data/xd:accel/@platform"]
      set compiler_str        [xpath_get_value $xml_file "xd:data/xd:accel/@compiler"]
      set srcfile             [xpath_get_value $xml_file "xd:data/xd:accel/@srcfile"]
      set srcpath             [xpath_get_value $xml_file "xd:data/xd:accel/@srcpath"]
      set flags_str           [xpath_get_value $xml_file "xd:data/xd:accel/@flags"]
      set aclk_id             [xpath_get_value $xml_file "xd:data/xd:accel/@clk_id"]
      set ip_requires_adapter [xpath_get_value $xml_file "xd:data/xd:accel/@ip_requires_adapter"]
      set ip_is_rtl           [xpath_get_value $xml_file "xd:data/xd:accel/@ip_is_rtl"]
      set ip_has_repo         [xpath_get_value $xml_file "xd:data/xd:accel/@ip_has_repo"]
      set ip_is_pfunc         [xpath_get_value $xml_file "xd:data/xd:accel/@ip_is_pfunc"]
      set vlnv                [xpath_get_value $xml_file "xd:data/xd:accel/@vlnv"]
      set is_opencl           [xpath_get_value $xml_file "xd:data/xd:accel/@is_opencl"]
      set asmfile             [xpath_get_value $xml_file "xd:data/xd:accel/@asmfile"]
      set esc_funcName        [xpath_get_value $xml_file "xd:data/xd:accel/@esc_original_name"]
      set template_source     [xpath_get_value $xml_file "xd:data/xd:accel/@template_source_file"]
      if {[string length $esc_funcName] > 0} {
        set orig_funcName [::sdsoc::template::escapedXml2OriginalName $esc_funcName]
        set mangled_funcName [::sdsoc::template::originalName2MangledName ${orig_funcName}]
      } else {
        set orig_funcName $name
        set mangled_funcName $name
      }
      ::sdsoc::template::addTemplateMap ${orig_funcName} $mangled_funcName
      if {[string length $template_source] > 0} {
        ::sdsoc::template::addTemplateSource $mangled_funcName $template_source
      }
      if {[string length $asmfile] < 1} {
        set asmfile "NA"
      }
      
      # Checks 
      if {[string length $srcfile] == 0} {
        MSG_ERROR $::sdsoc::msg::idSCCorruptObject "Corrupt object file. The xd:data description for accelerator $name is missing the srcfile attribute."
        sdscc_on_exit 1
      }

      # Resolve defaults
      if  {[string length $ip_requires_adapter] == 0} {
        set ip_requires_adapter 0
      }
      if {[string length $ip_is_rtl] == 0} {
        set ip_is_rtl 0
      }
      if {[string length $ip_has_repo] == 0} {
        set ip_has_repo 0
      }
      if {[string length $ip_is_pfunc] == 0} {
        set ip_is_pfunc 0
      }
      if {[string length $aclk_id] == 0} {
        set aclk_id [get_default_clock_id]
      }
      if {[string length $compiler_str] == 0} {
        if { [is_cpp_source $srcfile] } {
          set compiler_str g++
        } else {
          set compiler_str gcc
        }
      }

      lappend accels $name

      if { $verbose } {
        puts "NAME: $name"
        puts "SRCFILE: $srcfile"
        puts "SRCPATH: $srcpath"
        puts "COMPILER: $compiler_str"
        puts "FLAGS: $flags_str"
      }

      set acc_compiler($name) $compiler_str
      set acc_flags($name)  $flags_str
      set acc_sources($name) $srcfile
      set acc_source_paths($name) $srcpath
      set acc_clk_ids($name) $aclk_id
      set acc_ip_requires_adapter($name) $ip_requires_adapter
      set acc_ip_is_rtl($name) $ip_is_rtl
      set acc_ip_has_repo($name) $ip_has_repo
      set acc_ip_is_pfunc($name) $ip_is_pfunc

      if {$ip_is_rtl} {
        set vlnv_list [split $vlnv ":"]
        set ip_name [lindex $vlnv_list 2]
      } else {
        set ip_name $name
      }

      if {[string length $platform] != 0} {
        if {[string length $xsd_platform] == 0} {
          set_xsd_platform $platform
			resolve_platform_configuration $xsd_platform 0
          set platform_hw_xml [resolve_hw_platform_file $xsd_platform]
        } else {
          if {[string compare $xsd_platform $platform]} {
            MSG_ERROR $::sdsoc::msg::idSCMismatchPlatform "Mismatch in platform names. $object was compiled for platform '$platform' using the '-hw' switch while other object files were compiled for '$xsd_platform'"
          }
        }
        # If platform is not in the object, leave xsd_platform empty for next object to resolve
      }

      set run_xsd 1

      # Extract clang .s if available for a library accelerator
      if {$accel_id < 1 && [string first ${libs_dir} ${object}] >= 0} {
        if {! [string equal $asmfile "NA"]} {
          set s_file [file join [file dirname ${object}] $asmfile]
          lappend lib_asms ${s_file}
          set command "[get_objcopy] -O binary --set-section-flags .xdasm=alloc --only-section=.xdasm ${object} ${s_file}"
          exec_command $command
        }
      }

      # Grab preprocessed file
      if {$accel_id < 1 && !$is_opencl} {
        if {[string equal $compiler_str "gcc"]} {
          set pp_ext "i"
        } else {
          set pp_ext "ii"
        }
        set pp_file [file join ${pp_dir} [file rootname [file tail ${srcfile}]].${pp_ext}]
        set acc_pp_sources($name) $pp_file
        set command "[get_objcopy] -O binary --set-section-flags .xdpp=alloc --only-section=.xdpp ${object} ${pp_file}"
        exec_command $command
      }

      # Grab fcnmap.xml file
      set fcnmap_file [file join ${xsd_dir} ${ip_name}.${name}.fcnmap.xml]
      set section_name [accel_section_name ".xdfcnmap" $accel_id]
      set command "[get_objcopy] -O binary --set-section-flags ${section_name}=alloc --only-section=${section_name} ${object} ${fcnmap_file}"
      exec_command $command

      # Change fcnmap.xml clock ID if overridden by the user
      set aclkId [::sdsoc::opt::getOptAclkId $name]
      if {$ip_is_rtl && $aclkId >= 0 && [clock_exists $aclkId]} {
        change_fcnmap_clock ${fcnmap_file} $aclkId
      }

      if {!$ip_is_rtl} {
        # Grab HLS core zip file
        set ipi_core_dir [file join $ipi_dir repo xilinx_com_hls_${name}_1_0]
        file mkdir $ipi_core_dir
        set core_zip [file join $ipi_core_dir xilinx_com_hls_${name}_1_0.zip]
        set section_name [accel_section_name ".xdhlscore" $accel_id]
        set command "[get_objcopy] -O binary --set-section-flags ${section_name}=alloc --only-section=${section_name} ${object} ${core_zip}"
        exec_command $command
        
        # Extract core zip file
        set command "[::sdsoc::utils::getCommandPath unzip] -u -o $core_zip -d $ipi_core_dir"
        exec_command $command
      } else {
        # Grab params.xml file
        set params_file [file join ${xsd_dir} ${ip_name}.params.xml]
        set section_name [accel_section_name ".xdparams" $accel_id]
        set command "[get_objcopy] -O binary --set-section-flags ${section_name}=alloc --only-section=${section_name} ${object} ${params_file}"
        exec_command $command

        # Grab IP core zip file
        regsub -all {(\.|\:)} $vlnv  "_" vlnv_under
        if {$ip_is_pfunc} {
          set ipi_repo_dir [file join $ipi_dir .repo_pfunc]
          set ipi_core_dir [file join ${ipi_repo_dir} ${vlnv_under}]
        } else {
          set ipi_repo_dir [file join $ipi_dir repo]
          set ipi_core_dir [file join ${ipi_repo_dir} ${vlnv_under}]
        }
        file mkdir $ipi_core_dir
        set core_zip [file join $ipi_core_dir ${vlnv_under}.zip]
        set section_name [accel_section_name ".xdcore" $accel_id]
        set command "[get_objcopy] -O binary --set-section-flags ${section_name}=alloc --only-section=${section_name} ${object} ${core_zip}"
        exec_command $command
        
        # Extract core zip file
        set command "[::sdsoc::utils::getCommandPath unzip] \
          -u -o $core_zip -d $ipi_core_dir"
        exec_command $command

        # Extract core IP repo zip file (if it exists), and add the
        # repo as a vpl --iprepo option
        if { $ip_has_repo } {
          set core_repo_dir [file join ${ipi_repo_dir}_lib ${vlnv_under}_repo]
          set core_repo_zip [file join ${core_repo_dir} ${vlnv_under}_repo.zip]
          file mkdir $core_repo_dir
          set section_name [accel_section_name ".xdrepo" $accel_id]
          set command "[get_objcopy] -O binary --set-section-flags ${section_name}=alloc --only-section=${section_name} ${object} ${core_repo_zip}"
          exec_command $command
          set command "[::sdsoc::utils::getCommandPath unzip] \
            -u -o $core_repo_zip -d $core_repo_dir"
          exec_command $command
          ::sdsoc::opt::setOptIpRepo ${core_repo_dir}
        }
      }

	set ip_requires_adapter [check_rtl_ip_requires_adapter $fcnmap_file]
      if {$ip_requires_adapter} {
	  set xdif_file [file join $xsd_dir ${ip_name}_if.xml]
        set section_name [accel_section_name ".xdif" $accel_id]
        set command "[get_objcopy] -O binary --set-section-flags ${section_name}=alloc --only-section=${section_name} ${object} ${xdif_file}"
        exec_command $command
      }

      # Workaround to remove FREQ_HZ
      set xsl_file [file join [apc_get_global APCC_PATH_XILINX_XD] scripts xsd rm_freq_hz.xsl]
      set xml_file [file join $ipi_core_dir component.xml]
      set temp_xml_file [file join $ipi_core_dir temp_component.xml]
      copy_file_force $xml_file $temp_xml_file
      delete_file $xml_file
      set command "[::sdsoc::utils::getCommandPath xsltproc] \
        -o $xml_file $xsl_file $temp_xml_file"
      #if { $verbose } {
      #  puts "Removing FREQ_HZ from $xml_file"
      #  puts $command
      #}
      regsub -all {\[} $command "\\\[" escaped_command
      catch { eval exec $escaped_command 2>@ stderr } result
      #puts "DELETING $xml_file"
      #delete_file $xml_file
      #copy_file_force $new_xml_file $xml_file
    }
      incr accel_id
    }
	# end accelerator loop

  }

  # Check -ac options if used
  check_ac_override_options $accels acc_ip_is_rtl

  # Create Vivado HLS testbench TCL files for cosimulation
  global debug_hls
  if {$debug_hls && [llength $accels] > 0} {
    foreach accel $accels {
      write_hls_tb_tcl_file $accel $infiles
    }
  }

  # Create empty repo directory if there is none, keeps system_linker quiet
  set ip_repo_dir [file join $ipi_dir repo]
  if {! [file exists $ip_repo_dir]} {
    file mkdir $ip_repo_dir
  }

  # Resolve clk_id if not given
  if {[string length $clk_id] == 0} {
    set clk_id [get_default_clock_id]
  }

  # Check clock IDs. Multiple clock systems are not supported in
  # the Public Access 1 release due to a bug in the axis_accelerator_adapter,
  # which should be fixed in the 2015.1 release. The clock IDs for
  # accelerators and the data motion network need to be the same.
  if {[llength $accels] > 0} {
    foreach accel $accels {
      set aclk_id $acc_clk_ids($accel)
      if {$aclk_id != $clk_id && $disable_multi_clks != 0} {
        MSG_ERROR $::sdsoc::msg::idSCMultiClock "Multiple clock systems are not supported, use the same clock ID for accelerators (-clkid options) and data motion network (-dmclkid option); specify all clocks if the default is not used. Data motion network uses clock ID $clk_id, accelerator $accel uses clock ID $aclk_id."
        sdscc_on_exit 1
      }
    }
  }

  # =============================================================
  # If building a software-only application with no hardware
  # platform specified, call the compiler toolchain to link the
  # ELF and return. There is no bitstream or SD card image.
  # =============================================================
  if {! $run_xsd} {
    MSG_PRINT "Link application ELF file"
    # Call ARM Linker
    set command "[get_cc] $infiles [get_implicit_link_flags] [apc_get_global APCC_LFLAGS_PLATFORM] $other_switches $outfile_str"
    exec_command_and_print $command
    return
  }

  # =============================================================
  # Whether or not any functions are targeted for hardware, a
  # bitstream is produced (prebuilt for the platform when the
  # design contains no accelerators) as well as an SD card image.
  # =============================================================
  apc_set_global APCC_PREBUILT_USED 0

  # If there are no hardware functions, assume this is a
  # software only flow and see if we can use pre-built
  # hardware if it exists
  set use_prebuilt_hardware 0
  if {[llength $accels] < 1} {
    set use_prebuilt_hardware [prebuilt_hardware_is_available]
    if { ${use_prebuilt_hardware} } {
      prebuilt_hardware_initialize $xsd_platform
    }
  }
  apc_set_global APCC_PREBUILT_USED ${use_prebuilt_hardware}

  # Create SDSoC IP repository
  create_ip_repository

  # XidanePass creates the data motion network, system description,
  # (including partition information), caller rewrite and stub
  # generation XML files.
  remove_dm_network_intermediate_files
  if { ! ${use_prebuilt_hardware} } {
    create_dm_network_and_system
    write_system_hardware_file
  }

  # Read partitions files (canned data for the prebuilt hardware platform
  # if there are no accelerators, or generated data from XidanePass)
  set partitions_file [file join ${llvm_dir} partitions.xml]
  set partitions [get_partitions $partitions_file]
  set num_partitions [get_num_partitions $partitions_file]
  set first_partition [get_first_partition $partitions_file]

  # For generated systems, perform initial processing required
  # to implement hardware.
  if { ! ${use_prebuilt_hardware} } {
    if {$perf_est} {
      # For performance estimation flows, we won't generate the
      # actual hardware, so return after reports are produced.
      run_performance_estimation $num_partitions $partitions
      if {$backup_perf_prepass} {
        set elf_temp [apc_get_global APCC_ELF_TEMP_PATH]
        if { [file exists $elf_temp] } {
          # copy the ELF to the user's location
          set elf_final [apc_get_global APCC_ELF_FINAL_PATH]
          set status [catch {file copy -force $elf_temp $elf_final} result]
          if {$status != 0} {
            MSG_ERROR $::sdsoc::msg::idSCCopyTempElf "Cannot copy temporary ELF file '$elf_temp' to final location '$elf_final' because it is being used. Ensure the file is closed and is not being used."
          }
        }
      }
      return
    }
    create_system_metadata $xdsystem $accels

    # set flags to build bitstream or not, remove old partitions and
    # create partition folders
    set partition_build_needed [checkpoint_build_flags $partitions $acc_objs_and_libs $rebuild_empty_hardware 1]
    remove_old_partitions $num_partitions
    create_partition_folders $partitions $xd_ip_database 1
  } else {
    MSG_PRINT "Using prebuilt hardware"
    set run_bitstream 0
    set partition_build_needed "0 0"
    append other_syslink_switches " " -mdev-no-swgen
    append other_syslink_switches " " -mdev-no-xsd
  }

  # =============================================================
  # Run system_linker to create software files
  # =============================================================

  # Previously, system_linker was called once:
  #
  # If system_linker is called only once, then flags need to be passed
  # to it controlling what it does.
  #
  # sdscc                               system_linker
  #   -mdev-no-swgen                      -mdev-no-swgen
  #
  #   -rebuild-sw-only
  #     -mno-bitstream                    [-bitstream not specified]
  #     -mdev-no-hls
  #     -mdev-no-swgen                    -mdev-no-swgen
  #     -mdev-no-llvm
  #     -mdev-no-xsd                      -mdev-no-xsd
  #     -apm                              -apm <dmclkid>
  # For EA, system_linker is called twice:
  # 1. system_linker -software-only (with $dev_run_swgen)
  #    create portinfo files
  # 2. create the ELF file
  # 3. system_linker (-bitstream, -boot-files)
  #    create bitstream and sd_card

  cd_command ${run_dir}
  set sl_verbose [expr {$verbose ? "-v" : ""}]

    append other_syslink_switches " " -trace-buffer " " $trace_depth

    if {$insert_apm} {
	append other_syslink_switches " " -apm
    }
    if {$insert_trace_hw} {
	append other_syslink_switches " " -trace
    }
    if {$trace_axilite} {
	append other_syslink_switches " " -trace-axilite
    }
    if {$disable_multi_clks == 1} {
	append other_syslink_switches " " -disable-multi-clks
    }
    foreach {part_num part_name} $partitions {
	
	set part_dir [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num}]
	set part_xsd_dir [file join $part_dir [apc_get_global APCC_DIR_SDS_PART_XSD]]
	set part_ipi_dir [file join $part_dir [apc_get_global APCC_DIR_SDS_PART_IPI]]
	
	file mkdir $part_xsd_dir
	
	set cf_sys_file [file join ${llvm_dir} $part_name]
	
	# system_linker expects certain files to be located in the -cf-output-dir. Hence it
	# is not really an output directory, but a working directory
	
	# For now copy files to make system_linker/cf_xsd happy
	copy_file_force $xd_ip_database $part_xsd_dir
	
	set build_needed [dict get $partition_build_needed $part_num]

	# co-simulation options
        set emulation_export_options ""
        if {$run_emulation_export} {
           set emulation_export_options "-emulation $emulation_mode -elf [apc_get_global APCC_ELF_FINAL_PATH]"
        }

        set synth_strategy [apc_get_global APCC_SYNTH_STRATEGY]
        set synth_strategy_default [apc_get_global APCC_SYNTH_STRATEGY_DEFAULT]
        if {! [string equal -nocase $synth_strategy $synth_strategy_default] } {
          append other_syslink_switches " " -synth-strategy " " $synth_strategy
        }

        set impl_strategy [apc_get_global APCC_IMPL_STRATEGY]
        set impl_strategy_default [apc_get_global APCC_IMPL_STRATEGY_DEFAULT]
        if {! [string equal -nocase $impl_strategy $impl_strategy_default] } {
          append other_syslink_switches " " -impl-strategy " " $impl_strategy
        }
	
	if {$dev_run_swgen && ! ${use_prebuilt_hardware} && $build_needed} {
	    MSG_PRINT "Creating block diagram (BD)"
	    #set command "system_linker -cf-input $cf_sys_file -cf-output-dir [file join $sdscc_dir_name [apc_get_global APCC_DIR_SDS_PART]$part_num] -ip-db $xd_ip_database -ip-repo [file join ${ipi_dir} repo] [apc_get_global APCC_OPT_PLATFORM] ${xsd_platform_path}:${target_os_name} $platform_syslink_switches -software-only $sl_verbose $other_syslink_switches [apc_get_global APCC_COMPATIBILITY_OPTS] $emulation_export_options"


            cd_command ${part_xsd_dir}
	    set command "[::sdsoc::utils::getCommandPath sdx_link] \
                          -cf-system $cf_sys_file \
                          -cf-db  $xd_ip_database \
                          -xpfm [::sdsoc::pfmx::get_platform_xpfm_file ${xsd_platform_path}] \
                           [::sdsoc::opt::createOptionsForSdxLink]"
	    exec_command_and_print $command

            # create dummy portinfo.c for test link of ELF, with final
            # link after bitstream generation

            cd_command ${run_dir}
            set cfwork_dir [file join ${sdscc_dir_name} [apc_get_global APCC_DIR_SDS_PART]$part_num [apc_get_global APCC_DIR_SDS_PART_CFWORK]]
            file mkdir $cfwork_dir

            # dummy portinfo is created, no address_map.xml required
	    set command "[::sdsoc::utils::getCommandPath cf2sw] \
                           -i $cf_sys_file \
                           -r $xd_ip_database \
                           [::sdsoc::opt::createOptionsForCf2Sw]"
            cd_command ${cfwork_dir}
            if {$dev_run_swgen} {
	      exec_command $command
            }
            cd_command ${run_dir}

	} else {
	    MSG_PRINT "Skipping block diagram (BD), address map, port information and device registration for partition $part_num"
	}

	#check if trace breadcrumbs exist
	if {[file exists [file join $sdscc_dir $llvm_dir ".swTraceMapping"]]} {
	    set found_sw_trace 1
	}
	if {[file exists [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${first_partition} [apc_get_global APCC_DIR_SDS_CFWORK] ".hwTraceMapping"]]} {
	    set found_hw_trace 1
	}
		
	#create trace dir if needed
	if { ![file exists $trace_dir] } {
	    file mkdir $trace_dir
	}
		    
        # sdsoc_trace.tcl created after cf2sw produces valid addresses
	#if { $found_hw_trace } {
	#    trace_hardware
	#} else {
	#    trace_software
	#}
    }	    
    
    # =============================================================
    # Rewrite caller files and compile, if any
    # =============================================================

  if {! [apc_get_global APCC_PREBUILT_USED] } {
    MSG_PRINT "Rewrite caller functions"
  }
  cd_command ${swstubs_dir}

  # FIX : don't perform caller rewrite if the user specified
  # an option saying they modifed swstubs/<caller_source>,
  # similar to the option for stub generation (user modifies
  # the generated source)
  set caller_rewrite_count      0
  set caller_build_xml_metadata {}
  set caller_sources            {}
  set caller_objects            {}
  set caller_compiler_str       {}
  set caller_flags_str          {}
  set caller_rewrite_sources    {}
  set caller_rewrite_objects    {}
  set caller_rewrite_rules      {}
  set swstubs_sources           {}

  # read the number of files containing callers to be rewritten
  set rewrite_xml_file [file join ${llvm_dir} caller_rewrites.xml]
  set caller_rewrite_count [get_num_rewrites $rewrite_xml_file]

  if {$perf_prepass} {
      set caller_rewrite_count 0
  }
    
  # get information about caller file to be rewritten
  for {set i 0} {$i < $caller_rewrite_count} {incr i} {
    set xpath "/xd:XidanePass/xd:caller\[@xd:no='$i']/@xd:file"
    set source_file [xpath_get_value $rewrite_xml_file $xpath]
    set source_tail [file tail $source_file]
    set source_tail_root [file rootname $source_tail]

    # original source and object files
    set source_object [get_obj_file $infiles ${source_tail_root}.o]
    if {! [file exists $source_object] } {
      # try cmake default naming
      set source_object [get_obj_file $infiles ${source_tail}.o]
    }
    if {! [file exists $source_object] } {
      MSG_ERROR $::sdsoc::msg::idSCLocateObject "Unable to locate original object corresponding to caller source file $source_file."
      sdscc_on_exit 1
    }

    # metadata containing compiler arguments
    set obj_accels [extract_object_accel_list ${source_object}]
    if {[llength $obj_accels] > 0} {
      # source contains caller and callee (accelerator)
      set obj_accel [lindex $obj_accels 0]
      set xml_file [file join ${data_dir} ${obj_accel}.xml]
      set xd_tag "xd:accel"
      set xd_source "srcfile"
    } else {
      # source contains caller only
      set xml_file [file join ${data_dir} ${source_tail_root}.o.xml]
      set xd_tag "xd:source"
      set xd_source "name"
      set command "[get_objcopy] -O binary --set-section-flags .xdsdata=alloc --only-section=.xdsdata $source_object ${xml_file}"
      exec_command $command
    }
    lappend caller_build_xml_files $xml_file

    set srcname      [xpath_get_value $xml_file "xd:data/$xd_tag/@$xd_source"]
    set srcpath      [xpath_get_value $xml_file "xd:data/$xd_tag/@srcpath"]
    set compiler_str [xpath_get_value $xml_file "xd:data/$xd_tag/@compiler"]
    set flags_str    [xpath_get_value $xml_file "xd:data/$xd_tag/@flags"]

    lappend caller_sources [file join $srcpath $srcname]
    lappend caller_objects $source_object
    lappend caller_compiler_str $compiler_str
    lappend caller_flags_str $flags_str

    # rewritten caller source and object files. caller rewrite happens
    # before stub insertion, and swstubs_sources is a list of source
    # files where caller rewrite has occurred and the results stored
    # in swstubs. During stub insertion, search swstubs_sources for the
    # stub source file name, and if found, stub insertion uses the file
    # in swstubs instead of the original source file.
    lappend swstubs_sources $source_tail
    lappend caller_rewrite_sources [file join ${swstubs_dir} $source_tail]
    lappend caller_rewrite_objects [file join ${swstubs_dir} ${source_tail_root}.o]

    # rules for performing rewrite
    set xpath  "/xd:XidanePass/xd:caller\[@xd:no='$i']/@xd:rewrite"
    set rule_file [file join ${llvm_dir} [xpath_get_value $rewrite_xml_file $xpath] ]
    lappend caller_rewrite_rules $rule_file
  }

  # remove the original caller object files from the list of
  # objects used to link the ELF
  foreach obj $caller_objects {
    lobject_remove_item infiles $obj
  }

  # rewrite caller files
  if {$dev_run_llvm} {
  for {set i 0} {$i < $caller_rewrite_count} {incr i} {
    # path to the original source and the source in swstubs
    set original_source [lindex $caller_sources $i]
    set output_source [lindex $caller_rewrite_sources $i]

    # if the caller is found in C-callable RTL IP library,
    # use the pre-processed source extracted from the IP.
    # this is a indirect way of figuring out if the source
    # was from an RTL IP.
    set is_rtl 0
    foreach accel $accels {
      # look for RTL IP accelerators
      set is_rtl $acc_ip_is_rtl($accel)
      if {! $is_rtl} {
        continue
      }
      # if the RTL IP accelerator source file name matches the
      # source name in the caller rewrite file (for example
      # caller0.cfrewrite, then the actual source file to use was
      # extracted from the RTL IP object and we need to use that.
      # This is a preprocessed source file (extension .ii or .i) and
      # we need to get the corresponding file name of the original
      # file as well as the file type (C or C++) required to perform
      # caller rewrite. If the RTL IP has a caller, it usually has
      # a stub in the same source (by convention).
      if {[string equal $acc_sources($accel) [file tail ${original_source}]]} {
        set compiler_type [set_compiler_type $acc_sources($accel)]
        # actual source is preprocessed
        set original_source $acc_pp_sources($accel)
        # use the name of the non-preprocessed source file in swstubs
        set output_source [file join ${swstubs_dir} $acc_sources($accel)]
        lset caller_rewrite_sources $i ${output_source}
        # we found the information we want, so we're done here
        break
      }
    }

    # # hack, remove clang headers from gcc
    # MSG_PRINT [stacktrace]
    # set my_hacked_flags_str [lindex $caller_flags_str $i]
    # MSG_PRINT "The original incl_flags is $my_hacked_flags_str"
    # # removed the brackets first
    # # set my_hacked_flags_str [regsub -all {\{|\}} $my_hacked_flags_str ""]
    # # then splt it to several sub-lists
    # # set my_hacked_flags_str [regexp -all -inline {\S+} $my_hacked_flags_str]
    # set idx [lsearch $my_hacked_flags_str "*clang*"]
    # MSG_PRINT "search result idx is $idx"
    # MSG_PRINT "incl_flags have [llength $my_hacked_flags_str] sub-lement(s)"
    # set my_hacked_flags_str [lreplace $my_hacked_flags_str $idx $idx]
    # MSG_PRINT "The final incl_flags have [llength $my_hacked_flags_str] sub-element(s)"
    # # convert it back to string
    # set my_hacked_flags_str [join $my_hacked_flags_str " "]
    # MSG_PRINT "The final incl_flags is $my_hacked_flags_str"
    # # end hack

    # hack
    global ininclpaths
    MSG_PRINT "ininclpaths is $ininclpaths"
    set idx [lsearch $ininclpaths "*clang*"]
    MSG_PRINT "search result idx is $idx"
    set tmp_clang_inclpath [lindex $ininclpaths $idx]
    lappend tmp_clang_inclpath "-ID:/Xilinx/SDx/2018.1/llvm-clang/win64/llvm/lib/clang/3.9.0/include"
    MSG_PRINT "tmp_clang_inclpath is $tmp_clang_inclpath"
    # end hack

    # rewrite callers
    set translated_source [file join [file dirname $output_source] unix_[file tail $output_source]]
    copy_file_translate_to_unix $original_source $translated_source
    set compiler_type [set_compiler_type $translated_source]
    set command "[::sdsoc::utils::getCommandPath caller_rewrite] \
      -rewrite [lindex $caller_rewrite_rules $i] \
      -o $output_source \
      $translated_source \
      -- \
      -c \
      [lindex $caller_flags_str $i] \
      $tmp_clang_inclpath \
      [get_implicit_flags_for_clang $compiler_type 0 0]"
    exec_command_and_print $command
    delete_file $translated_source
  }
  }

  # compile rewritten caller source files
  for {set i 0} {$i < $caller_rewrite_count} {incr i} {
    MSG_PRINT "Compile caller rewrite file [lindex $caller_rewrite_sources $i]"

    set command "[get_compiler [lindex $caller_compiler_str $i]] \
      -c [lindex $caller_rewrite_sources $i] \
      [lindex $caller_flags_str $i] \
      [get_implicit_flags_for_gcc] \
      -o [lindex $caller_rewrite_objects $i]"
    exec_command_and_print $command

    # add the rewritten object file to the link line for the ELF
    lappend infiles [lindex $caller_rewrite_objects $i]
  }

  cd_command ${run_dir}

  # =============================================================
  # Build stub utility library
  # =============================================================

  MSG_PRINT "Prepare hardware access API functions"

  cd_command ${run_dir}

  if {$dev_run_swgen} {
    copy_file_force [file join ${llvm_dir} cf_stub.c]   ${swstubs_dir}
    copy_file_force [file join ${llvm_dir} cf_stub.h]   ${swstubs_dir}
    if { ${use_prebuilt_hardware} } {
      copy_file_force [file join ${cf_dir} portinfo.c]  ${swstubs_dir}
      copy_file_force [file join ${cf_dir} portinfo.h]  ${swstubs_dir}
    } else {
      combine_partition_portinfo $sdscc_dir [file join [apc_get_global APCC_SDCARD_MOUNT_DIRECTORY] [apc_get_global APCC_SDCARD_PARTITION_DIRECTORY]] $partitions_file
    }
  }

  # =============================================================
  # Compile the stub base objects and accelerator functions
  # =============================================================

  # create accelerator stubs
  create_accelerator_stub_functions $accels acc_ip_is_rtl acc_sources acc_pp_sources acc_source_paths acc_compiler acc_flags $swstubs_sources

  # create stub base library
  set dbg_stub_flag ""
  if {$debug} {
    set dbg_stub_flag -g
  }
  set fpic_flag ""
  if {$shared} {
    set fpic_flag "-fPIC"
  }
  set stubs_o [create_stub_base_library $dbg_stub_flag $fpic_flag]

  # Compile accelerator stub code
  cd_command ${swstubs_dir}
  MSG_PRINT "Compile accelerator stub functions"
  foreach accel $accels {
    set acc_file $acc_sources($accel)
    set acc_file [string map {.cl .cpp} $acc_file]
    set obj_name [file rootname $acc_sources($accel)].o

    if {$acc_ip_is_rtl($accel)} {
	set command "[get_compiler $acc_compiler($accel)] -c $acc_file $dbg_stub_flag [get_implicit_flags_for_gcc] -o $obj_name"
    } elseif {[::sdsoc::template::isTemplateFunction ${accel}]} {
      # add the location of the template source to include search path
      set templateSrcName [::sdsoc::template::getMapMangled2TemplateSource ${accel}]
      set templateIncludeOption "-I [file dirname $templateSrcName]"
      # compile generated stub for the template
      set acc_file [::sdsoc::template::getMapMangled2TemplateStub ${accel}]
      set obj_name [file rootname $acc_file].o
      set command "[get_compiler $acc_compiler($accel)] -c $acc_file $acc_flags($accel) $templateIncludeOption $dbg_stub_flag [get_implicit_flags_for_gcc] -o $obj_name"
    } else {
	set command "[get_compiler $acc_compiler($accel)] -c $acc_file $acc_flags($accel) $dbg_stub_flag [get_implicit_flags_for_gcc] -o $obj_name"
    }
    exec_command_and_print $command

    # remove callee object in original link line, add rewritten stub
    # to the command line
    lobject_remove_item infiles $obj_name

    # add the stub if it isn't already in the list of accelerators
    if {! [lobject_item_found $accels_o $obj_name] } {
      lappend accels_o [file join ${swstubs_dir} $obj_name]
    }
  }
  cd_command ${run_dir}

  # =============================================================
  # Initial software build using portinfo placeholder data
  # =============================================================

  # Create design-specfic static library that includes
  # sds_lib and rewritten stub files. This only has to
  # be done once even when linking the ELF twice (preliminary
  # and link with and without valid addresses, respectively).
  create_static_design_library $stubs_o $accels_o

  global run_test_link
  set bsplib_dir ""
  set buildPartitionCount 0
  if {! ${use_prebuilt_hardware} } {
    foreach {part_num part_name} $partitions {
      set build_needed [dict get $partition_build_needed $part_num]
      if {$build_needed} {
        incr buildPartitionCount
      }
    }
  }
  if {$run_test_link && $run_bitstream && $buildPartitionCount > 0} {
    set do_link 1
    set hdf_file [stage_prebuilt_hardware_hdf]
  } else {
    set do_link 0
  }
  if { [apc_get_global APCC_USE_STANDALONE_BSP] && $do_link} {
    # create BSP library if required - for now, always build until
    # a heuristic is created to avoid unnecessary builds
    set force_build 1
    # the platform needs to provide a .hdf file as part of prebuilt data
    # to enable the ELF to be built before bitstream generation
    if { [string length $hdf_file] < 1} {
      set hdf_file [file join ${run_dir} system.hdf]
    }
    # if this is a unified platform, hsi can use the .dsa for the base
    # platform if the .hdf file doesn't exist
    if {! [file exists $hdf_file] && $use_dsa_for_bsp} {
      set hdf_file [::sdsoc::pfmx::get_platform_hw_file $xsd_platform_path]
    }
    if {! [file exists $hdf_file]} {
      MSG_PRINT "Unable to create BSP for preliminary ELF link, .hdf file not found as platform data or in $hdf_file, skipping preliminary link of ELF"
      set do_link 0
    } else {
      # can't guarantee prebuilt .hdf contains DMA
      set sdsdma [get_sds_dma_library_name]
      if {[string length $sdsdma] > 0} {
        set bsplib_dir [create_bsp_library $hdf_file $num_partitions $force_build ""]
      } else {
        set do_link 0
      }
    }
  }

  # Link the ELF file, including tool-defined libraries

  if { $do_link } {
    MSG_PRINT "Preliminary link application ELF"
    link_application_elf $accels_o $stubs_o $bsplib_dir 1
  }

  # Check for early termination if running internal tests
  check_dmtest_early_exit ${use_prebuilt_hardware}

  # =============================================================
  # Run system_linker to create hardware bitstream and boot files
  # =============================================================
  cd_command ${run_dir}

  set syslink_bitstream [dict create]
  foreach {part_num part_name} $partitions {
    dict set syslink_bitstream $part_num " "
  }

  set syslink_boot_files ""

  if {!$run_bitstream} {
    if {! [apc_get_global APCC_PREBUILT_USED] } {
      MSG_PRINT "Not creating bitstream due to the -mno-bitstream switch"
    }
  } else {
    MSG_PRINT "Enable generation of hardware programming files"

    foreach {part_num part_name} $partitions {
      set build_needed [dict get $partition_build_needed $part_num]
      if { $build_needed } {
        dict set syslink_bitstream $part_num  "-bitstream"
      }
    }
  }
  if {$run_boot_files} {
    MSG_PRINT "Enable generation of boot files"
    set syslink_boot_files "-bit-name $bitstream -boot-files"
  } else {
    set syslink_boot_files "-bit-name $bitstream"
  }

  #MSG_PRINT "Calling system_linker"

  apc_set_global APCC_RUN_BITSTREAM ${run_bitstream}
  if {$run_bitstream || $run_emulation_export || $run_boot_files || $dev_run_swgen} {

    foreach {part_num part_name} $partitions {
      set build_needed [dict get $partition_build_needed $part_num]
        
      set part_dir [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num}]
      set part_xsd_dir [file join $part_dir [apc_get_global APCC_DIR_SDS_PART_XSD]]
      set part_ipi_dir [file join $part_dir [apc_get_global APCC_DIR_SDS_PART_IPI]]
        
      set cf_sys_file [file join ${llvm_dir} $part_name]
        
      # Run the system_linker command
      # FIX - -ip-repo is using the pcores from the sdscc compile flows
      #       and assumes it exists
      # FIX: if using generated IP DB XML, temporarily add -ip-db <path_to_xml>
      # set command "system_linker -cf-input $cf_sys_file -cf-output-dir [file join $sdscc_dir_name [apc_get_global APCC_DIR_SDS_PART]$part_num] -ip-db $xd_ip_database -ip-repo [file join ${ipi_dir} repo] [apc_get_global APCC_OPT_PLATFORM] ${xsd_platform_path}:${target_os_name} $platform_syslink_switches [lindex $syslink_bitstream ${part_num}] $syslink_boot_files $sl_verbose $other_syslink_switches -mdev-no-swgen -mdev-no-xsd [apc_get_global APCC_COMPATIBILITY_OPTS] -sd-output-dir [file join $sdscc_dir_name [apc_get_global APCC_DIR_SDS_PART]$part_num [apc_get_global APCC_DIR_SDS_PART_SDCARD]] -bit-binary -elf [apc_get_global APCC_ELF_TEMP_PATH]"

      # creates the following depending on options:
      #   - addressmap.xml
      #   - .hdf file
      #   - emulation files
      # also creates the following if bitstream generation is enabled:
      #   - .bit file

      # FIXME - don't use a hard-coded name
      set bdtcl [file join $part_xsd_dir top.bd.tcl]

      # create a list of accelerators because VPL wants them for reporting
      # utilization, plus miscellaneous options
      set vpl_options ""
      if {[llength $accels] < 1} {
         set vpl_options "--kernels none"
      } else {
        foreach accel $accels {
          if {[string length $vpl_options] < 1} {
             set vpl_options "--kernels "
          } else {
             append vpl_options ":"
          }
          append vpl_options $accel
        }
      }
      append vpl_options " --webtalk_flag SDSoC"
      append vpl_options " [::sdsoc::opt::createOptionsForVpl]"
      append vpl_options " ${other_vpl_switches}"

      set vpl_temp_dir [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]$part_num]
      set vpl_output_dir [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num} vpl]
      set vpl_bit_file [file join ${vpl_output_dir} system.bit]
      set vpl_addr_file [file join ${vpl_output_dir} address_map.xml]
      set vpl_target hw
      set vpl_emulation ""

      if {$run_emulation_export} {
        set vpl_target hw_emu
        set vpl_emulation "--emulation_mode $emulation_mode"
      }

      set extra_repos ""
      set repo_list [::sdsoc::opt::getOptIpRepo]
      if {[llength $repo_list] > 0} {
        foreach {repo_directory} $repo_list {
          append extra_repos " --iprepo ${repo_directory}"
        }
      }
      set command "[::sdsoc::utils::getCommandPath vpl] ${extra_repos} \
      --iprepo [file join ${ipi_dir} repo] \
      --iprepo [file join [apc_get_global APCC_PATH_XILINX_XD] data ip xilinx] \
      --platform [::sdsoc::pfmx::get_platform_xpfm_file ${xsd_platform_path}] \
      --temp_dir ${vpl_temp_dir} \
      --output_dir ${vpl_output_dir} \
      --input_file $bdtcl \
      --target ${vpl_target} ${vpl_emulation} \
      --save_temps \
      $vpl_options"

      set run_vpl 0
      if {$run_bitstream && $build_needed} {
        set run_vpl 1
      } elseif {$run_emulation_export && $build_needed} {
        set run_vpl 1
      }

      if {$run_vpl} {
        MSG_PRINT "Calling VPL"
        exec_command_and_print $command
      }

      # copy bitstream from implementation directory to .elf.bit
      if {[file exists $vpl_bit_file]} {
        copy_file_force $vpl_bit_file $bitstream
      }

      # create portinfo.c and .h files
      set cfwork_dir [file join ${sdscc_dir_name} [apc_get_global APCC_DIR_SDS_PART]$part_num [apc_get_global APCC_DIR_SDS_PART_CFWORK]]
      if {[file exists $vpl_addr_file]} {
        copy_file_force $vpl_addr_file ${cfwork_dir}
        if {$dev_run_swgen && ! ${use_prebuilt_hardware}} {
          cd_command ${cfwork_dir}
          set command "[::sdsoc::utils::getCommandPath cf2sw] \
                         -i $cf_sys_file \
                         -r $xd_ip_database \
                         -a address_map.xml \
                         [::sdsoc::opt::createOptionsForCf2Sw]"
          exec_command $command
        }
        cd_command ${run_dir}
        # sdsoc_trace.tcl created after cf2sw produces valid addresses
	if { $found_hw_trace } {
	    trace_hardware $part_num
	} else {
	    trace_software
	}
      } elseif {! $perf_est} {
        if {$run_bitstream || $run_emulation_export} {
          MSG_ERROR $::sdsoc::msg::idSCNoAddressMap "Address map file does not exist, unable to link final ELF - issue encountered in the Vivado Platform Linker?"
          sdscc_on_exit 1
        }
        if {$dev_run_swgen && ! ${use_prebuilt_hardware}} {
          MSG_WARNING $::sdsoc::msg::idSCNoAddressMapBadElf "Address map file does not exist, and the ELF may contain invalid addresses for hardware functions. You must enable bitstream generation or emulation to produce valid hardware data files used to build the final ELF."
        }
      }

      if { ${use_prebuilt_hardware} } {
        set hdf_file [stage_prebuilt_hardware_hdf]
      }
      if { [apc_get_global APCC_USE_STANDALONE_BSP] } {
        if { ${use_prebuilt_hardware} } {
          copy_file_force [file join ${cf_dir} portinfo.c]  ${swstubs_dir}
          copy_file_force [file join ${cf_dir} portinfo.h]  ${swstubs_dir}
        } else {
          combine_partition_portinfo $sdscc_dir [file join [apc_get_global APCC_SDCARD_MOUNT_DIRECTORY] [apc_get_global APCC_SDCARD_PARTITION_DIRECTORY]] $partitions_file
        }

        # rebuild libxlnk_stub.a
        set stubs_o_final [create_stub_base_library $dbg_stub_flag $fpic_flag]

        # create static library
        create_static_design_library $stubs_o_final $accels_o

        set bsplib_dir ""
        if { [apc_get_global APCC_USE_STANDALONE_BSP] } {
          # create BSP library if required - for now, always build until
          # a heuristic is created to avoid unnecessary builds
          set force_build 1
          if { ${use_prebuilt_hardware} } {
            if {[string length $hdf_file] < 1 && $use_dsa_for_bsp} {
              set hdf_file [::sdsoc::pfmx::get_platform_hw_file $xsd_platform_path]
            }
            if { [string length $hdf_file] < 1} {
              MSG_ERROR $::sdsoc::msg::idSCNoPrebuiltHdf "Prebuilt .hdf does not exist, unable to build BSP."
              sdscc_on_exit 1
            }
            set prebuilt_hdf_file ""
          } else {
            set vpl_output_dir [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${first_partition} vpl]
            set hdf_file [file join ${vpl_output_dir} system.hdf]
            set prebuilt_hdf_file [prebuilt_hardware_hdf]
            # if this is a unified platform, hsi can use the .dsa for the base
            # platform if the .hdf file doesn't exist
            if {[string length $prebuilt_hdf_file] < 1 && $use_dsa_for_bsp} {
              set prebuilt_hdf_file [::sdsoc::pfmx::get_platform_hw_file $xsd_platform_path]
            }
          }
          set bsplib_dir [create_bsp_library $hdf_file $num_partitions $force_build $prebuilt_hdf_file]
        }
        # link the ELF again (standalone only)
        MSG_PRINT "Link application ELF file"
        link_application_elf $accels_o $stubs_o_final $bsplib_dir 0
      }

      # create SD card information for the current partition
      set cfg_name [apc_get_global APCC_TOOLCHAIN_CONFIG]
      set cfg_file [file join [apc_get_global APCC_PATH_XILINX_XD] data toolchain ${cfg_name}]

      if {$run_boot_files || $run_emulation_export} {
        set imageName [apc_get_global APCC_PFM_IMAGE]
        if {[string length $imageName] > 0} {
          ::sdsoc::sdcard::setSdCardImageName $imageName
        }
        if { [catch { \
          ::sdsoc::sdcard::initializeSdCardImageWriter \
          $xsd_platform_path \
          $xsd_platform \
          [apc_get_global APCC_PFM_CONFIG] \
          $cfg_file \
          $target_os_type \
          [apc_get_global APCC_PROC_TYPE] \
          [apc_get_global APCC_BOOT_SDCARD_USER] \
          } cmsg] } {
          MSG_ERROR $::sdsoc::msg::idSCInitBootData "Error intializing boot data : $cmsg"
          sdscc_on_exit 1
        }
      }

      if {$run_boot_files && ! $run_emulation_export} {
        if { [catch { \
          ::sdsoc::sdcard::writeSdCardImage \
            [file join $sdscc_dir_name [apc_get_global APCC_DIR_SDS_PART]$part_num [apc_get_global APCC_DIR_SDS_PART_SDCARD]] \
            [file join $sdscc_dir_name [apc_get_global APCC_DIR_SDS_PART]$part_num [apc_get_global APCC_DIR_SDS_PART_SDCARD_WORK]] \
            $bitstream \
            [apc_get_global APCC_ELF_TEMP_PATH] \
          } cmsg] } {
          MSG_ERROR $::sdsoc::msg::idSCWriteSdCard "Error writing SD card data : $cmsg"
          sdscc_on_exit 1
        }
      }

      # create emulation files (mutually exclusive with bitstream generation).
      # assume ::sdsoc::sdcard::initializatSdCardImageWriter was called to
      # read boot image metadata from the software platform file.
      if {$run_emulation_export} {
        set emu_dir [file join $sdscc_dir]
        set emu_elf [apc_get_global APCC_ELF_FINAL_PATH]
        set emu_behav_dir [file join $vpl_output_dir behav xsim]
        MSG_PRINT "Creating emulation files"
        set rc [::sdsoc::emu::exportSimulationFiles $emu_dir $emu_elf $emu_behav_dir]
        if {$rc} {
          MSG_ERROR $::sdsoc::msg::idSCEmuExportSim "Error creating emulation files : [::sdsoc::emu::getErrorString]"
          sdscc_on_exit 1
        }
      }

      # create a checkpoint for hardware
      checkpoint_hw_file $cf_sys_file
    }
    checkpoint_hw_file $partitions_file
    checkpoint_system_hardware_file
  } else {
    MSG_PRINT "Skipping VPL"
  }

  # =============================================================
  # Final software build using portinfo with valid address data
  # =============================================================

  if {! [apc_get_global APCC_USE_STANDALONE_BSP] } {
    set bsplib_dir ""

    # merge portinfo.c and .h files
    if {$dev_run_swgen && ! ${use_prebuilt_hardware} } {
      combine_partition_portinfo $sdscc_dir [file join [apc_get_global APCC_SDCARD_MOUNT_DIRECTORY] [apc_get_global APCC_SDCARD_PARTITION_DIRECTORY]] $partitions_file
    }

    # rebuild libxlnk_stub.a
    set stubs_o_final [create_stub_base_library $dbg_stub_flag $fpic_flag]

    # create static library
    create_static_design_library $stubs_o_final $accels_o

    # link the ELF again
    MSG_PRINT "Link application ELF file"
    link_application_elf $accels_o $stubs_o_final $bsplib_dir 0
  }

  # =============================================================
  # Assemble SD card folder
  # =============================================================

  set sd_card_folder [file join $run_dir [apc_get_global APCC_DIR_SDCARD]]
  set part_sd_card_folder [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART][lindex [dict keys $partitions] 0] [apc_get_global APCC_DIR_SDS_PART_SDCARD]]

  if {$run_boot_files && ! $run_emulation_export} {
    if {[file isdirectory $part_sd_card_folder]} {
      if {[file isdirectory $sd_card_folder]} {
        delete_directory $sd_card_folder
      }
      copy_file_force $part_sd_card_folder $run_dir
      # CR 877781 delete files user doesn't want (.bif, .bit.bin)
      set sd_bif_file [file join $sd_card_folder boot.bif]
      if { [file exists $sd_bif_file] } {
        delete_file $sd_bif_file
      }
      set sd_bit_bin_file [file join $sd_card_folder [file tail [apc_get_global APCC_ELF_TEMP_PATH]].bit.bin]
      if { [file exists $sd_bit_bin_file] } {
        delete_file $sd_bit_bin_file
      }
      puts "SD card folder created $sd_card_folder"
    } else {
      MSG_ERROR $::sdsoc::msg::idSCLocateSdCard "Unable to locate sd_card folder $part_sd_card_folder"
    }

    # Copy bin files for each partition when not in standalone mode
    if { ![apc_get_global APCC_USE_STANDALONE_BSP] } {
      set sd_sds_dir [file join ${run_dir} [apc_get_global APCC_DIR_SDCARD] [apc_get_global APCC_SDCARD_PARTITION_DIRECTORY]]
      file mkdir $sd_sds_dir
      foreach {part_num part_name} $partitions {
        set part_bin_file [file join ${sdscc_dir} [apc_get_global APCC_DIR_SDS_PART]${part_num} [apc_get_global APCC_DIR_SDS_PART_SDCARD] [file tail [apc_get_global APCC_ELF_TEMP_PATH]].bit.bin]
        set sd_card_bin_file [file join ${sd_sds_dir} _p${part_num}_.bin]
        if {[file exists $part_bin_file]} {
          copy_file_force $part_bin_file $sd_card_bin_file
        }
      }
    }
  }

  # copy the ELF file to the SD card folder if it exists
  if {[file isdirectory $sd_card_folder] &&
        [string equal -nocase $target_os_type "linux"] } {
    copy_file_force [apc_get_global APCC_ELF_TEMP_PATH] $sd_card_folder
  }

  # Copy the ELF from the temporary location to the user-expected location.
  # Do this at the end, so the ELF isn't present if sdscc failed earlier
  # (that would cause Make to think the target is up to date).
  if {! ($perf_prepass && $backup_perf_est) } {
    set elf_temp [apc_get_global APCC_ELF_TEMP_PATH]
    if { [file exists $elf_temp] } {
      # copy the ELF to the user's location
      set elf_final [apc_get_global APCC_ELF_FINAL_PATH]
      set status [catch {file copy -force $elf_temp $elf_final} result]
      if {$status != 0} {
        MSG_ERROR $::sdsoc::msg::idSCCopyElfFinal "Cannot copy temporary ELF file '$elf_temp' to final location '$elf_final' because it is being used. Ensure the file is closed and is not being used."
      }
    }
  }
}

proc sdscc_link {} {
  global xsd_platform_path

  if {[ sdsoc::pfmx::is_unified_platform $xsd_platform_path] } {
    sdscc_link2
  } else {
    sdscc_link1
  }
}

###############################################################################
# Summary Report - general
###############################################################################

proc report_open {} {
  global fp_report sdscc_report_name

  set fp_report [open ${sdscc_report_name} w]
}

proc report_puts {report_text} {
  global fp_report

  puts $fp_report $report_text
}

proc report_close {} {
  global fp_report

  close $fp_report
}

proc report_header {} {
  global fp_report

  print_standard_header $fp_report
}

###############################################################################
# Summary Report - compile
###############################################################################

proc report_hls_synthesis_extract {} {
  set hls_synthesis_log [apc_get_global APCC_HLS_SYNTHESIS_LOG]
  if {! [file exists ${hls_synthesis_log}]} {
    return
  }
  set fp_synth [open ${hls_synthesis_log} r]
  set enable_print 0
  while {[gets $fp_synth synth_data] >= 0} {
    if {[string equal -length 8 "* Target" $synth_data]} {
      set enable_print 1
      continue
    } 
    if {$enable_print} {
      report_puts $synth_data
    }
  }
  close $fp_synth
}

proc report_hls_synthesis {} {
  set hls_synthesis_log [apc_get_global APCC_HLS_SYNTHESIS_LOG]
  if {[file exists $hls_synthesis_log]} {
  } else {
    set hls_synthesis_log "file not found : $hls_synthesis_log"
  }
  report_puts "High-Level Synthesis"
  report_puts "--------------------"
  report_puts ""
  report_puts "  Vivado HLS Report : $hls_synthesis_log"
  report_puts ""
  report_hls_synthesis_extract
}

proc report_src_compile {} {
}

proc report_generation_for_compile {} {
  # Nothing interesting to output for non-accelerator source
  # compilation runs, for now don't generate a report
  set flow_type [apc_get_global APCC_FLOW_TYPE]
  if {! [string equal -nocase $flow_type APCC_COMPILE_HLS_FLOW]} {
    return
  }
  report_open
  report_header
  report_hls_synthesis
  report_close
}

###############################################################################
# Summary Report - link
###############################################################################
# return a Vivado report file found in the folder $dir matching the
# expression $pattern, for example "<rest_of_path>/_sds/p0/ipi/zc702.run/impl_1"
# and "*_timing_summary_routed.rpt" may return the full path to
# a timing summary report file. If it fails, return the pattern used.
proc get_vivado_report {dir pattern} {
  set report_list [get_files $dir $pattern]
  if { [llength $report_list] > 0 } {
    set report_file [lindex $report_list 0]
  } else {
    set report_file [file join $dir $pattern]
  }
  return $report_file
}

proc report_timing_extract {timing_summary} {
  #set timing_summary [apc_get_global APCC_VIVADO_TIMING_SUMMARY]
  if {! [file exists ${timing_summary}]} {
    return
  }
  set fp_timing [open ${timing_summary} r]
  set enable_print 0
  while {[gets $fp_timing timing_data] >= 0} {
    if {[string equal -length 14 "Timing Summary" $timing_data]} {
      set enable_print 1
      report_puts $timing_data
      continue
    } 
    if {[string equal -length 8 "--------" $timing_data]} {
      continue
    } 
    if {[string equal -length 13 "| Intra Clock" $timing_data]} {
      set enable_print 0
      continue
    } 
    if {! $enable_print} {
      continue
    }
    if {[string equal -length 2 "| " $timing_data]} {
      report_puts [string trimleft $timing_data "| "]
    } else {
      report_puts $timing_data
    }
  }
  close $fp_timing
}

# FIX - TIMING CHECK NOT PORTABLE
proc report_timing_check {is_unified} {
  global partitions sdscc_dir xsd_platform

  if { [apc_get_global APCC_PREBUILT_USED] } {
    return
  }
  if {! [apc_get_global APCC_RUN_BITSTREAM] } {
    return
  }

  # create empty list of timing reports with violations, violation message
  set timing_violation_reports [list]
  set timing_violation_message "Timing constraints were not met in this design."
  set timing_violation_detail {
    "Review violations in the timing summary report to identify possible"
    "causes. You can try running the application, but the design is not"
    "guaranteed to work. Please refer to 'SDSoC Environment Troubleshooting'"
    "in 'UG1027 SDSoC Environment User Guide' for additional information."
    "If Vivado HLS cannot meet timing, possible solutions include:"
    "- Try a slower clock frequency for the accelerator"
    "- Modify the code to allow HLS to generate a faster implementation"
    "If Vivado cannot meet timing, possible solutions include:"
    "- Try a slower clock frequency for the accelerator or data motion network"
    "- Synthesize HLS blocks at a higher clock frequency"
    "- Optimize HLS code or add directives to improve performance"
    "- Reduce design size if resource utilization is high"
    "See also 'UG906 Vivado Design Analysis and Closure Techniques'"
    "Chapter 2 'Timing Analysis Features (understanding the timing report)'."
  }

  report_puts "-------------------"
  report_puts "Design Timing Check"
  report_puts "-------------------"

  foreach {part_num part_name} $partitions {

    #set vivado_log [apc_get_global APCC_VIVADO_LOG]
    set vivado_log [file normalize [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num} [apc_get_global APCC_DIR_SDS_PART_IPI] vivado.log]]

  if {[file exists $vivado_log]} {
  #  set timing_met [eval exec "grep \"The design .* timing requirement\" $vivado_log"]
  } else {
    set vivado_log "file not found : $vivado_log"
  #  set timing_met "No timing information available"
  }
    
    #set timing_summary [apc_get_global APCC_VIVADO_TIMING_SUMMARY]
    
    if {$is_unified} {
      set vivado_impl_folder [file normalize [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num} _vpl ipi imp imp.runs impl_1]]
    } else {
      set vivado_impl_folder [file normalize [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num} [apc_get_global APCC_DIR_SDS_PART_IPI] ${xsd_platform}.runs impl_1]]
    }
    set timing_summary [get_vivado_report $vivado_impl_folder "*_timing_summary_routed.rpt"]

  set timing_met "No timing information available"
  if {! [file exists $timing_summary]} {
    set timing_summary "file not found : $timing_summary"
  } else {
    set tfd [open $timing_summary r]
    while {[gets $tfd line] != -1} {
      if {[regexp "user specified timing" $line] > 0} {
        set timing_met $line
      }
      if {[regexp "Timing constraints are" $line] > 0} {
        set timing_met $line
      }
    }
    close $tfd
  }
  puts_command $timing_met

  report_puts ""
  report_puts "  Partition $part_num"
  report_puts "  Vivado Log     : $vivado_log"
  report_puts "  Timing Summary : $timing_summary"
  report_puts ""
  report_puts "  $timing_met"
  report_puts ""

    # save reports with timing constraints violations, flag violation
    if {[regexp "not met" $timing_met] > 0} {
      lappend timing_violation_reports "Partition $part_num : Timing summary $timing_summary"
      report_puts "  Critical Warning : $timing_violation_message"
      foreach detail $timing_violation_detail {
        report_puts "    $detail"
      }
      report_puts ""
    }

    # save reports with timing constraints violations
    report_timing_extract $timing_summary
  }

  # flag Vivado timing constraints violations to stdout, log file
  if { [llength $timing_violation_reports] > 0 } {
    foreach timing_report $timing_violation_reports {
      MSG_CRITICAL_WARNING $::sdsoc::msg::idSCTimingNotMet "Timing constraints were not met, see the report : $timing_report"
    }
    MSG_CRITICAL_WARNING $::sdsoc::msg::idSCTimingViolation "$timing_violation_message"
    foreach detail $timing_violation_detail {
      puts_command "    $detail"
    }
  }

}

proc report_utilization_extract {utilization_summary} {
  #set utilization_summary [apc_get_global APCC_VIVADO_UTILIZATION_SUMMARY]
  if {! [file exists ${utilization_summary}]} {
    return
  }
  set fp_utilization [open ${utilization_summary} r]
  set enable_print 0
  while {[gets $fp_utilization utilization_data] >= 0} {
    if {[string equal -length 18 "Utilization Design" $utilization_data]} {
      set enable_print 1
      report_puts $utilization_data
      continue
    } 
    if {! $enable_print} {
      continue
    }
    report_puts $utilization_data
  }

  close $fp_utilization
}

proc report_data_motion {} {
  global llvm_dir rpt_dir

  report_puts "-------------------"
  report_puts "Data Motion Network"
  report_puts "-------------------"
  report_puts ""
  report_puts "Data motion network report generated in ${rpt_dir}"
  set dm_report_file [file join ${rpt_dir} data_motion.csv]
  if { [file exists ${dm_report_file}] } {
    report_puts "CSV file  : ${dm_report_file}"
  }
  set dm_report_file [file join ${rpt_dir} data_motion.html]
  if { [file exists ${dm_report_file}] } {
    report_puts "HTML file : ${dm_report_file}"
  }
  report_puts ""
}

proc report_utilization {is_unified} {
  global partitions sdscc_dir xsd_platform

  report_puts "-------------------"
  report_puts "Design Utilization"
  report_puts "-------------------"

  foreach {part_num part_name} $partitions {

    #set utilization_summary [apc_get_global APCC_VIVADO_UTILIZATION_SUMMARY]
    if {$is_unified} {
      set vivado_impl_folder [file normalize [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num} _vpl ipi imp imp.runs impl_1]]
    } else {
      set vivado_impl_folder [file normalize [file join $sdscc_dir [apc_get_global APCC_DIR_SDS_PART]${part_num} [apc_get_global APCC_DIR_SDS_PART_IPI] ${xsd_platform}.runs impl_1]]
    }
    set utilization_summary [get_vivado_report $vivado_impl_folder "*_utilization_placed.rpt"]
    
  if {! [file exists $utilization_summary]} {
    set utilization_summary "file not found : $utilization_summary"
  }

  report_puts ""
    report_puts "  Partition $part_num"
  report_puts "  Utilization Summary : $utilization_summary"
  report_puts ""

    report_utilization_extract $utilization_summary 
  }
}

proc report_generation_for_link {} {
  global xsd_platform_path

  set is_unified 0
  if {[ sdsoc::pfmx::is_unified_platform $xsd_platform_path] } {
    set is_unified 1
  }
  report_open
  report_header
  report_timing_check $is_unified
  report_data_motion
  report_utilization $is_unified
  report_close
}

###############################################################################
# Platform Information
###############################################################################
proc platform_info {} {
  global xsd_platform_path
  global xsd_platform
  global verbose

  set pfm_path [::sdsoc::pfmx::get_platform_path $xsd_platform_path]
  if {[string length $pfm_path] < 1} {
  set pfm_path [::sdsoc::pfmx::get_platform_path $xsd_platform]
  }
  if {[string length $pfm_path] < 1} {
    MSG_ERROR $::sdsoc::msg::idSCPlatformInfo "Unrecongized platform '$pfm_path'.\nUse -sds-pf-list to list avialable platforms."
    return
  }

  # get hardware platform files
  set hpfm_info_xsl [apc_get_global APCC_HPFM_INFO_XSL]
  set hpfm_file [::sdsoc::pfmx::get_platform_hpfm_file $pfm_path]

  # print hardware platform information
  set command "[::sdsoc::utils::getCommandPath xsltproc] \
    --stringparam platform $xsd_platform $hpfm_info_xsl $hpfm_file"
  exec_command_and_print_simple $command

  # print general platform information
  ::sdsoc::pfmx::print_platform_info $pfm_path $verbose
}

proc platform_list {} {
  global verbose
  # list platforms
  ::sdsoc::pfmx::print_platform_list $verbose
}

###############################################################################
# Main flow
###############################################################################
if {$pf_list} {
  platform_list
} elseif {$pf_info} {
  platform_info
} elseif {$compile} {

    if {$perf_prepass} {

	set backup_accels $accels
        set backup_run_hls $run_hls
        set backup_perf_est $perf_est
        set $perf_est 0
        set accels {}
        set run_hls 0
        sdscc_compile
        report_generation_for_compile
        set perf_est $backup_perf_est
    }
    if {$perf_est} {
        if {$perf_prepass} {
            set accels $backup_accels
            set run_hls $backup_run_hls
            set perf_prepass 0
        }
        sdscc_compile
        report_generation_for_compile
    }
    if {!$perf_prepass && !$perf_est} {
        sdscc_compile
        report_generation_for_compile
    }
} else {
    if {$perf_prepass} {
        set backup_accels $accels
        set backup_run_hls $run_hls
        set backup_perf_est $perf_est        
        set perf_est 0
        set accels {}
        set run_hls 0
        sdscc_link
        set perf_est $backup_perf_est
    }
    if {$perf_est} {
        if {$perf_prepass} {
            set accels $backup_accels
            set run_hls $backup_run_hls
            set perf_prepass 0
	    set backup_perf_prepass 1
        }
        append other_xidanepass_switches " -perfest"
        set run_bitstream 0
        sdscc_link
    }
    if {!$perf_prepass && !$perf_est} {
        sdscc_link
    }
  # TO DO: confirm the following guard on generating report
  if {!$dev_run_software_only} {
    report_generation_for_link
  }
}

sdscc_on_exit 0
