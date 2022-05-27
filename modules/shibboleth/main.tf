wget https://registry.idem.garr.it/idem-conf/shibboleth/IDP4/apache2/$(hostname -f).conf -O /etc/apache2/sites-available/$(hostname -f).conf


# SSL general security improvements should be moved in global settings
# OCSP Stapling, only in httpd/apache >= 2.3.3
SSLUseStapling on
SSLStaplingResponderTimeout 5
SSLStaplingReturnResponderErrors off
SSLStaplingCache shmcb:/var/run/ocsp(128000)

<VirtualHost *:80>
   ServerName "ip-10-0-1-172.ec2.internal"
   Redirect permanent "/" "https://ip-10-0-1-172.ec2.internal/"
</VirtualHost>

<IfModule mod_ssl.c>
   <VirtualHost _default_:443>
     ServerName ip-10-0-1-172.ec2.internal:443
     ServerAdmin admin@sixninex.com
     # Debian/Ubuntu
     CustomLog /var/log/apache2/ip-10-0-1-172.ec2.internal.log combined
     ErrorLog /var/log/apache2/ip-10-0-1-172.ec2.internal-error.log
     # Centos
     #CustomLog /var/log/httpd/ip-10-0-1-172.ec2.internal.log combined
     #ErrorLog /var/log/httpd/ip-10-0-1-172.ec2.internal-error.log
     
     DocumentRoot /var/www/html/ip-10-0-1-172.ec2.internal
     
     SSLEngine On
     SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
     SSLCipherSuite "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !RC4"

     SSLHonorCipherOrder on
     
     # Disallow embedding your IdP's login page within an iframe and
     # Enable HTTP Strict Transport Security with a 2 year duration
     <IfModule headers_module>
        Header set X-Frame-Options DENY
        Header set Strict-Transport-Security "max-age=63072000 ; includeSubDomains ; preload"
     </IfModule>
     
     # Debian/Ubuntu
     SSLCertificateFile /etc/ssl/certs/ip-10-0-1-172.ec2.internal.crt
     SSLCertificateKeyFile /etc/ssl/private/ip-10-0-1-172.ec2.internal.key
  
     # ACME-CA or GEANT_OV_RSA_CA_4 (For users who use GARR TCS/Sectigo RSA Organization Validation Secure Server CA)
     #SSLCACertificateFile /etc/ssl/certs/ACME-CA.pem
     SSLCACertificateFile /etc/ssl/certs/GEANT_OV_RSA_CA_4.pem


     # Centos
     #SSLCertificateFile /etc/pki/tls/certs/ip-10-0-1-172.ec2.internal.crt
     #SSLCertificateKeyFile /etc/pki/tls/private/ip-10-0-1-172.ec2.internal.key

     # ACME-CA or GEANT_OV_RSA_CA_4 (For users who use GARR TCS/Sectigo RSA Organization Validation Secure Server CA)
     #SSLCACertificateFile /etc/pki/tls/certs/ACME-CA.pem
     #SSLCACertificateFile /etc/pki/tls/certs/GEANT_OV_RSA_CA_4.pem

     <IfModule mod_proxy.c>
        ProxyPreserveHost On
        RequestHeader set X-Forwarded-Proto "https"
        ProxyPass /idp http://localhost:8080/idp retry=5
        ProxyPassReverse /idp http://localhost:8080/idp retry=5

        <Location /idp>
           Require all granted
        </Location>
     </IfModule>
   </VirtualHost>
</IfModule>

# This virtualhost is only here to handle administrative commands for Shibboleth, executed from localhost
<VirtualHost 127.0.0.1:80>
  ProxyPass /idp http://localhost:8080/idp retry=5
  ProxyPassReverse /idp http://localhost:8080/idp retry=5
  <Location /idp>
    Require all granted
  </Location>
</VirtualHost>

sudo chmod 400 /etc/ssl/private/$(hostname -f).key
openssl ecparam -name prime256v1 -genkey -noout -out $(hostname -f).key
openssl req -new -sha256 -key $(hostname -f).key -out $(hostname -f).csr
openssl x509 -req -in $(hostname -f).csr -CA ca.crt -CAkey ca.key -CAcreateserial -out $(hostname -f).crt -days 1000 -sha256
cp $(hostname -f).key /etc/ssl/private/

chmod 644 /etc/ssl/certs/$(hostname -f).crt