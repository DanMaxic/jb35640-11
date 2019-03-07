resource "aws_key_pair" "luminate_public_key" {
  key_name   = "${var.deployment_config["application-name"]}_keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzpAvurF7ZfhyosQcaa32p4GUP9zQCcQERQFAEAFOm//AvFtZT7GLKkXveUDPX2GtRBVz/nYEg4PnbVqF0OpsmKDGNgxjSF+Qj6qBnRrl+bOnBhQKUbZh3uwIjobmDerW9tSS0ZMRnuYinM6ofFLbOVpkENqo/kXhQXbNwci+sNGVSC9psDRXXYRzrThdS7Jflt8ytn1/cviDudlm5dYc2kHiMqrUUaP3D5I2z97HbyJDqAcFgWqEBvSXrXchCL0o84/KNWVPUVcCns33mqUpjt+v0/HjTaUaVQ2EZi2c1ouoymn7bpRhfYp6p5ln2xsTPWHYLqtznRRfXGHPsNELN ubuntu@ip-172-31-16-121"
}