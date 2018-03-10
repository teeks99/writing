Title:  "Working with Props Files"
Date:   2018-03-06 12:08:56 -0600


Visual Studio/MSBuild props files are handy little settings files that can be included

    <Import Project="path\to\file.props" />

in vcxproj files or other props files.

These can simply define variables

    <?xml version="1.0" encoding="utf-8"?>
    <Project DefaultTargets="Build" ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
      <PropertyGroup>
        <MyIncludePath>C:/Path/To/Include</MyIncludePath>
        <MyLibPath>C:/Path/To/Lib</MyLibPath>
      </PropertyGroup>
    </Project>

Which can then be used in a .vcxproj that has already imported that props file with the variables `$(MyIncludePath)` and `$(MyLibPath)`, for example:

    <ClCompile>
      <AdditionalIncludeDirectories>..\local\inc;$(MyIncludePath);%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>
      <RuntimeLibrary>MultiThreadedDebug</RuntimeLibrary>
    </ClCompile>
    <Link>
      <SubSystem>Console</SubSystem>
      <AdditionalLibraryDirectories>$(MyLibPath);%(AdditionalLibraryDirectories)</AdditionalLibraryDirectories>
      <AdditionalDependencies>%(AdditionalDependencies)</AdditionalDependencies>
    </Link>

These variables can build on each other as well, a line further down the file can use variables from a line above it. 

    <PropertyGroup>
      <FirstPath>path/to/first</FirstPath>
      <SecondPath>path/to/second</SecondPath>
      <AllPaths>$(FirstPath);$(SecondPath)</AllPaths>
    </PropertyGroup>

Groups, like [PropertyGroup](https://docs.microsoft.com/en-us/visualstudio/msbuild/propertygroup-element-msbuild), [ItemDefinitionGroup](https://docs.microsoft.com/en-us/visualstudio/msbuild/itemdefinitiongroup-element-msbuild)s, etc. can also have [Conditions](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-conditions). These conditions often take the form of `Condition="'stringA'=='stringB'"`, which can be very useful when using variables, including those added by msbuild/visual studio.

    <PropertyGroup Condition="'$(PlatformToolset)'=='v100'">
      <MyVersion>msvc-10.0</MyVersion>
    </PropertyGroup>
    <PropertyGroup Condition="'$(PlatformToolset)'=='v140'">
      <MyVersion>msvc-14.0</MyVersion>
    </PropertyGroup>

The above will set `MyVersion` to a value specific to the platform toolset that visual studio is using to build the code. This is defined by default in .vcxproj files. Because it gets defined in the .vcxproj, using it requires that the props file isn't imported until after the variable it depends on has been defined. Where this happens isn't particularly ovbious, so a good rule of thumb is to import user props files after the provided `<PropertyGroup Label="UserMacros" /> line. 

It is common that one would like to append new values to existing variables like for the include path, library search path, etc. Look through the [CL Task Parameters](https://docs.microsoft.com/en-us/visualstudio/msbuild/cl-task) and [Link Task Parameters](https://docs.microsoft.com/en-us/visualstudio/msbuild/link-task) for more. Since these already exist they need to be appended to instead of set. For example:

    <AdditionalIncludeDirectories>path/to/dir;$(PathInVar);%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>

Here the name of the variable is included at the end with a percent sign `%` in front of it. That tells it to use the existing one at the end. 

For the CL and Link options, they cannot be set as variables in property groups, they need to match up with the existing variables in the heirarchy. Specifically:

    <ItemDefinitionGroup>
      <ClCompile>
        <AdditionalIncludeDirectories>path/to/dir;$(PathInVar);%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>
        <PreprocessorDefinitions>SOMETHING_DEFINED;%(PreprocessorDefinitions)</PreprocessorDefinitions>
      </ClCompile>
      <Link>
        <AdditionalLibraryDirectories>path/to/libs;$(PathInVar);%(AdditionalLibraryDirectories)</AdditionalLibraryDirectories>
        <AdditionalDependencies>my.lib;%(AdditionalDependencies)</AdditionalDependencies>
      </Link>
    </ItemDefinitionGroup>

It can also look at empty/unset variables and set default options for them. For example, we want to have a `libmy.lib` named `libmyd.lib` if it is being built with the `$(MyLibConf)` variable set to Debug. However, it is common that users who are building a project with the `$(Configuration)` set to Debug will also want this, and we don't want them to be forced to specify our `$(MyLibConf)` in this case. So we can detect if it is empty *and* the `$(Configuration)` is set to debug, then add the `d` suffix. 

    <PropertyGroup Condition="'$(MyLibConf)'=='' and '$(Configuration)'=='Debug'">
      <MyLibConf>Debug</MyLibConf>
    </PropertyGroup>

    <PropertyGroup Condition="'$(MyLibConf)'=='Debug'">
      <MyLibSuffix>d</MyLibSuffix>
    </PropertyGroup>

    <PropertyGroup>
      <MyLibName>libmy$(MyLibSuffix).lib</MyLibName>
    </PropertyGroup>

