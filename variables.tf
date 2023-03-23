variable "project_name"{
    type = string
    default = "tsabri"
}

variable "environment_suffix"{
    type = string
    default = ""
    
}

variable "PORT"{
    type = string
    default = 3000
}

variable "DB_PORT"{
    type = string
    default = 5432
}

variable "ACCESS_TOKEN_EXPIRY"{
    type = string
    default = "15m"
}

variable "REFRESH_TOKEN_EXPIRY"{
    type = string
    default = "7d"
}

variable "REFRESH_TOKEN_COOKIE_NAME"{
    type = string
    default = "jid"
}

variable "DB_DAILECT"{
    type = string
    default = "postgres"
}