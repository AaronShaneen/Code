#!/usr/bin/python -T

# F to C function
def fahrenheitToCelsius(fahrenheit):
    # Copy fahrenheit value to preserve original value
    F = fahrenheit
    # Perform F to C conversion
    C = (F - 32.0) * (5.0/9.0)
    # Return converted value
    return C

# C to F function
def celsiusToFahrenheit(celsius):
    # Copy celsius value to preserve original value
    C = celsius
    # Perform C to F conversion
    F = (9.0/5.0) * C + 32.0
    # Return farenheit value
    return F

# Print welcome message once per program execution
print("\nWelcome to the Temperature Conversion Program\n")

# Begin to loop program until exited
while True:
    # Print main menu
    menuNum = input("""\nMain Menu
    \n\t1:Fahrenheit to Celsius
    \n\t2:Celsius to Fahrenheit
    \n\t3:Exit program
    \n\tPlease enter 1, 2 or 3: """)
    
    # Validate main menu input
    try:
        menuNum = int(menuNum)
    # If input is invalid throw error and return to main menu
    except:
        print("\nThat is not a valid input")
        continue

    # If main menu input is valid determine what it is

    # If users wants to perform F to C conversion
    if menuNum == 1:
        # Prompt user for a degree to convert
        num = input("\nPlease enter degrees Fahrenheit: ")

        # Validate degree input, convert, and print result
        try:
            num = float(num)
            newNum = fahrenheitToCelsius(num)
            print("\n%.1f degrees Fahrenheit equals %.1f degrees Celsius" % (num,newNum))
        
        # If degree input is invalid throw error and return to main menu
        except:
            print("\nInvalid entry")
            continue

    # If user wants to perform C to F conversion
    if menuNum == 2:
        # Prompt user for a degree to convert
        num = input("\nPlease enter degrees Celsius: ")

        # Validate degree input, convert, and print result
        try:
            num = float(num)
            newNum = celsiusToFahrenheit(num)
            #print("\n%.1f degrees Celsius equals %.1f degrees Fahrenheit" % (num,newNum))              # old format specifier %[datatype] used with tuple input
            print("\n{0:.1f} degrees Celsius equals {1:.1f} degrees Fahrenheit".format(num,newNum))     # format codes with .format() method
        
        # If degree input is invalid throw error and return to main menu
        except:
            print("\nInvalid entry")
            continue

    # If user wants to exit program
    if menuNum == 3:
        exit(0)

    # Once done, return to main menu
    continue
