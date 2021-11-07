# declare policy in policy set

policy "restrict-vm-size" {
    source = "./restrict-vm-size.sentinel"
    enforcement_level = "soft-mandatory"
}
