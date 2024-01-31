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
            threshold     = 1
            increment_by  = 1
        }

        scale_out_weekday = {
            peak_cron            = "0 19 ? * SUN-THU *"
            offpeak_cron         = "0 8 ? * MON-FRI *"
            peak_threshold       = 5
            peak_increment_by    = 2
            offpeak_threshold    = 2
            offpeak_increment_by = 1
        }

        scale_in_peak = {
            threshold    = 6
            decrement_by = -1
        }

        scale_in_offpeak = {
            threshold    = 1
            decrement_by = -1
        }

    }
  }

  workspace = local.env[terraform.workspace]
}