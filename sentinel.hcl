# declare policy in policy set

policy "restrict-vm-size" {
    source = "./restrict-vm-size.sentinel"
    enforcement_level = "soft-mandatory"
}

policy "restrict-day" {
    source = "./restrict-day.sentinel"
    enforcement_level = "soft-mandatory"
}

#policy "restrict-region" {
#    source = "./restrict-region.sentinel"
#    enforcement_level = "soft-mandatory"
#}
