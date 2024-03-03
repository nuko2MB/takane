# https://github.com/materusPL/nixos-config/blob/59e69924bb18acd396a15bb166743c037d4df756/configurations/host/materusPC/vm/win10/default.nix
{ pkgs, ... }:
let
  startHook =
    /* ''

       # Debugging
         exec 19>/home/materus/startlogfile
         BASH_XTRACEFD=19
         set -x

         exec 3>&1 4>&2
         trap 'exec 2>&4 1>&3' 0 1 2 3
         exec 1>/home/materus/startlogfile.out 2>&1
       ''
       +
    */
    ''
       # Make sure nothing renders on gpu to prevent "sysfs: cannot create duplicate filename" after rebinding to amdgpu
       chmod 0 /dev/dri/renderD128 
       fuser -k /dev/dri/renderD128

       # Seems to fix reset bug for 7900 XTX
       echo "0" > "/sys/bus/pci/devices/''${VIRSH_GPU_VIDEO}/d3cold_allowed"

       systemctl stop mountWin10Share.service
       
       
       echo $VIRSH_GPU_VIDEO > "/sys/bus/pci/devices/''${VIRSH_GPU_VIDEO}/driver/unbind"
       echo $VIRSH_GPU_AUDIO > "/sys/bus/pci/devices/''${VIRSH_GPU_AUDIO}/driver/unbind"

       sleep 1s

       echo "10" > "/sys/bus/pci/devices/''${VIRSH_GPU_VIDEO}/resource0_resize"
       echo "8" > "/sys/bus/pci/devices/''${VIRSH_GPU_VIDEO}/resource2_resize"

       echo "3" > /proc/sys/vm/drop_caches
       echo "1" > /proc/sys/vm/compact_memory
      #echo "8192" >  /sys/devices/system/node/node1/hugepages/hugepages-2048kB/nr_hugepages



       systemctl set-property --runtime -- user.slice AllowedCPUs=0-7,16-23
       systemctl set-property --runtime -- system.slice AllowedCPUs=0-7,16-23
       systemctl set-property --runtime -- init.scope AllowedCPUs=0-7,16-23


    '';
  stopHook = ''

     # Debugging
     #  exec 19>/home/materus/stoplogfile
     #  BASH_XTRACEFD=19
     #  set -x

     #  exec 3>&1 4>&2
     #  trap 'exec 2>&4 1>&3' 0 1 2 3
     #  exec 1>/home/materus/stoplogfile.out 2>&1


         
     sleep 1s
     echo $VIRSH_GPU_VIDEO > "/sys/bus/pci/devices/''${VIRSH_GPU_VIDEO}/driver/unbind"
     echo $VIRSH_GPU_AUDIO > "/sys/bus/pci/devices/''${VIRSH_GPU_AUDIO}/driver/unbind"

         
     

     echo "15" > "/sys/bus/pci/devices/''${VIRSH_GPU_VIDEO}/resource0_resize"
     echo "8" > "/sys/bus/pci/devices/''${VIRSH_GPU_VIDEO}/resource2_resize"
     echo "1" > "/sys/bus/pci/devices/''${VIRSH_GPU_VIDEO}/d3cold_allowed"


     echo $VIRSH_GPU_VIDEO > /sys/bus/pci/drivers/amdgpu/bind
     echo $VIRSH_GPU_AUDIO > /sys/bus/pci/drivers/snd_hda_intel/bind
     
    #echo "0" >  /sys/devices/system/node/node1/hugepages/hugepages-2048kB/nr_hugepages

     systemctl start mountWin10Share.service

    # systemctl set-property --runtime -- user.slice AllowedCPUs=0-31
    # systemctl set-property --runtime -- system.slice AllowedCPUs=0-31
    # systemctl set-property --runtime -- init.scope AllowedCPUs=0-31



  '';
in
{

  virtualisation.libvirtd.hooks.qemu = {
    "win10" = pkgs.writeShellScript "win10.sh" ''
      VIRSH_GPU_VIDEO="0000:03:00.0"
      VIRSH_GPU_AUDIO="0000:03:00.1"

      if [ $1 = "win10" ] || [ $1 = "win11" ]; then
        if [ $2 = "prepare" ] && [ $3 = "begin" ]; then
          ${startHook}
        fi

        if [ $2 = "release" ] && [ $3 = "end" ]; then
          ${stopHook}
        fi

      fi


    '';
  };
}
#   VIRSH_USB1="0000:10:00.0"
