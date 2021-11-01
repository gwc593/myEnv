#!/bin/bash

#Author: Guy Collins
#Date: 11/05/2021
#Description:   a script to set up a boiler plate for cpp development with full vim debugging support and 
#               basic project setup.  The current folder name will be used as the project name, in the 
#               future, this could be a command line option.


#basic variables
currentFolder=${PWD##*/}

cmakeFile='CMakeLists.txt'
cmakeVersion='3.16'
setupCMakeFile='setupCMake.sh'
cwd=${PWD}/build
vimspectorFile='.vimspector.json'

helloWorldFile='src/main.cpp'

readMeFile='README.md'
gitignoreFile='.gitignore'

#generate empty files and folders
mkdir src include build
touch ${cmakeFile}
touch ${vimspectorFile}
touch ${helloWorldFile}
touch ${readMeFile}
touch ${gitignoreFile}
touch ${setupCMakeFile}

#add symbolic link for YouCompleteMe Compatability
ln -s build/compile_commands.json

#generate basic cmake file
echo "cmake_minimum_required(VERSION ${cmakeVersion})" >> ${cmakeFile}
echo "project(${currentFolder})" >> ${cmakeFile}
echo "set(CMAKE_EXPORT_COMPILE_COMMANDS ON)" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "if(NOT CMAKE_BUILD_TYPE)" >> ${cmakeFile}
echo "	set(CMAKE_BUILD_TYPE Release)" >> ${cmakeFile}
echo "endif()" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG \${CMAKE_BINARY_DIR}/debug)" >> ${cmakeFile}
echo "set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE \${CMAKE_BINARY_DIR}/release)" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "if(NOT DEFINED BUILD_SVE)" >> ${cmakeFile}
echo "	set(BUILD_SVE FALSE)" >> ${cmakeFile}
echo "endif()" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "if(NOT DEFINED BUILD_ARM)" >> ${cmakeFile}
echo "	set(BUILD_ARM FALSE)" >> ${cmakeFile}
echo "endif()" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "if(BUILD_SVE)" >> ${cmakeFile}
echo "	set(ARM_MARCH \"\${ARM_MARCH}+sve2+sve2-bitperm\")" >> ${cmakeFile}
echo "	set(ARM_Defs \"\${ARM_Defs} -DHAVE_SVE -DHAVE_SVE2\")" >> ${cmakeFile}
echo "endif()" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "if(BUILD_ARM)" >> ${cmakeFile}
echo "	set(CMAKE_C_COMPILER \${LLVM_INSTALL}/sve2-llvm-compilation-tools/bin/clang)" >> ${cmakeFile}
echo "	set(CMAKE_CXX_COMPILER \${LLVM_INSTALL}/sve2-llvm-compilation-tools/bin/clang++)    " >> ${cmakeFile}
echo "	set(CMAKE_EXE_LINKER_FLAGS \"--sysroot=\${LLVM_INSTALL}/sve2-llvm-compilation-tools -B\${GNU_LINKER_INSTALL}/aarch64-none-elf/bin -target aarch64-none-elf -gline-tables-only -march=armv8-a\${ARM_MARCH} -v\")" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "	set(optionalCXXFlags \"-target aarch64-none-elf -gline-tables-only -fcommon -mllvm -enable-load-pre=false -mllvm -runtime-memory-check-threshold=40  -fsigned-char --sysroot=\${LLVM_INSTALL}/sve2-llvm-compilation-tools/ -march=armv8-a\${ARM_MARCH} -Wall -Wextra\")" >> ${cmakeFile}
echo "	set(ARM_Defs \"\${ARM_Defs} -DSEMIHOSTING -D__ARM_ARCH_ISA_A64 -DHAVE_SIMD -DHAVE_FVP -DHAVE_ORGANIC_LLVM -DENABLE_CONST_OPT=0 -DENABLE_INLINE=1 -DENABLE_DEBUG_LOG=0 -DENABLE_ENFORCE_F32_SRC_IMAGE=0\")" >> ${cmakeFile}
echo "	set(ARM_Includes \"\${LLVM_INSTALL}/sve2-llvm-compilation-tools/.tools/toolchain/opt/aarch64-newlib/aarch64-elf/include/c++/aarch64-elf\")" >> ${cmakeFile}
echo "endif()" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "set(CMAKE_CXX_STANDARD 11)  # or newer" >> ${cmakeFile}
echo "set(CMAKE_CXX_STANDARD_REQUIRED YES)" >> ${cmakeFile}
echo "set(CMAKE_CXX_EXTENSIONS NO)" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "set(CMAKE_CXX_FLAGS_DEBUG \"\${optionalCXXFlags} -g -O0 -Wall\")" >> ${cmakeFile}
echo "set(CMAKE_CXX_FLAGS_RELEASE \"\${optionalCXXFlags} -O3 -Wall\")" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "set(SRC  " >> ${cmakeFile}
echo "	\"src/main.cpp\")" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "add_definitions(\${ARM_Defs})" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "link_directories(\"\")" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "include_directories(\${ARM_Includes} \"include\")" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "add_executable(\${CMAKE_PROJECT_NAME} \${SRC})" >> ${cmakeFile}
echo "" >> ${cmakeFile}
echo "target_link_libraries(\${CMAKE_PROJECT_NAME})" >> ${cmakeFile}

#generate vimspector cpp configuration for gdb adapter creation
echo "{" >> ${vimspectorFile}
echo "    \"configurations\":{" >> ${vimspectorFile}
echo "        \"Launch\": {" >> ${vimspectorFile}
echo "            \"adapter\": \"vscode-cpptools\"," >> ${vimspectorFile}
echo "            \"configuration\": {" >> ${vimspectorFile}
echo "                \"request\": \"launch\"," >> ${vimspectorFile}
echo "                \"program\": \"\${workspaceRoot}/build/debug/${currentFolder}\"," >> ${vimspectorFile}
echo "                \"args\": [] ," >> ${vimspectorFile}
echo "                \"cwd\": \"\${workspaceRoot}\"," >> ${vimspectorFile}
echo "                \"externalConsole\": true," >> ${vimspectorFile}
echo "                \"MIMode\": \"gdb\"" >> ${vimspectorFile}
echo "            }" >> ${vimspectorFile}
echo "        }" >> ${vimspectorFile}
echo "    }" >> ${vimspectorFile}
echo "}" >> ${vimspectorFile}

#generate hello world
echo "#include<stdio.h>" >> ${helloWorldFile}
echo "#include<iostream>" >> ${helloWorldFile}
echo "#include<vector>" >> ${helloWorldFile}
echo "#include<string>" >> ${helloWorldFile}
echo " " >> ${helloWorldFile}
echo "int main()" >> ${helloWorldFile}
echo "{" >> ${helloWorldFile}
echo "    std::vector<std::string> msg;" >> ${helloWorldFile}
echo " " >> ${helloWorldFile}
echo "    msg.push_back(\"hello \");" >> ${helloWorldFile}
echo "    msg.push_back(\"world\");" >> ${helloWorldFile}
echo " " >> ${helloWorldFile}
echo "    for(auto word: msg){" >> ${helloWorldFile}
echo "        std::cout << word;" >> ${helloWorldFile}
echo "    }" >> ${helloWorldFile}
echo "    std::cout << std::endl;" >> ${helloWorldFile}
echo " " >> ${helloWorldFile}
echo "    return 0;" >> ${helloWorldFile}
echo "}" >> ${helloWorldFile}

#generate gitignore file
echo "${vimspectorFile}" >> ${gitignoreFile}
echo "build" >> ${gitignoreFile}

#generate setupCMake file
echo "#!/bin/bash" >> ${setupCMakeFile}
echo "" >> ${setupCMakeFile}
echo "#toolchain intallation" >> ${setupCMakeFile}
echo "llmvInstalLoc=\"/home/guycol01/Installs/llvm_install/2.0.239-238\"" >> ${setupCMakeFile}
echo "gnuLinkerInstall=\"/home/guycol01/Installs/GNU_Linker/gcc-arm-9.2-2019.12-x86_64-aarch64-none-elf\"" >> ${setupCMakeFile}
echo "" >> ${setupCMakeFile}
echo "#clean up" >> ${setupCMakeFile}
echo "rm -fr build" >> ${setupCMakeFile}
echo "mkdir build && cd build" >> ${setupCMakeFile}
echo "" >> ${setupCMakeFile}
echo "#execute cmake" >> ${setupCMakeFile}
echo "cmake \\" >> ${setupCMakeFile}
echo "    -DCMAKE_BUILD_TYPE=Release \\" >> ${setupCMakeFile}
echo "    -DBUILD_ARM=false \\" >> ${setupCMakeFile}
echo "    -DBUILD_SVE=false \\" >> ${setupCMakeFile}
echo "    -DLLVM_INSTALL=\${llmvInstalLoc} \\" >> ${setupCMakeFile}
echo "	-DGNU_LINKER_INSTALL=\${gnuLinkerInstall} \\" >> ${setupCMakeFile}
echo "    .." >> ${setupCMakeFile}

chmod +x ${setupCMakeFile}
