# About

This basic scripts helps automating the creation of domains or subdomains.

## Usage: Create a vhost

    chmod +x setvhost.sh

Set the domain or subdomain

    setvhost.sh —d subdomain3.example.com —u /var/www/mydir/public
or

    setvhost.sh --domain subdomain3.example.com --directory /var/www/mydir/public

## SSL for subdomains case

 I usally use it with subdomains to which I add a wildcard certificate, which you can generate using acme.sh or certbot:

    certbot certonly --manual --preferred-challenges=dns --email mail@example.com --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d example.com -d *.example.com

You will have to add the returned DNS record for verification.

The returned cert has to be added to the SSL part of the skeleton file 'vhost.skeleton.conf':

	SSLCertificateFile /etc/letsencrypt/live/example.com/fullchain.pem
	SSLCertificateKeyFile /etc/letsencrypt/live/example.com/privkey.pem

## Addon domains case

In this cas you will have to add to the end of the script an SSL request. For example, when used with certbot:
    certbot certonly --preferred-challenges http -d example.com


Cetbot instructions:
https://certbot.eff.org/



