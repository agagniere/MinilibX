from conans import ConanFile, AutoToolsBuildEnvironment, tools
from conans.errors import ConanInvalidConfiguration
import os

class MinilibXConan(ConanFile):
    name = "minilibx"
    version = "2.0"
    license = "BSD"
    author = "agagniere sid.xxdzs@gmail.com"
    url = "https://github.com/agagniere/MinilibX"
    description = "Simple X11 interface"
    topics = ("conan", "x11")
    settings = ("os", "compiler", "arch")
    options = {
        "shared": [True, False],
        "fPIC": [True, False],
        "optimisation": ['0', '1', '2', '3', 's', 'fast'],
        "debug": [True, False]
    }
    default_options = {
        "shared": True,
        "fPIC": False,
        "optimisation": '2',
        "debug": True
    }
    generators = "make"

    def validate(self):
        if self.settings.os not in ["Macos", "Linux"]:
            raise ConanInvalidConfiguration(f"OS {self.settings.os} not supported")

    def requirements(self):
        if self.settings.os == "Linux":
            self.requires("xorg/system")
        else: # MacOS
            self.requires("opengl/system")

    @property
    def _source_subfolder(self):
        if self.settings.os == "Linux":
            return "X11"
        elif tools.os_info.os_version >= "11":
            return "sierra"
        else:
            return "elcapitan"

    def source(self):
        self.run("git clone " + self.url + " .")

    def configure(self):
        del self.settings.compiler.libcxx
        del self.settings.compiler.cppstd

    def build(self):
        autotools = AutoToolsBuildEnvironment(self)
        autotools.flags = [f"-O{self.options.optimisation}"]
        if self.options.debug:
            autotools.flags += ["-g"]
        build_env = autotools.vars
        build_env["MLX_FOLDER"] = self._source_subfolder
        autotools.make(args=["shared" if self.options.shared else "static", "-j"],vars=build_env)

    def package(self):
        self.copy(os.path.join(self._source_subfolder, "mlx.h"), dst="include", keep_path=False)
        self.copy("libmlx.so", dst="lib")
        self.copy("libmlx.a", dst="lib")

    def package_info(self):
        self.cpp_info.libs = ["mlx", "Xext", "Xpm", "X11"]
