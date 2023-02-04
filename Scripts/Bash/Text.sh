#!/bin/bash

# Text phone number within US/Canada

curl -X POST https://textbelt.com/text \
    --data-urlencode Phone='9168128839' \
    --data-urlencode message='Check out these shoes!' \
    -d key=textbelt