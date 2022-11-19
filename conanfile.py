from conan import ConanFile
from conan.tools.gnu import Autotools, AutotoolsToolchain, AutotoolsDeps
from conan.errors import ConanInvalidConfiguration
import os

class MinilibXConan(ConanFile):
    name = "minilibx"
    version = "1.3"
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
        "debug": [True, False],
        "package_doc": [True, False]
    }
    default_options = {
        "shared": True,
        "fPIC": False,
        "optimisation": '2',
        "debug": True,
        "package_doc": False
    }
    exports_sources = 'X11*.[ch]', 'sierra*.[chm]', 'Makefile'

    def validate(self):
        if self.settings.os not in ["Macos", "Linux"]:
            raise ConanInvalidConfiguration(f"OS {self.settings.os} not supported")

    def requirements(self):
        if self.settings.os == "Linux":
            self.requires("xorg/system")
        else: # MacOS
            self.requires("opengl/system")

    def build_requirements(self):
        if self.options.package_doc:
            self.tool_requires("doctools/system")

    @property
    def _source_subfolder(self):
        if self.settings.os == "Linux":
            return "X11"
        else:
            return "sierra"
        # MacOS < 11
        #    return "elcapitan"

    def configure(self):
        if self.options.shared:
            self.options.fPIC = True
            #self.options.rm_safe("fPIC")
        self.settings.rm_safe("compiler.libcxx")
        self.settings.rm_safe("compiler.cppstd")


    def generate(self):
        toolchain = AutotoolsToolchain(self)
        toolchain.extra_cflags += [f"-O{self.options.optimisation}"]
        if self.options.debug:
            toolchain.extra_cflags += ["-g"]
        if self.settings.os == "Macos":
            toolchain.extra_ldflags = ["-framework AppKit"]
        toolchain.make_args = [f"MLX_FOLDER={self._source_subfolder}"]
        toolchain.generate()
        AutotoolsDeps(self).generate()

    def build(self):
        autotools = Autotools(self)
        autotools.make("shared" if self.options.shared else "static")
        if self.options.package_doc:
            autotools.make('doc')

    def package(self):
        self.copy(os.path.join(self._source_subfolder, "mlx.h"), dst="include", keep_path=False)
        self.copy("libmlx.so", dst="lib")
        self.copy("libmlx.a", dst="lib")
        self.copy("*.pdf", dst="doc")
        self.copy("*.3", dst="doc")
        self.copy(os.path.join(self._source_subfolder, "README.md"), dst="doc", keep_path=False)
        self.copy("README.md")

    def package_info(self):
        self.cpp_info.libs = ["mlx"]
        if self.settings.os == "Macos":
            self.cpp_info.frameworks.append("AppKit")
