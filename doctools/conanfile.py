from conan import ConanFile
from conan.tools.system.package_manager import Apt, Brew
from conan.errors import ConanInvalidConfiguration

required_conan_version = ">=1.47"

class DocumentationToolsConan(ConanFile):
    name = "doctools"
    version = "system"
    url = "https://github.com/agagniere/MinilibX"
    license = "MIT"
    description = "Ensures the presence of tools useful to generate documentation"
    settings = "os"
    topics = ("pdf", "man", "gnuplot")
    _packages = ["gnuplot", "ghostscript", "help2man"]

    def validate(self):
        if self.settings.os not in ["Linux", "Macos"]:
            raise ConanInvalidConfiguration("This recipe supports only Linux and MacOS")

    def package_id(self):
        self.info.header_only()

    def system_requirements(self):
        Apt(self).install(self._packages, update=True, check=True)
        self.conf['tools.system.package_manager:sudo'] = False
        Brew(self).install(self._packages, update=True, check=True)
