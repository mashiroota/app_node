output "domain_cert" {
  value = "${acme_certificate.domain_certificate.certificate_pem}${acme_certificate.domain_certificate.issuer_pem}"
}

output "domain_key" {
  value = "${acme_certificate.domain_certificate.private_key_pem}"
}

output "all_sub_cert" {
  value = "${acme_certificate.all_subdomain_certificate.certificate_pem}${acme_certificate.all_subdomain_certificate.issuer_pem}"
}

output "all_sub_key" {
  value = "${acme_certificate.all_subdomain_certificate.private_key_pem}"
}

output "haproxy_pem" {
  value = "${acme_certificate.all_subdomain_certificate.certificate_pem}${acme_certificate.all_subdomain_certificate.issuer_pem}${acme_certificate.all_subdomain_certificate.private_key_pem}"
}


# write out the letsencrypt CA
output "ca_cert" {
    value = "${data.http.letsencrypt_ca_cert.body}"
}