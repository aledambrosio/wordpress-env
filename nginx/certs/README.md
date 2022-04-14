## Add local certificates here to enable https

I personally like using [mkcert]() for this. 

Follow the installation instructions, then `cd` to this directory and use `mkcert` with the local domain name of your choosing.


### Create certs & keys
```
openssl genrsa -out wordpress-docker.test-key.pem 2048
openssl req -new -sha256 -key wordpress-docker.test-key.pem -out csr.csr
openssl req -x509 -sha256 -days 365 -key wordpress-docker.test-key.pem -in csr.csr -out wordpress-docker.test.pem
openssl req -in csr.csr -text -noout | grep -i "Signature.*SHA256" && echo "All is well" || echo "This certificate will stop working in 2017! You must update OpenSSL to generate a widely-compatible certificate"
```

source: https://msol.io/blog/tech/create-a-self-signed-ssl-certificate-with-openssl/

