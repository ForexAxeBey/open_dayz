-- ****************************************************************************
-- *
-- *  PROJECT:     $name here
-- *  FILE:        tools/generate_gettext_pot.lua
-- *  PURPOSE:     Gettext .pot generation script
-- *
-- ****************************************************************************

require "lfs"
local DEBUG = false

potGen = {
	directories = {
		server = "../open_dayz/server";
		client = "../open_dayz/client";
		shared = "../open_dayz/shared";
	};
}

function potGen.generate()
	for output, directory in pairs(potGen.directories) do
		print("Processing "..directory.." now!")
		print("   Output: "..output..".po")

		local listFile = io.open(output..".tmp", "w+")
		local fileList = potGen.getFileList(directory)
		for k, path in ipairs(fileList) do
			listFile:write(path.."\n")
		end
		listFile:close()
		
		os.execute(("./lt-xgettext -f %s.tmp -d %s --language=Lua --from-code=UTF-8 --keyword=_ --package-name=%s --package-version=%s"):format(output, output, "OpenMTADayZ", "1.0"))

		if not DEBUG then
			os.remove(output..".tmp")
		end
	end
	
end

function potGen.getFileList(directory)
	local files = {}
	for fname in lfs.dir(directory) do
		if not ( fname == "." or fname == ".." ) then
			fullname = directory.."/"..fname
			att = lfs.attributes(fullname)
			if att.mode == "file" then
				if fullname:sub(-4) == ".lua" then
					files[#files+1] = fullname
				end
			elseif att.mode == "directory" then
				local subfiles = potGen.getFileList(fullname)
				for k, v in pairs(subfiles) do
					files[#files+1] = v
				end
			end
		end
	end
	return files
end

potGen.generate()
