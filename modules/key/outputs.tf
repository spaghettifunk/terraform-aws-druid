output "key_name" {
  description = "Name of the Key generated"
  value       = "${aws_key_pair.generated_key.key_name}"
}

output "key_value" {
  description = "Name of the Key generated"
  value       = "${aws_key_pair.generated_key.public_key}"
}
