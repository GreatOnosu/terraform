resource "aws_route53_zone" "codex_camp" {
  name = "codex.com"
}

resource "aws_route53_records" "server1_records" {
  zone_id = aws_route53_zone.codex_camp.zone_id
  name    = "www.codex.com"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.lb.public_ip]
}