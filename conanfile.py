from conans import ConanFile
from conans import tools

class MinilibXConan(ConanFile):
    name = "minilibx"
    version = "2.0"
    license = "MIT"
    author = "agagniere sid.xxdzs@gmail.com"
    url = "https://github.com/agagniere/MinilibX"
    description = "Simple X11 interface"
    topics = ("conan", "x11")
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False], "fPIC": [True, False]}
    default_options = {"shared": True, "fPIC": True}
    generators = "make"
    requires = "xorg/system"

    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC

    def source(self):
        self.run("git clone " + self.url + " .")

    def build(self):
        self.run("bash ./configure")
        self.run("make")

    def package(self):
        self.copy("mlx.h", dst="include")
        self.copy("*.so", dst="lib", keep_path=False)
        self.copy("*.a", dst="lib", keep_path=False)

    def package_info(self):
        self.cpp_info.libs = ["minilibx"]
