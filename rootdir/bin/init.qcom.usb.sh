# Copyright (c) 2011-2016, 2018-2020 The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

on charger
    mkdir /dev/usb-ffs 0770 shell shell
    mkdir /dev/usb-ffs/adb 0770 shell shell
    mount configfs none /config
    mkdir /config/usb_gadget/g1 0770 shell shell
    mkdir /config/usb_gadget/g1/strings/0x409 0770
    write /config/usb_gadget/g1/bcdUSB 0x0200
    write /config/usb_gadget/g1/os_desc/use 1
    write /config/usb_gadget/g1/strings/0x409/serialnumber ${ro.serialno}
    write /config/usb_gadget/g1/strings/0x409/manufacturer ${ro.product.manufacturer}
    write /config/usb_gadget/g1/strings/0x409/product ${ro.product.model}
    mkdir /config/usb_gadget/g1/functions/mass_storage.0
    mkdir /config/usb_gadget/g1/functions/ffs.adb
    mkdir /config/usb_gadget/g1/configs/b.1 0770 shell shell
    mkdir /config/usb_gadget/g1/configs/b.1/strings/0x409 0770 shell shell
    write /config/usb_gadget/g1/os_desc/b_vendor_code 0x1
    write /config/usb_gadget/g1/configs/b.1/MaxPower 900
    symlink /config/usb_gadget/g1/configs/b.1 /config/usb_gadget/g1/os_desc/b.1
    mount functionfs adb /dev/usb-ffs/adb uid=2000,gid=2000
    exec u:r:vendor_qti_init_shell:s0 -- /vendor/bin/init.qcom.usb.sh
    write /config/usb_gadget/g1/strings/0x409/product ${vendor.usb.product_string}
    setprop sys.usb.configfs 1
    start dashd

on charger && property:ro.boot.type=debug
    write /dev/kmsg "debug version, ready to trigger post-fs-data"
# kartar@SYSTEM, 2020/05/08, IKR-260 Enable adb early in charger mode
    start apexd
    wait_for_prop apexd.status activated
    perform_apex_config
    setprop sys.usb.config adb
    start adbd
    write /dev/kmsg "start adbd"
    write /config/usb_gadget/g1/idVendor 0x2A70
    write /config/usb_gadget/g1/idProduct 0x4ee7
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "adb"
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f1
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}

on charger && property:ro.boot.type=sdebug
    write /dev/kmsg "sdebug version, ready to trigger post-fs-data"
# kartar@SYSTEM, 2020/05/08, IKR-260 Enable adb early in charger mode
    start apexd
    wait_for_prop apexd.status activated
    perform_apex_config
    setprop sys.usb.config adb
    start adbd
    write /dev/kmsg "start adbd"
    write /config/usb_gadget/g1/idVendor 0x2A70
    write /config/usb_gadget/g1/idProduct 0x4ee7
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "adb"
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f1
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}

on charger && property:ro.boot.type=auto
    write /dev/kmsg "ready to trigger post-fs-data"
# kartar@SYSTEM, 2020/05/08, IKR-260 Enable adb early in charger mode
    start apexd
    wait_for_prop apexd.status activated
    perform_apex_config
    setprop sys.usb.config adb
    start adbd
    write /dev/kmsg "start adbd"
    write /config/usb_gadget/g1/idVendor 0x2A70
    write /config/usb_gadget/g1/idProduct 0x4ee7
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "adb"
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f1
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}

on init
    exec u:r:vendor-qti-testscripts:s0 -- /vendor/bin/sh /vendor/bin/init.qti.usb.debug.sh

on boot
    write /sys/class/android_usb/android0/iSerial ${ro.serialno}
    mount configfs none /config
    mkdir /config/usb_gadget/g1 0770
    mkdir /config/usb_gadget/g2 0770
    mkdir /config/usb_gadget/g1/strings/0x409 0770
    mkdir /config/usb_gadget/g2/strings/0x409 0770
    write /config/usb_gadget/g1/bcdUSB 0x0200
    write /config/usb_gadget/g2/bcdUSB 0x0200
    write /config/usb_gadget/g1/os_desc/use 1
    write /config/usb_gadget/g1/strings/0x409/serialnumber ${ro.serialno}
    write /config/usb_gadget/g2/strings/0x409/serialnumber ${ro.serialno}
    write /config/usb_gadget/g1/strings/0x409/manufacturer ${ro.product.manufacturer}
    write /config/usb_gadget/g2/strings/0x409/manufacturer ${ro.product.manufacturer}
    mkdir /config/usb_gadget/g1/functions/mass_storage.0
    mkdir /config/usb_gadget/g1/functions/mtp.gs0
    mkdir /config/usb_gadget/g1/functions/ptp.gs1
    mkdir /config/usb_gadget/g1/functions/accessory.gs2
    mkdir /config/usb_gadget/g1/functions/audio_source.gs3
    mkdir /config/usb_gadget/g1/functions/midi.gs5
    mkdir /config/usb_gadget/g1/functions/ffs.adb
    mkdir /config/usb_gadget/g1/functions/ffs.diag
    mkdir /config/usb_gadget/g1/functions/ffs.diag_mdm
    mkdir /config/usb_gadget/g1/functions/ffs.diag_mdm2
    mkdir /config/usb_gadget/g1/functions/diag.diag
    mkdir /config/usb_gadget/g1/functions/diag.diag_mdm
    mkdir /config/usb_gadget/g1/functions/diag.diag_mdm2
    mkdir /config/usb_gadget/g1/functions/cser.dun.0
    mkdir /config/usb_gadget/g1/functions/cser.nmea.1
    mkdir /config/usb_gadget/g1/functions/cser.dun.2
    mkdir /config/usb_gadget/g1/functions/gsi.rmnet
    mkdir /config/usb_gadget/g1/functions/gsi.rndis
    mkdir /config/usb_gadget/g1/functions/gsi.dpl
    mkdir /config/usb_gadget/g1/functions/qdss.qdss
    mkdir /config/usb_gadget/g1/functions/qdss.qdss_mdm
    mkdir /config/usb_gadget/g1/functions/rndis_bam.rndis
    mkdir /config/usb_gadget/g1/functions/rndis.rndis
    mkdir /config/usb_gadget/g1/functions/rmnet_bam.rmnet
    mkdir /config/usb_gadget/g1/functions/rmnet_bam.dpl
    mkdir /config/usb_gadget/g1/functions/rmnet_bam.rmnet_bam_dmux
    mkdir /config/usb_gadget/g1/functions/rmnet_bam.dpl_bam_dmux
    mkdir /config/usb_gadget/g1/functions/ncm.0
    mkdir /config/usb_gadget/g1/functions/ccid.ccid
    mkdir /config/usb_gadget/g1/functions/uac2.0
    mkdir /config/usb_gadget/g1/functions/uvc.0
    mkdir /config/usb_gadget/g1/configs/b.1 0770
    mkdir /config/usb_gadget/g2/configs/b.1 0770
    mkdir /config/usb_gadget/g1/configs/b.1/strings/0x409 0770
    mkdir /config/usb_gadget/g2/configs/b.1/strings/0x409 0770
    write /config/usb_gadget/g1/configs/b.1/MaxPower 900
    write /config/usb_gadget/g1/os_desc/b_vendor_code 0x1
    write /config/usb_gadget/g1/os_desc/qw_sign "MSFT100"
    write /config/usb_gadget/g1/functions/diag.diag/serial ${ro.serialno}
    symlink /config/usb_gadget/g1/configs/b.1 /config/usb_gadget/g1/os_desc/b.1
    mkdir /dev/usb-ffs 0775 shell system
    mkdir /dev/usb-ffs/adb 0770 shell system
    mount functionfs adb /dev/usb-ffs/adb uid=2000,gid=1000,rmode=0770,fmode=0660
    mkdir /dev/ffs-diag 0770 shell system
    mount functionfs diag /dev/ffs-diag uid=2000,gid=1000,rmode=0770,fmode=0660,no_disconnect=1
    mkdir /dev/ffs-diag-1 0770 shell system
    mount functionfs diag_mdm /dev/ffs-diag-1 uid=2000,gid=1000,rmode=0770,fmode=0660,no_disconnect=1
    mkdir /dev/ffs-diag-2 0770 shell system
    mount functionfs diag_mdm2 /dev/ffs-diag-2 uid=2000,gid=1000,rmode=0770,fmode=0660,no_disconnect=1
    setprop sys.usb.mtp.device_type 3
    setprop vendor.usb.controller ${sys.usb.controller}
    exec u:r:vendor_qti_init_shell:s0 -- /vendor/bin/init.qcom.usb.sh
    write /config/usb_gadget/g1/strings/0x409/product ${vendor.usb.product_string}
    write /config/usb_gadget/g2/strings/0x409/product ${vendor.usb.product_string}
    #setprop sys.usb.config ${persist.vendor.usb.config}
    setprop sys.usb.configfs 1
    write /sys/bus/platform/drivers/qti_battery_charger/bind "soc:qcom,pmic_glink:qcom,battery_charger"
    write /sys/bus/platform/drivers/ucsi_glink/bind "soc:qcom,pmic_glink:qcom,ucsi"
    # hongwei.di, remove wlchgd service in SM8150R.
    #start wlchgd

on boot && property:vendor.usb.use_ffs_mtp=1
   mkdir /config/usb_gadget/g1/functions/ffs.mtp
   mkdir /config/usb_gadget/g1/functions/ffs.ptp
   mkdir /dev/usb-ffs/mtp 0770 mtp mtp
   mount functionfs mtp /dev/usb-ffs/mtp rmode=0770,fmode=0660,uid=1024,gid=1024,no_disconnect=1
   mkdir /dev/usb-ffs/ptp 0770 mtp mtp
   mount functionfs ptp /dev/usb-ffs/ptp rmode=0770,fmode=0660,uid=1024,gid=1024,no_disconnect=1

#on property:persist.vendor.usb.config=*
#    setprop persist.sys.usb.config ${persist.vendor.usb.config}

on boot && property:ro.boot.usbconfigfs=true
        setprop sys.usb.configfs 1

#
# USB compositions
#
# Following are the triggers to configure various combinations of functions into a USB
# composition. Each correspond to a unique VID/PID.
#

on property:sys.usb.config=none && property:sys.usb.configfs=1
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9

on property:sys.usb.config=mass_storage && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "msc"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0xF000
    symlink /config/usb_gadget/g1/functions/mtp.gs0 /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/mass_storage.0 /config/usb_gadget/g1/configs/b.1/f2
    write /config/usb_gadget/g1/functions/mass_storage.0/lun.0/file "/vendor/etc/usb_drivers.iso"
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=mass_storage,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=mass_storage,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "adb_msc"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x9015
    symlink /config/usb_gadget/g1/functions/mtp.gs0 /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/mass_storage.0 /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/functions/mass_storage.0/lun.0/file "/vendor/etc/usb_drivers.iso"
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x901D
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x901d
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f2
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x900E
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x900e
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,serial_cdev,rmnet,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,serial_cdev,rmnet,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "Default composition"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x9091
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x9091
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f4
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,serial_cdev,rmnet && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "Default comp without ADB"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x9092
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x9092
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,serial_cdev,serial_cdev_nmea,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,serial_cdev,serial_cdev_nmea,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_dun_nmea_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x9020
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x9020
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/cser.nmea.1 /config/usb_gadget/g1/configs/b.1/f4
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:vendor.usb.tethering=true
    write /sys/class/net/rndis0/queues/rx-0/rps_cpus ${vendor.usb.rps_mask}

on property:sys.usb.config=rndis
    setprop sys.usb.config rndis,${persist.vendor.usb.config.extra}

on property:sys.usb.config=rndis,none && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x2A70
    write /config/usb_gadget/g1/idProduct 0xF00E
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state rndis

on property:sys.usb.config=rndis,sec && property:sys.usb.configfs=1
    write /config/usb_gadget/g2/configs/b.1/strings/0x409/configuration "rndis"
    rm /config/usb_gadget/g2/configs/b.1/f1
    write /config/usb_gadget/g2/idVendor 0x05C6
    write /config/usb_gadget/g2/idProduct 0xF00E
    symlink /config/usb_gadget/g2/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g2/configs/b.1/f1
    write /config/usb_gadget/g2/UDC ${persist.vendor.usb.controller.secondary}
    setprop sys.usb.state rndis

on property:sys.usb.config=rndis,adb
    setprop sys.usb.config rndis,${persist.vendor.usb.config.extra},adb

on property:sys.usb.config=rndis,none,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=rndis,none,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x2A70
    write /config/usb_gadget/g1/idProduct 0x9024
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f2
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state rndis,adb

on property:sys.usb.config=rndis,diag && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis_diag"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x902C
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state rndis

on property:sys.usb.config=rndis,diag,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=rndis,diag,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis_diag_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x902D
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state rndis,adb

on property:sys.usb.config=rndis,serial_cdev && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis_dun"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90B3
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f2
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state rndis

on property:sys.usb.config=rndis,serial_cdev,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=rndis,serial_cdev,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis_dun_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90B4
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state rndis,adb

on property:sys.usb.config=rndis,serial_cdev,diag && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis_dun_diag"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90B5
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f4
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config} #2018.05.28 modify for CTA/EngineerMode RNDIS test

on property:sys.usb.config=rndis,serial_cdev,diag,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=rndis,serial_cdev,diag,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis_dun_diag"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90B6
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f5
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config} #2018.02.12 modify for CTA RNDIS test

on property:sys.usb.config=mtp,diag && property:vendor.usb.use_ffs_mtp=0 && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "mtp_diag"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x901B
    symlink /config/usb_gadget/g1/functions/mtp.gs0 /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=mtp,diag && property:vendor.usb.use_ffs_mtp=1 && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "ffs-mtp_diag"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x901B
    symlink /config/usb_gadget/g1/functions/ffs.mtp /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=mtp,diag,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=mtp,diag,adb && property:vendor.usb.use_ffs_mtp=0 && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "mtp_diag_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x903A
    symlink /config/usb_gadget/g1/functions/mtp.gs0 /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=mtp,diag,adb && property:vendor.usb.use_ffs_mtp=1 && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "ffs-mtp_diag_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x903A
    symlink /config/usb_gadget/g1/functions/ffs.mtp /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,qdss && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_qdss"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x904A
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x904a
    write /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name}/enable_debug_inface 1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name} /config/usb_gadget/g1/configs/b.1/f2
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,qdss,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,qdss,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_qdss_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x9060
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x9060
    write /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name}/enable_debug_inface 1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name} /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,qdss,rmnet && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_qdss_rmnet"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x9083
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x9083
    write /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name}/enable_debug_inface 1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name} /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,qdss,rmnet,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,qdss,rmnet,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_qdss_rmnet_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x9084
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x9084
    write /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name}/enable_debug_inface 1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name} /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f4
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=rndis,diag,qdss && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis_diag_qdss"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x9081
    write /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name}/enable_debug_inface 1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name} /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=rndis,diag,qdss,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=rndis,diag,qdss,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis_diag_qdss_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x9082
    write /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name}/enable_debug_inface 1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name} /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f4
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=ncm && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "ncm"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0xA4A1
    symlink /config/usb_gadget/g1/functions/ncm.0 /config/usb_gadget/g1/configs/b.1/f1
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=ncm,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=ncm,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "ncm_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x908C
    symlink /config/usb_gadget/g1/functions/ncm.0 /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f2
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,serial_cdev && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_dun"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x9004
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x9004
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f2
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,adb,serial_cdev && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,adb,serial_cdev && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_adb_dun"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x901f
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x901f
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,serial_cdev,rmnet,dpl && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_dun_rmnet_dpl"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90b7
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90b7
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f4
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,serial_cdev,rmnet,dpl,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,serial_cdev,rmnet,dpl,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_dun_rmnet_dpl_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90b8
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90b8
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f5
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=rndis,diag,dpl && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis_diag_dpl"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90bf
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state rndis

on property:sys.usb.config=rndis,diag,dpl,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=rndis,diag,dpl,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis_diag_dpl_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90c0
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f4
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state rndis,adb

on property:sys.usb.config=ccid && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "ccid"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90CE
    symlink /config/usb_gadget/g1/functions/ccid.ccid /config/usb_gadget/g1/configs/b.1/f1
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=ccid,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=ccid,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "ccid_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90CF
    symlink /config/usb_gadget/g1/functions/ccid.ccid /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f2
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=ccid,diag && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "ccid_diag"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90D0
    symlink /config/usb_gadget/g1/functions/ccid.ccid /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=ccid,diag,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=ccid,diag,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "ccid_diag_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90D1
    symlink /config/usb_gadget/g1/functions/ccid.ccid /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,serial_cdev,rmnet,ccid && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_dun_rmnet_ccid"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90D2
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90d2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/ccid.ccid /config/usb_gadget/g1/configs/b.1/f4
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,serial_cdev,rmnet,ccid,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,serial_cdev,rmnet,ccid,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_dun_rmnet_ccid_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90D3
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90d3
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/ccid.ccid /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f5
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,diag_mdm,qdss,qdss_mdm,serial_cdev,serial_cdev_mdm,rmnet && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_diag_mdm,qdss_qdss_mdm_dun_dun_mdm_rmnet"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90D7
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90d7
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/qdss.qdss /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/qdss.qdss_mdm /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f5
    symlink /config/usb_gadget/g1/functions/cser.dun.2 /config/usb_gadget/g1/configs/b.1/f6
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f7
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,diag_mdm,qdss,qdss_mdm,serial_cdev,serial_cdev_mdm,rmnet,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,diag_mdm,qdss,qdss_mdm,serial_cdev,serial_cdev_mdm,rmnet,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_diag_mdm,qdss_qdss_mdm_dun_dun_mdm_rmnet_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90D8
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90d8
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/qdss.qdss /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/qdss.qdss_mdm /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f5
    symlink /config/usb_gadget/g1/functions/cser.dun.2 /config/usb_gadget/g1/configs/b.1/f6
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f7
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f8
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,diag_mdm,qdss,qdss_mdm,serial_cdev,serial_cdev_mdm,dpl,rmnet && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_diag_mdm,qdss_qdss_mdm_dun_dun_mdm_dpl_rmnet"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90DD
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90dd
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/qdss.qdss /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/qdss.qdss_mdm /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f5
    symlink /config/usb_gadget/g1/functions/cser.dun.2 /config/usb_gadget/g1/configs/b.1/f6
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f7
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f8
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,diag_mdm,qdss,qdss_mdm,serial_cdev,serial_cdev_mdm,dpl,rmnet,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,diag_mdm,qdss,qdss_mdm,serial_cdev,serial_cdev_mdm,dpl,rmnet,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_diag_mdm,qdss_qdss_mdm_dun_dun_mdm_dpl_rmnet_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90DE
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90de
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/qdss.qdss /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/qdss.qdss_mdm /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f5
    symlink /config/usb_gadget/g1/functions/cser.dun.2 /config/usb_gadget/g1/configs/b.1/f6
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f7
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f8
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,serial_cdev,rmnet,dpl,qdss && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_dun_rmnet_dpl_qdss"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90DC
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90dc
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name} /config/usb_gadget/g1/configs/b.1/f5
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,serial_cdev,rmnet,dpl,qdss,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,serial_cdev,rmnet,dpl,qdss,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_dun_rmnet_dpl_qdss_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90DB
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90db
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name} /config/usb_gadget/g1/configs/b.1/f5
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f6
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,uac2,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,uac2,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_uac2_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90CA
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90ca
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/uac2.0 /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,uac2 && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_uac2"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x901C
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x901c
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/uac2.0 /config/usb_gadget/g1/configs/b.1/f2
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,uvc,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,uvc,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_uvc_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90CB
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90cb
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/uvc.0 /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,uvc && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_uvc"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90DF
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90df
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/uvc.0 /config/usb_gadget/g1/configs/b.1/f2
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,uac2,uvc,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,uac2,uvc,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_uac2_uvc_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90CC
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90cc
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/uac2.0 /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/uvc.0 /config/usb_gadget/g1/configs/b.1/f4
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,uac2,uvc && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_uac2_uvc"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90E0
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90e0
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/uac2.0 /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/uvc.0 /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,diag_mdm,qdss,qdss_mdm,serial_cdev,dpl,rmnet && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_diag_mdm_qdss_qdss_mdm_dun_dpl_rmnet"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90E4
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90e4
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/qdss.qdss /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/qdss.qdss_mdm /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f5
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f6
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f7
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,diag_mdm,qdss,qdss_mdm,serial_cdev,dpl,rmnet,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,diag_mdm,qdss,qdss_mdm,serial_cdev,dpl,rmnet,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_diag_mdm_qdss_qdss_mdm_dun_dpl_rmnet_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90E5
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90e5
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/qdss.qdss /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/qdss.qdss_mdm /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f5
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f6
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f7
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f8
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=rndis,diag,diag_mdm,qdss,qdss_mdm,serial_cdev,dpl && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis_diag_diag_mdm_qdss_qdss_mdm_dun_dpl"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90E6
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/qdss.qdss /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/qdss.qdss_mdm /config/usb_gadget/g1/configs/b.1/f5
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f6
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f7
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state rndis

on property:sys.usb.config=rndis,diag,diag_mdm,qdss,qdss_mdm,serial_cdev,dpl,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=rndis,diag,diag_mdm,qdss,qdss_mdm,serial_cdev,dpl,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis_diag_diag_mdm_qdss_qdss_mdm_dun_dpl_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90E7
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/qdss.qdss /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/qdss.qdss_mdm /config/usb_gadget/g1/configs/b.1/f5
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f6
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f7
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f8
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state rndis,adb

on property:sys.usb.config=diag,diag_mdm,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,diag_mdm,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_diag_mdm_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90D9
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90d9
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,diag_mdm,diag_mdm2,qdss,qdss_mdm,serial_cdev,dpl,rmnet && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_diag_mdm_diag_mdm2_qdss_qdss_mdm_dun_dpl_rmnet"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90F6
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90f6
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm2 /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/qdss.qdss /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/qdss.qdss_mdm /config/usb_gadget/g1/configs/b.1/f5
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f6
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f7
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f8
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,diag_mdm,diag_mdm2,qdss,qdss_mdm,serial_cdev,dpl,rmnet,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,diag_mdm,diag_mdm2,qdss,qdss_mdm,serial_cdev,dpl,rmnet,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_diag_mdm_diag_mdm2_qdss_qdss_mdm_dun_dpl_rmnet_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90F7
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x90f7
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm2 /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/qdss.qdss /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/qdss.qdss_mdm /config/usb_gadget/g1/configs/b.1/f5
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f6
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f7
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f8
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=rndis,diag,diag_mdm,diag_mdm2,qdss,qdss_mdm,serial_cdev,dpl && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis_diag_diag_mdm_diag_mdm2_qdss_qdss_mdm_dun_dpl"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90F8
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm2 /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/qdss.qdss /config/usb_gadget/g1/configs/b.1/f5
    symlink /config/usb_gadget/g1/functions/qdss.qdss_mdm /config/usb_gadget/g1/configs/b.1/f6
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f7
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f8
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state rndis

on property:sys.usb.config=rndis,diag,diag_mdm,diag_mdm2,qdss,qdss_mdm,serial_cdev,dpl,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=rndis,diag,diag_mdm,diag_mdm2,qdss,qdss_mdm,serial_cdev,dpl,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "rndis_diag_diag_mdm_diag_mdm2_qdss_qdss_mdm_dun_dpl_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x90F9
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rndis.func.name}.rndis /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm2 /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/qdss.qdss /config/usb_gadget/g1/configs/b.1/f5
    symlink /config/usb_gadget/g1/functions/qdss.qdss_mdm /config/usb_gadget/g1/configs/b.1/f6
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f7
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f8
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state rndis,adb

on property:sys.usb.config=diag,diag_mdm,ccid && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_diag_mdm_ccid"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x9045
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x9045
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/ccid.ccid /config/usb_gadget/g1/configs/b.1/f3
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,diag_mdm,adb,ccid && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,diag_mdm,adb,ccid && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_diag_mdm_adb_ccid"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x9044
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x9044
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/ccid.ccid /config/usb_gadget/g1/configs/b.1/f4
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,diag_cnss,serial_cdev,rmnet,dpl,qdss,adb && property:sys.usb.configfs=1
    start adbd

on property:sys.usb.ffs.ready=1 && property:sys.usb.config=diag,diag_cnss,serial_cdev,rmnet,dpl,qdss,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_diag_cnss_dun_rmnet_dpl_qdss_adb"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x9110
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x9110
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm2 /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f5
    symlink /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name} /config/usb_gadget/g1/configs/b.1/f6
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f7
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=diag,diag_cnss,serial_cdev,rmnet,dpl,qdss && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/configs/b.1/strings/0x409/configuration "diag_diag_cnss_dun_rmnet_dpl_qdss"
    rm /config/usb_gadget/g1/configs/b.1/f1
    rm /config/usb_gadget/g1/configs/b.1/f2
    rm /config/usb_gadget/g1/configs/b.1/f3
    rm /config/usb_gadget/g1/configs/b.1/f4
    rm /config/usb_gadget/g1/configs/b.1/f5
    rm /config/usb_gadget/g1/configs/b.1/f6
    rm /config/usb_gadget/g1/configs/b.1/f7
    rm /config/usb_gadget/g1/configs/b.1/f8
    rm /config/usb_gadget/g1/configs/b.1/f9
    write /config/usb_gadget/g1/idVendor 0x05C6
    write /config/usb_gadget/g1/idProduct 0x9111
    write /config/usb_gadget/g1/functions/diag.diag/pid 0x9111
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/${vendor.usb.diag.func.name}.diag_mdm2 /config/usb_gadget/g1/configs/b.1/f2
    symlink /config/usb_gadget/g1/functions/cser.dun.0 /config/usb_gadget/g1/configs/b.1/f3
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.rmnet.inst.name} /config/usb_gadget/g1/configs/b.1/f4
    symlink /config/usb_gadget/g1/functions/${vendor.usb.rmnet.func.name}.${vendor.usb.dpl.inst.name} /config/usb_gadget/g1/configs/b.1/f5
    symlink /config/usb_gadget/g1/functions/qdss.${vendor.usb.qdss.inst.name} /config/usb_gadget/g1/configs/b.1/f6
    write /config/usb_gadget/g1/UDC ${sys.usb.controller}
    setprop sys.usb.state ${sys.usb.config}

on property:sys.usb.config=adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/idVendor 0x18d1
    write /config/usb_gadget/g1/idProduct 0x4ee7

on property:sys.usb.config=mtp && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/idVendor 0x18d1
    write /config/usb_gadget/g1/idProduct 0x4ee1

on property:sys.usb.config=mtp && property:vendor.usb.use_ffs_mtp=1 && property:sys.usb.configfs=1
    symlink /config/usb_gadget/g1/functions/ffs.mtp /config/usb_gadget/g1/configs/b.1/f1

on property:sys.usb.config=mtp,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/idVendor 0x18d1
    write /config/usb_gadget/g1/idProduct 0x4ee2

on property:sys.usb.config=mtp,adb && property:vendor.usb.use_ffs_mtp=1 && property:sys.usb.configfs=1
    symlink /config/usb_gadget/g1/functions/ffs.mtp /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f2

on property:sys.usb.config=ptp && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/idVendor 0x18d1
    write /config/usb_gadget/g1/idProduct 0x4ee5

on property:sys.usb.config=ptp && property:vendor.usb.use_ffs_mtp=1 && property:sys.usb.configfs=1
    symlink /config/usb_gadget/g1/functions/ffs.ptp /config/usb_gadget/g1/configs/b.1/f1

on property:sys.usb.config=ptp,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/idVendor 0x18d1
    write /config/usb_gadget/g1/idProduct 0x4ee6

on property:sys.usb.config=ptp,adb && property:vendor.usb.use_ffs_mtp=1 && property:sys.usb.configfs=1
    symlink /config/usb_gadget/g1/functions/ffs.ptp /config/usb_gadget/g1/configs/b.1/f1
    symlink /config/usb_gadget/g1/functions/ffs.adb /config/usb_gadget/g1/configs/b.1/f2

on property:sys.usb.config=accessory && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/idVendor 0x18d1
    write /config/usb_gadget/g1/idProduct 0x2d00

on property:sys.usb.config=accessory,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/idVendor 0x18d1
    write /config/usb_gadget/g1/idProduct 0x2d01

on property:sys.usb.config=audio_source && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/idVendor 0x18d1
    write /config/usb_gadget/g1/idProduct 0x2d02

on property:sys.usb.config=audio_source,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/idVendor 0x18d1
    write /config/usb_gadget/g1/idProduct 0x2d03

on property:sys.usb.config=accessory,audio_source && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/idVendor 0x18d1
    write /config/usb_gadget/g1/idProduct 0x2d04

on property:sys.usb.config=accessory,audio_source,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/idVendor 0x18d1
    write /config/usb_gadget/g1/idProduct 0x2d05

on property:sys.usb.config=midi && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/idVendor 0x18d1
    write /config/usb_gadget/g1/idProduct 0x4ee8

on property:sys.usb.config=midi,adb && property:sys.usb.configfs=1
    write /config/usb_gadget/g1/idVendor 0x18d1
    write /config/usb_gadget/g1/idProduct 0x4ee9

on property:vendor.usb.eud=1
    write /config/usb_gadget/g1/configs/b.1/MaxPower 1
    write /sys/module/eud/parameters/enable 1
    write /sys/kernel/debug/pmic-votable/USB_ICL/force_active 1
    write /sys/kernel/debug/pmic-votable/USB_ICL/force_val 500

on property:vendor.usb.eud=0
    write /sys/kernel/debug/pmic-votable/USB_ICL/force_active 0
    write /sys/kernel/debug/pmic-votable/USB_ICL/force_val 0
    write /config/usb_gadget/g1/configs/b.1/MaxPower 0
    write /sys/module/eud/parameters/enable 0

#bsp, 2020/07/07 Add for op chg
service oplus_chg_init_sh /vendor/bin/init.oplus_chg.sh
    class core
    user root
    oneshot
    disabled

on boot
    start oplus_chg_init_sh

on charger
    start oplus_chg_init_sh

on property:sys.fastcharger=true
    write /sys/class/oplus_chg/usb/chg_enable 1

on property:sys.fastcharger=false
    write /sys/class/oplus_chg/usb/chg_enable 0

