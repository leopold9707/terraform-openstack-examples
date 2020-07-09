resource "openstack_compute_keypair_v2" "my-cloud-key" {
  name       = "test_key_name"
  public_key = file("~/.ssh/id_rsa.pub")  ##FIXME
}

resource "openstack_compute_instance_v2" "test" {
  name            = "central-manager"  ##FIXME
  image_name      = "CentOS-7-1907"  ##FIXME
  flavor_name     = "m1.xlarge"  ##FIXME
  key_pair        = openstack_compute_keypair_v2.my-cloud-key.name
  security_groups = ["default"]  ##FIXME

  network {
    name = "public-provider-97"  ##FIXME
  }

  user_data = <<-EOF
    #cloud-config
    write_files:
    - content: |
        CONDOR_HOST = localhost
        ALLOW_WRITE = *
        ALLOW_READ = $(ALLOW_WRITE)
        ALLOW_NEGOTIATOR = $(ALLOW_WRITE)
        DAEMON_LIST = COLLECTOR, MASTER, NEGOTIATOR, SCHEDD
        FILESYSTEM_DOMAIN = terraform-training
        UID_DOMAIN = terraform-training
        TRUST_UID_DOMAIN = True
        SOFT_UID_DOMAIN = True
      owner: root:root
      path: /etc/condor/condor_config.local
      permissions: '0644'
    - content: |
        /data           /etc/auto.data          nfsvers=3
      owner: root:root
      path: /etc/auto.master.d/data.autofs
      permissions: '0644'
    - content: |
        share  -rw,hard,intr,nosuid,quota  openstack_compute_instance_v2.nfs.access_ip_v4:/data/share
      owner: root:root
      path: /etc/auto.data
      permissions: '0644'
  EOF
}

resource "openstack_compute_instance_v2" "nfs" {
  name            = "nfs-server"  ##FIXME
  image_name      = "CentOS-7-1907"  ##FIXME
  flavor_name     = "m1.xlarge"  ##FIXME
  key_pair        = openstack_compute_keypair_v2.my-cloud-key.name
  security_groups = ["default"]  ##FIXME

  network {
    name = "public-provider-97"  ##FIXME
  }

  user_data = <<-EOF
    #cloud-config
    write_files:
    - content: |
        /data/share *(rw,sync)
      owner: root:root
      path: /etc/exports
      permissions: '0644'
    runcmd:
     - [ mkdir, -p, /data/share ]
     - [ chown, "centos:centos", -R, /data/share ]
     - [ systemctl, enable, nfs-server ]
     - [ systemctl, start, nfs-server ]
     - [ exportfs, -avr ]
  EOF
}

resource "openstack_compute_instance_v2" "exec" {
  name            = "exec-${count.index}"
  image_name      = "CentOS-7-1907"  ##FIXME
  flavor_name     = "m1.xlarge"  ##FIXME
  key_pair        = openstack_compute_keypair_v2.my-cloud-key.name
  security_groups = ["default"]  ##FIXME
  count           = 2  ##FIXME

  network {
    name = "public-provider-97"  ##FIXME
  }

  user_data = <<-EOF
    #cloud-config
    write_files:
    - content: |
        CONDOR_HOST = openstack_compute_instance_v2.test.access_ip_v4
        ALLOW_WRITE = *
        ALLOW_READ = $(ALLOW_WRITE)
        ALLOW_ADMINISTRATOR = *
        ALLOW_NEGOTIATOR = $(ALLOW_ADMINISTRATOR)
        ALLOW_CONFIG = $(ALLOW_ADMINISTRATOR)
        ALLOW_DAEMON = $(ALLOW_ADMINISTRATOR)
        ALLOW_OWNER = $(ALLOW_ADMINISTRATOR)
        ALLOW_CLIENT = *
        DAEMON_LIST = MASTER, SCHEDD, STARTD
        FILESYSTEM_DOMAIN = terraform-training
        UID_DOMAIN = terraform-training
        TRUST_UID_DOMAIN = True
        SOFT_UID_DOMAIN = True
        # run with partitionable slots
        CLAIM_PARTITIONABLE_LEFTOVERS = True
        NUM_SLOTS = 1
        NUM_SLOTS_TYPE_1 = 1
        SLOT_TYPE_1 = 100%
        SLOT_TYPE_1_PARTITIONABLE = True
        ALLOW_PSLOT_PREEMPTION = False
        STARTD.PROPORTIONAL_SWAP_ASSIGNMENT = True
      owner: root:root
      path: /etc/condor/condor_config.local
      permissions: '0644'
    - content: |
        /data           /etc/auto.data          nfsvers=3
      owner: root:root
      path: /etc/auto.master.d/data.autofs
      permissions: '0644'
    - content: |
        share  -rw,hard,intr,nosuid,quota  openstack_compute_instance_v2.nfs.access_ip_v4:/data/share
      owner: root:root
      path: /etc/auto.data
      permissions: '0644'
  EOF
}
