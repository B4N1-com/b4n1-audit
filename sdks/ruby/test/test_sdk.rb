# Smoke test del wrapper Ruby de b4n1-audit: help con verbos y fallo loud.
require_relative "../lib/b4n1audit"

client = B4n1Audit::Client.new
help = client.help.downcase

raise "--help sin usage: #{help}" unless help.include?("usage")
unless help.include?("scan") || help.include?("json") || help.include?("sarif")
  raise "--help no lista verbos: #{help}"
end

begin
  B4n1Audit.run_raw("verb-that-does-not-exist")
  raise "un verbo inexistente debe fallar loud"
rescue RuntimeError
  # contrato §5: el fallo es loud
end

puts "ok help + fallo tipado"
