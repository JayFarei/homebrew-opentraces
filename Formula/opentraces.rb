class Opentraces < Formula
  include Language::Python::Virtualenv

  desc "Crowdsource agent traces to HuggingFace Hub"
  homepage "https://opentraces.ai"
  url "https://github.com/JayFarei/opentraces/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "a1cfac839625e7a79a06502067330f60f47ab3b84443f7a0dc3d391ccc5b1ce6"
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

  test do
    assert_match version.to_s, shell_output("#{bin}/opentraces --version")
    assert_match version.to_s, shell_output("#{bin}/ot --version")
  end
end

# write-access test perturbation — the release workflow should overwrite this
