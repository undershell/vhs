# About

This is a basic script that permits the addition of aliases to an apache config in which HTTP & HTTPs virtualhosts are gathered in one file.

# Usage

Specify in setalias.sh the main vh that will be used as reference:
  
  vh="/etc/apache2/sites-available/saas.example.com.conf"
  main="saas.example.com"

Then run your command:

  setalias.sh add saas2.example.com

or

  setalias.sh remove saas2.example.com
