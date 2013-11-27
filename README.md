Sample Vagrant config to get Docker running on CentOS (6.4, in this case).

Proper packaging is not being used, but this is at least a starting point that
could be useful for other people.  There's no guarantee everything works, and
there is a warning when containers start:

    lxc-start: Does this kernel version support 'attach'?
    lxc-start: Function not implemented - failed to set namespace 'mnt'

and sometimes

    lxc-start: Function not implemented - failed to set namespace 'pid'

But it's able to create containers from the `centos` and `base` images.
