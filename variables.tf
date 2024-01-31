variable scale_out_weekday {
    description = "scale out threshold"
    type        = object(
        {
            peak_cron            = string
            offpeak_cron         = string
            peak_threshold       = number
            offpeak_threshold    = number
            peak_increment_by    = number
            offpeak_increment_by = number
        }
    )
    
}

variable scale_out_weekend {
    description = "scale out threshold for weekend"
    type        = object(
        {
            cron         = string
            threshold    = number
            increment_by = number
        }
    )
}

variable scale_in_peak {
    description = "scale in threshold"
    type        = object(
        {
            threshold    = number
            decrement_by = number
        }
    )
}


variable scale_in_offpeak {
    description = "scale in threshold"
    type        = object(
        {
            threshold    = number
            decrement_by = number
        }
    )
}

variable fleet_name {
    description = "fleet name"
    type        = string
}

variable minimum_capacity {
    description = "minimum capacity"
    type        = number
}

variable maximum_capacity {
    description = "maximum capacity"
    type        = number
}

