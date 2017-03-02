# Docker Letsencrypt route53

Docker container to automate [ACME DNS challenge validation](https://ietf-wg-acme.github.io/acme/#rfc.section.8.4) and certificate management with Letsencrypt, dehydrated and AWS route53.

## Note

The dehydrated hook `dehydrated-route53` manages multiple route53 hosted zones. See [original version](https://gist.github.com/jam13/1c0acb5fa7ed4d785adea771473b4e0a).

## Resources

* [ACME](https://ietf-wg-acme.github.io/acme/) - Automatic Certificate Management Environment
* [ACME - DNS challenge](https://tools.ietf.org/html/draft-ietf-acme-acme-03#section-7.4) - draft-ietf-acme-acme-03
* [Letsencrypt ACME client implementations](https://letsencrypt.org/docs/client-options/)
* [Certbot](https://certbot.eff.org/docs/using.html#managing-certificates) -  official ACME client
* [dehydrated](https://github.com/lukas2511/dehydrated) - shell ACME client
* [How to use Let's Encrypt DNS challenge validation?](http://serverfault.com/questions/750902/how-to-use-lets-encrypt-dns-challenge-validation) - serverfault thread
* [Let's encrypt with Dehydrated: DNS-01](https://www.aaflalo.me/2017/02/lets-encrypt-with-dehydrated-dns-01/) - Blog post and examples of usage with Lexicon
* [Lexicon](https://github.com/AnalogJ/lexicon) - Manipulate DNS records on various DNS providers in a standardized way.
* [AWS route53 CLI](http://docs.aws.amazon.com/cli/latest/reference/route53/) - Command reference

## Docker image
- [`latest`/`1` (*Dockerfile*)](https://github.com/willgarcia/docker-letsencrypt-route53/blob/master/Dockerfile)

[![](https://images.microbadger.com/badges/version/willgarcia/letsencrypt.svg)](http://microbadger.com/images/willgarcia/letsencrypt "Get your own version badge on microbadger.com")  [![](https://images.microbadger.com/badges/image/willgarcia/letsencrypt.svg)](http://microbadger.com/images/willgarcia/letsencrypt "Get your own image badge on microbadger.com")



## Usage

```
$ docker run \
    --env-file letsencrypt.env \
    willgarcia/letsencrypt \
    dehydrated

Usage: /usr/bin/dehydrated [-h] [command [argument]] [parameter [argument]] [parameter [argument]] ...

Default command: help

Commands:
 --register                       Register account key
 --cron (-c)                      Sign/renew non-existant/changed/expiring certificates.
 --signcsr (-s) path/to/csr.pem   Sign a given CSR, output CRT on stdout (advanced usage)
 --revoke (-r) path/to/cert.pem   Revoke specified certificate
 --cleanup (-gc)                  Move unused certificate files to archive directory
 --help (-h)                      Show help text
 --env (-e)                       Output configuration variables for use in other scripts

Parameters:
 --accept-terms                   Accept CAs terms of service
 --full-chain (-fc)               Print full chain when using --signcsr
 --ipv4 (-4)                      Resolve names to IPv4 addresses only
 --ipv6 (-6)                      Resolve names to IPv6 addresses only
 --domain (-d) domain.tld         Use specified domain name(s) instead of domains.txt entry (one certificate!)
 --keep-going (-g)                Keep going after encountering an error while creating/renewing multiple certificates in cron mode
 --force (-x)                     Force renew of certificate even if it is longer valid than value in RENEW_DAYS
 --no-lock (-n)                   Don't use lockfile (potentially dangerous!)
 --lock-suffix example.com        Suffix lockfile name with a string (useful for with -d)
 --ocsp                           Sets option in CSR indicating OCSP stapling to be mandatory
 --privkey (-p) path/to/key.pem   Use specified private key instead of account key (useful for revocation)
 --config (-f) path/to/config     Use specified config file
 --hook (-k) path/to/hook.sh      Use specified script for hooks
 --out (-o) certs/directory       Output certificates into the specified directory
 --challenge (-t) http-01|dns-01  Which challenge should be used? Currently http-01 and dns-01 are supported
 --algo (-a) rsa|prime256v1|secp384r1 Which public key algorithm should be used? Supported: rsa, prime256v1 and secp384r1
```

## Example of DNS challenge validation / cert. creation

### Environment

[Configure your credential for the AWS command line interface](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-environment) in `letsencrypt.env`.

Run dehydrated:

```
$ docker run \
    --env-file letsencrypt.env \
    willgarcia/letsencrypt \
    dehydrated \
        --cron --domain domain.com \
        --out /etc/ssl \
        --hook dehydrated \
        --challenge dns-01

# INFO: Using main config file /etc/dehydrated/config
Processing domain.com
 + Signing domains...
 + Creating new directory /etc/certs/domain.com ...
 + Generating private key...
 + Generating signing request...
 + Requesting challenge for domain.com...
 + Already validated!
 + Requesting certificate...
 + Checking certificate...
 + Done!
 + Creating fullchain.pem...
Manually Deploy Cert: domain.com, /etc/certs/domain.com/privkey.pem, /etc/certs/domain.com/cert.pem, /etc/certs/domain.com/chain.pem
 + Done!
```
