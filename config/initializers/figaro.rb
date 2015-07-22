# Raise an error if these keys aren't set
Figaro.require_keys("SENDGRID_USERNAME",
                    "SENDGRID_PASSWORD",
                    "SECRET_KEY_BASE")