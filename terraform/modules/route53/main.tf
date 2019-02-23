resource "aws_route53_zone" "overwatcharenaclashcommunity_com" {
  name = "overwatcharenaclashcommunity.com."
}

resource "aws_route53_record" "overwatcharenaclashcommunity_com_ns_record" {
    zone_id = "${aws_route53_zone.overwatcharenaclashcommunity_com.zone_id}"
    type = "NS"
    name = "overwatcharenaclashcommunity.com."
    records = [        	
        "ns-734.awsdns-27.net.",
        "ns-1930.awsdns-49.co.uk.",
        "ns-109.awsdns-13.com.",
        "ns-1132.awsdns-13.org."
    ]
    ttl = 172800
}

resource "aws_route53_record" "overwatcharenaclashcommunity_com_soa_record" {
    zone_id = "${aws_route53_zone.overwatcharenaclashcommunity_com.zone_id}"
    type = "SOA"
    name = "overwatcharenaclashcommunity.com."
    records = ["ns-1930.awsdns-49.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
    ttl = "900"
}
