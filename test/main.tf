module "appstream_autoscaler" {
    source = "../"

    fleet_name          = local.workspace.fleet_name
    scale_out_weekend   = local.workspace["scale_out_weekend"]
    scale_out_weekday   = local.workspace["scale_out_weekday"]
    scale_in_peak       = local.workspace["scale_in_peak"]
    scale_in_offpeak    = local.workspace["scale_in_offpeak"]
    minimum_capacity    = local.workspace["minumum_capacity"]
    maximum_capacity    = local.workspace["maximum_capacity"]
}