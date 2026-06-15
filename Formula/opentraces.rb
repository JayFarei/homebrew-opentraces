class Opentraces < Formula
  include Language::Python::Virtualenv

  desc "Crowdsource agent traces to HuggingFace Hub"
  homepage "https://opentraces.ai"
  url "https://github.com/JayFarei/opentraces/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "2d8f567b0467113d4608bdacc07cda28067d47055ea434dab2213f13598d8bdf"
  license "MIT"
  head "https://github.com/JayFarei/opentraces.git", branch: "main"

  depends_on "python@3.12"

  def install
    venv = virtualenv_create(libexec, "python3.12")
    # venv.pip_install runs with --no-deps (expects vendored resources); this
    # tap resolves dependencies from PyPI instead. The venv is created
    # --without-pip, so go through python -m pip (system-site-packages).
    system libexec/"bin/python", "-m", "pip", "install", "--no-input", buildpath/"packages/opentraces-schema"
    system libexec/"bin/python", "-m", "pip", "install", "--no-input", buildpath.to_s
    bin.install_symlink libexec/"bin/opentraces"
    bin.install_symlink libexec/"bin/ot"
  end

  def post_install
    # Re-render installed hook glue so upgrades don't leave stale
    # version-pinned Cellar interpreter paths behind. Best-effort:
    # never fail the install if integrations aren't set up. (#86)
    system bin/"opentraces", "setup", "upgrade", "--integrations-only" rescue nil
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opentraces --version")
    assert_match version.to_s, shell_output("#{bin}/ot --version")
  end
end
