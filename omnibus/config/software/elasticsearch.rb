#
# Copyright:: Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "elasticsearch"
default_version "7.9.1"

dependency "server-open-jre"

license "Apache-2.0"
license_file "LICENSE.txt"
skip_transitive_dependency_licensing true

relative_path "elasticsearch-#{version}"

version "6.8.18" do
  source url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-#{version}.tar.gz",
         sha512: "11981c316b65e7d407b85dffd70506a5f08b472b064f8f382d9a864f220b63792bf8f23b5e2485627f49f21d2ee5a966542e8c955acc4b3ac37094750e7c409c"
end

version "7.9.3" do
  source url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-#{version}-linux-x86_64.tar.gz",
         sha512: "bb02a5dc1caef97638a959ebba05dd649083c856334f30c670b851067292d7230e561d8759b15a80be73537d7a7efd9cef427d253cbb2efdbd6b168c6f9baa13"
end

version "7.9.1" do
  source url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-#{version}-linux-x86_64.tar.gz",
         sha512: "e24aab0fbeb0b53cc386bb0ca1fc84c457851c5d80d147324bf97ff42f063332a93dec3c693550662393a72c7a0522a100181dd9a7d50b3e487a0f2a2a9bbcc0"
end

target_path = "#{install_dir}/embedded/elasticsearch"

build do
  mkdir  "#{target_path}"
  delete "#{project_dir}/lib/sigar/*solaris*"
  delete "#{project_dir}/lib/sigar/*sparc*"
  delete "#{project_dir}/lib/sigar/*freebsd*"
  delete "#{project_dir}/config"
  delete "#{project_dir}/jdk"
  delete "#{project_dir}/modules/x-pack-ml"
  delete "#{project_dir}/modules/ingest-geoip"
  mkdir  "#{project_dir}/plugins"
  # by default RPMs will not include empty directories in the final package
  # ES will fail to start if this dir is not present.
  touch  "#{project_dir}/plugins/.gitkeep"

  sync   "#{project_dir}/", "#{target_path}"

  # Dropping a VERSION file here allows additional software definitions
  # to read it to determine ES plugin compatibility.
  command "echo #{version} > #{target_path}/VERSION"
end
