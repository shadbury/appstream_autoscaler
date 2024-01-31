locals {

  env = {
    prod = {
        aws_profile       = "joeladmin"
        region            = "ap-southeast-2"
        fleet_name        = "test"
        minumum_capacity  = 1
        maximum_capacity  = 10


        scale_out_weekend = {
            cron         = "0 08 ? * FRI,SAT *"
            threshold     = 5
            increment_by  = 5
        }

        scale_out_weekday = {
            peak_cron            = "0 6 ? * MON-FRI *"
            offpeak_cron        = "0 18 ? * MON-FRI *"
            peak_threshold       = 7
            peak_increment_by    = 2
            offpeak_threshold    = 3
            offpeak_increment_by = 1
        }

        scale_in = {
            threshold    = 3
            decrement_by = -1
        }

    }
  }

  workspace = local.env[terraform.workspace]
}