from conans import ConanFile, AutoToolsBuildEnvironment
from conans.errors import ConanInvalidConfiguration
import os

class MinilibXConan(ConanFile):
    name = "minilibx"
    version = "master"
    default_user = "42Paris"
    default_channel = "github"
    license = "BSD"
    url = "https://github.com/42Paris/minilibx-linux"
    description = "Simple X11 interface"
    topics = ("conan", "x11")
    settings = ("os", "compiler", "arch")
    generators = "make"
    _source_subfolder = "src"
    options = {
        "fPIC": [True, False],
        "optimisation": ['0', '1', '2', '3', 's', 'fast'],
        "debug": [True, False]
    }
    default_options = {
        "fPIC": False,
        "optimisation": '2',
        "debug": True
    }


    def validate(self):
        if self.settings.os not in ["Macos", "Linux"]:
            raise ConanInvalidConfiguration(f"OS {self.settings.os} not supported")

    def requirements(self):
        if self.settings.os == "Linux":
            self.requires("xorg/system")
            self.requires("libbsd/0.10.0")
        # For Macos : XQuartz, to be installed manually...

    def source(self):
        self.run(f"git clone {self.url} {self._source_subfolder}")

    def configure(self):
        del self.settings.compiler.libcxx
        del self.settings.compiler.cppstd

    def build(self):
        self.run("tail +15 {0}.mk | grep -vP 'CFLAGS\s*=' > {0}.gen".format(os.path.join(self._source_subfolder, "Makefile")))
        autotools = AutoToolsBuildEnvironment(self)
        autotools.flags = [f"-O{self.options.optimisation}"]
        if self.options.debug:
            autotools.flags += ["-g"]
        autotools.make(args=["-C", self._source_subfolder, "-f", "Makefile.gen"])

    def package(self):
        self.copy(os.path.join(self._source_subfolder, "mlx.h"), dst="include", keep_path=False)
        self.copy(os.path.join(self._source_subfolder, "libmlx.a"), dst="lib", keep_path=False)

    def package_info(self):
        self.cpp_info.libs = ["mlx"]
