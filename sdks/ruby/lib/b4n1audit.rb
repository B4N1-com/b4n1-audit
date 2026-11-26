require "open3"

# Wrapper Ruby del binario precompilado de b4n1-audit (one-binary-N-wrappers).
# Resolución: B4N1_AUDIT_BIN > binario empaquetado > PATH > fallo loud (§5).
module B4n1Audit
  def self.binary_path
    env = ENV["B4N1_AUDIT_BIN"]
    return env if env && !env.empty?

    name =
      case RUBY_PLATFORM
      when /x86_64-linux/ then "b4n1-audit-linux-amd64"
      when /aarch64-linux/ then "b4n1-audit-linux-arm64"
      when /x86_64-darwin/ then "b4n1-audit-macos-x64"
      when /arm64-darwin/ then "b4n1-audit-macos-arm64"
      when /mingw|mswin/ then "b4n1-audit-windows-amd64.exe"
      end

    if name
      bundled = File.join(__dir__, "..", "bin", name)
      return bundled if File.file?(bundled)
    end

    "b4n1-audit"
  end

  # Invoca el binario; stdout crudo. Exit != 0 => RuntimeError (nunca silencio).
  def self.run_raw(*args)
    out, err, status = Open3.capture3(binary_path, *args)
    unless status.success?
      raise "b4n1-audit exit=#{status.exitstatus}: #{args.join(' ')}\nstderr: #{err[0, 2000]}"
    end
    out
  end

  class Client
    def help = B4n1Audit.run_raw("--help")
    def scan(path) = B4n1Audit.run_raw("scan", path)
    def json(path) = B4n1Audit.run_raw("json", path)
  end
end
