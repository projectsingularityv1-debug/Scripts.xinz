-- ==================================================================
--  Anti-Detection Bypass Layer (Dex-style)
--  Randomized names, cloneref services, gethui/protectgui hiding
-- ==================================================================

local _writefile = (typeof(writefile) == "function" and writefile) or nil
local _isfile = (typeof(isfile) == "function" and isfile) or nil
local _makefolder = (typeof(makefolder) == "function" and makefolder) or nil
local _getcustomasset = (typeof(getcustomasset) == "function" and getcustomasset) or nil

-- Ensure cache directory exists
if _makefolder and not _isfile("XINZ_Cache") then
	pcall(function() _makefolder("XINZ_Cache") end)
end

local function GetAsset(assetInput)
	if not _isfile or not _getcustomasset then return "rbxassetid://" .. tostring(assetInput) end
	if typeof(assetInput) ~= "string" and typeof(assetInput) ~= "number" then return "" end
	
	local assetStr = tostring(assetInput)
	
	-- Clean up rbxassetid prefix if passed accidentally
	if assetStr:match("^rbxassetid://") then
		assetStr = assetStr:gsub("rbxassetid://", "")
	end
	
	-- 1. Check local workspace folders first (The assets the user provided)
	local possiblePaths = {
		"XINZ_Cache/" .. assetStr .. ".png",
		"XINZ_UI_Assets/" .. assetStr .. ".png",
		"XINZ-UI-Cache/" .. assetStr .. ".png",
		"XINZ_Cache/" .. assetStr,
		"XINZ_UI_Assets/" .. assetStr,
		"XINZ-UI-Cache/" .. assetStr
	}
	
	for _, path in ipairs(possiblePaths) do
		if _isfile(path) then
			return _getcustomasset(path)
		end
	end
	
	-- 2. If it's a GitHub URL or a Web URL, we need to download it and cache it locally
	if assetStr:match("^http") then
		local fileId = assetStr:match("%d+") or assetStr:gsub("[^%w]", ""):sub(-15)
		local fileName = "XINZ_Cache/" .. fileId .. ".png"
		
		if _isfile(fileName) then
			return _getcustomasset(fileName)
		end
		
		-- Download and save asynchronously
		if _writefile then
			task.spawn(function()
				pcall(function()
					local imgData = ""
					if _request then
						local res = _request({Url = assetStr, Method = "GET"})
						if res and res.StatusCode == 200 then imgData = res.Body end
					else
						imgData = game:HttpGet(assetStr)
					end
					
					if imgData and #imgData > 0 then
						_makefolder("XINZ_Cache")
						_writefile(fileName, imgData)
					end
				end)
			end)
		end
		
		return assetStr
	end
	
	-- 3. If we don't have it locally, return an empty string to strictly avoid Anti-Cheat rbxassetid detection
	return ""
end

local success, Compkiller = pcall(function()
	return (function()
--[[
    		Compkiller Interface

    Author: 4lpaca
    License: MIT
    Github: https://github.com/4lpaca-pin/CompKiller
    Original: compkiller.net

        Version: 2.6
    - Improved Performance Mode
    	Compkiller:OptimizeMode(< boolean >)
  	- Added Auto Color Logo
		Compkiller:CustomIconHighlight()
--]]

--- Export Types ---

export type cloneref = (target: Instance) -> Instance;

export type Window = {
	Name: string,
	Keybind: string | Enum.KeyCode,
	Logo: string,
	Scale: UDim2,
	TextSize: number
};

export type ConfigManager = {
	Directory: string,
	Config: string,
};

export type WriteConfig = {
	Name: string,
	Author: string,
};

export type WindowUpdate = {
	Username: string,
	ExpireDate: string,
	Logo: string,
	WindowName: string,
	UserProfile: string
};

export type ConfigFunctions = {
	Directory: string,
	WriteConfig: (self: ConfigFunctions , Config: WriteConfig) -> any?,
	ReadInfo: (self: ConfigFunctions , ConfigName: string) -> any?,
	DeleteConfig: (self: ConfigFunctions , ConfigName: string) -> any?,
	LoadConfig: (self: ConfigFunctions , ConfigName: string) -> any?,
	GetConfigs: (self: ConfigFunctions , ConfigName: string) -> {string},
	GetConfigCount: (self: ConfigFunctions) -> number,
	GetFullConfigs: (self: ConfigFunctions , ConfigName: string) -> {
		{
			Name: string,
			Info: {
				Type: string,
				Author: string,
				Name: string,
				CreatedDate: string,
			}
		}	
	},
};

export type KeybindSettings = {
	Key : string,
	On : boolean | number,
	Off : boolean | number,
	Mode : number,
	Name : string,
}

export type SecurityConfig = {
	BlurEnabled : boolean,
	ImageScale: number,
};

export type Notify = {
	Icon: string,
	Title: string,
	Content: string,
	Duration: number
};

export type NotifyPayback = {
	SetProgress: (self: Notify , time: number) -> any?,
	Content: (self: Notify , str: string) -> any?,
	Title: (self: Notify , str: string) -> any?,
	Close: () -> any?,
}

export type Watermark = {
	Icon: string,
	Text: string
};

export type TabConfig = {
	Name: string,
	Icon: string,
	Type: string,
	EnableScrolling: boolean
};

export type TabConfigManager = {
	Name: string,
	Icon: string,
	Config: ConfigFunctions
}

export type ContainerTab = {
	Name: string,
	Icon: string,
	EnableScrolling: boolean
};

export type Category = {
	Name: string
};

export type Section = {
	Name: string,
	Position: string
};

export type Toggle = {
	Name: string,
	Default: boolean,
	Flag: string | nil,
	Risky: boolean,
	Callback: (Value: boolean) -> any?
};

export type MiniToggle = {
	Default: boolean,
	Flag: string | nil,
	Callback: (Value: boolean) -> any?
};

export type TextBoxConfig = {
	Name: string,
	Default: string,
	Placeholder: string,
	Flag: string | nil,
	Numeric: boolean,
	Callback: (Text: string) -> any?
};

export type ColorPicker = {
	Name: string,
	Default: Color3,
	Flag: string | nil,
	Transparency: number,
	Callback: (Value: Color3 , Trans: number) -> any?
};

export type MiniColorPicker = {
	Default: Color3,
	Transparency: number,
	Flag: string | nil,
	Callback: (Value: Color3 , Trans: number) -> any?
};

export type Slider = {
	Name: string,
	Min: number,
	Max: number,
	Default: number,
	Type: string,
	Round: number,
	Callback: (Value: number) -> any?
};

export type Dropdown = {
	Name: string,
	Default: string | {string},
	Values: {string},
	Multi: boolean,
	Callback: (Value: string | {[string]: boolean}) -> any?
};

export type Button = {
	Name: string,
	Callback: () -> any?
};

export type Keybind = {
	Name: string,
	Default: string | Enum.KeyCode,
	Callback: (Value: string) -> any,
	Blacklist: {string | Enum.KeyCode}
};

export type MiniKeybind = {
	Default: string | Enum.KeyCode,
	Callback: (Value: string) -> any,
	Blacklist: {string | Enum.KeyCode}
};

export type Helper = {
	Text: string
};

export type Paragraph = {
	Title: string,
	Content: string
}

pcall(function() -- for Luraph
	local Constant = table.concat({"LP","H_NO"}).."_VI".."RTU".."AL".."IZE";
	getfenv()[Constant] = getfenv()[Constant] or function(f) return f end; 
	-- LPH_NO_VIRTUALIZE
end);

pcall(function() -- for IB1
	local Constant = "IB".."_NO_VI".."RTU".."AL".."IZE";
	getfenv()[Constant] = getfenv()[Constant] or function(f) return f end; 
	-- IB_NO_VIRTUALIZE
end);

getgenv = getgenv or getfenv;

-- Please ignore the ugly code. [Custom File System] --
if game:GetService('RunService'):IsStudio() then
	local BaseWorkspace = Instance.new('Folder',game:GetService("ReplicatedFirst"));

	BaseWorkspace.Name = tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)));

	local __get_path_c = function(path)
		return (string.find(path,'/',1,true) and string.split(path,'/')) or (string.find(path,'\\',1,true) and string.split(path,'\\')) or {path};
	end;

	local __get_path = function(path)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			block = block[v];
		end;

		return block;
	end;

	getgenv().readfile = function(path)
		local path : StringValue = __get_path(path);

		return path.Value;
	end;

	getgenv().isfile = function(path)
		local success , message = pcall(function()
			return __get_path(path);
		end);

		if success and not message:IsA("Folder") then
			return true;
		end;

		return false;
	end;

	getgenv().isfolder = function(path)
		local success , message = pcall(function()
			return __get_path(path);
		end);

		if success and message:IsA("Folder") then
			return true;
		end;

		return false;
	end;

	getgenv().writefile = function(path,content)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if not item then
				local c = Instance.new('StringValue',block);

				c.Name = tostring(v);
				c.Value = content;
			else
				if item:IsA('StringValue') and tostring(item) == v then
					item.Name = tostring(v);
					item.Value = content;
				end;

				block = item;
			end;
		end;
	end;

	getgenv().listfiles = function(path)
		local fold = __get_path(path);
		local pa = {};

		for i,v in next , fold:GetChildren() do
			if v:IsA('StringValue') then
				table.insert(pa,path..'/'..tostring(v));
			end;
		end;

		return pa;
	end;

	getgenv().makefolder = function(path)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if not item then
				local c = Instance.new('Folder',block);

				c.Name = tostring(v);
			else
				block = item;
			end;
		end;
	end;

	getgenv().delfile = function(path)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if item and item:IsA('StringValue') then
				item:Destroy();
			else
				block = item;
			end;
		end;
	end;
end;

--- Local Variables ---
local cloneref: cloneref = cloneref or function(f) return f end;
local TweenService: TweenService = cloneref(game:GetService('TweenService'));
local UserInputService: UserInputService = cloneref(game:GetService('UserInputService'));
local TextService: TextService = cloneref(game:GetService('TextService'));
local RunService: RunService = cloneref(game:GetService('RunService'));
local Players: Players = cloneref(game:GetService('Players'));
local HttpService: HttpService = cloneref(game:GetService('HttpService'));
local LocalPlayer: Player = Players.LocalPlayer;
local CoreGui: PlayerGui = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or cloneref(game:FindFirstChild('CoreGui')) or cloneref(LocalPlayer.PlayerGui);
local Mouse: Mouse = LocalPlayer:GetMouse();
local CurrentCamera: Camera? = cloneref(workspace.CurrentCamera);

local Compkiller = {
	Version = '2.6',
	Logo = GetAsset("120245531583106"),
	Windows = {},
	Scale = {
		Window = UDim2.new(0, 485,0, 565),
		Mobile = UDim2.new(0, 450,0, 375),
		TabOpen = 185,
		TabClose = 85,
	},
	PerformanceMode = false,
	WindowsNil = {},
	NilFolder = Instance.new('Folder'),
	ArcylicParent = CurrentCamera,
	ProtectGui = protect_gui or protectgui or (syn and syn.protect_gui) or function(s) return s; end,
};

Compkiller.Colors = {
	Highlight = Color3.fromRGB(17, 238, 253),
	Toggle = Color3.fromRGB(14, 203, 213),
	Risky = Color3.fromRGB(251, 255, 39),
	BGDBColor = Color3.fromRGB(22, 24, 29),
	BlockColor = Color3.fromRGB(28, 29, 34),
	StrokeColor = Color3.fromRGB(37, 38, 43),
	SwitchColor = Color3.fromRGB(255, 255, 255),
	DropColor = Color3.fromRGB(33, 35, 39),
	MouseEnter = Color3.fromRGB(55, 58, 65),
	BlockBackground = Color3.fromRGB(39, 40, 47),
	LineColor = Color3.fromRGB(65, 65, 65),
	HighStrokeColor = Color3.fromRGB(55, 56, 63),
};

Compkiller.Elements = {
	Highlight = {},
	DropHighlight = {},
	Risky = {},
	BGDBColor = {},
	BlockColor = {},
	StrokeColor = {},
	SwitchColor = {},
	DropColor = {},
	BlockBackground = {},
	LineColor = {},
	HighStrokeColor = {},
};

Compkiller.DragBlacklist = {};
Compkiller.IaDrag = false;
Compkiller.LastDrag = tick();
Compkiller.Flags = {};

Compkiller.Lucide = {
	['lucide-mouse-2'] = GetAsset("10088146939"),
	['lucide-internet'] = GetAsset("12785195438"),
	['lucide-earth'] = GetAsset("115986292591138"),
	['lucide-settings-3'] = GetAsset("14007344336"),
	["lucide-accessibility"] = GetAsset("10709751939"),
	["lucide-activity"] = GetAsset("10709752035"),
	["lucide-air-vent"] = GetAsset("10709752131"),
	["lucide-airplay"] = GetAsset("10709752254"),
	["lucide-alarm-check"] = GetAsset("10709752405"),
	["lucide-alarm-clock"] = GetAsset("10709752630"),
	["lucide-alarm-clock-off"] = GetAsset("10709752508"),
	["lucide-alarm-minus"] = GetAsset("10709752732"),
	["lucide-alarm-plus"] = GetAsset("10709752825"),
	["lucide-album"] = GetAsset("10709752906"),
	["lucide-alert-circle"] = GetAsset("10709752996"),
	["lucide-alert-octagon"] = GetAsset("10709753064"),
	["lucide-alert-triangle"] = GetAsset("10709753149"),
	["lucide-align-center"] = GetAsset("10709753570"),
	["lucide-align-center-horizontal"] = GetAsset("10709753272"),
	["lucide-align-center-vertical"] = GetAsset("10709753421"),
	["lucide-align-end-horizontal"] = GetAsset("10709753692"),
	["lucide-align-end-vertical"] = GetAsset("10709753808"),
	["lucide-align-horizontal-distribute-center"] = GetAsset("10747779791"),
	["lucide-align-horizontal-distribute-end"] = GetAsset("10747784534"),
	["lucide-align-horizontal-distribute-start"] = GetAsset("10709754118"),
	["lucide-align-horizontal-justify-center"] = GetAsset("10709754204"),
	["lucide-align-horizontal-justify-end"] = GetAsset("10709754317"),
	["lucide-align-horizontal-justify-start"] = GetAsset("10709754436"),
	["lucide-align-horizontal-space-around"] = GetAsset("10709754590"),
	["lucide-align-horizontal-space-between"] = GetAsset("10709754749"),
	["lucide-align-justify"] = GetAsset("10709759610"),
	["lucide-align-left"] = GetAsset("10709759764"),
	["lucide-align-right"] = GetAsset("10709759895"),
	["lucide-align-start-horizontal"] = GetAsset("10709760051"),
	["lucide-align-start-vertical"] = GetAsset("10709760244"),
	["lucide-align-vertical-distribute-center"] = GetAsset("10709760351"),
	["lucide-align-vertical-distribute-end"] = GetAsset("10709760434"),
	["lucide-align-vertical-distribute-start"] = GetAsset("10709760612"),
	["lucide-align-vertical-justify-center"] = GetAsset("10709760814"),
	["lucide-align-vertical-justify-end"] = GetAsset("10709761003"),
	["lucide-align-vertical-justify-start"] = GetAsset("10709761176"),
	["lucide-align-vertical-space-around"] = GetAsset("10709761324"),
	["lucide-align-vertical-space-between"] = GetAsset("10709761434"),
	["lucide-anchor"] = GetAsset("10709761530"),
	["lucide-angry"] = GetAsset("10709761629"),
	["lucide-annoyed"] = GetAsset("10709761722"),
	["lucide-aperture"] = GetAsset("10709761813"),
	["lucide-apple"] = GetAsset("10709761889"),
	["lucide-archive"] = GetAsset("10709762233"),
	["lucide-archive-restore"] = GetAsset("10709762058"),
	["lucide-armchair"] = GetAsset("10709762327"),
	["lucide-arrow-big-down"] = GetAsset("10747796644"),
	["lucide-arrow-big-left"] = GetAsset("10709762574"),
	["lucide-arrow-big-right"] = GetAsset("10709762727"),
	["lucide-arrow-big-up"] = GetAsset("10709762879"),
	["lucide-arrow-down"] = GetAsset("10709767827"),
	["lucide-arrow-down-circle"] = GetAsset("10709763034"),
	["lucide-arrow-down-left"] = GetAsset("10709767656"),
	["lucide-arrow-down-right"] = GetAsset("10709767750"),
	["lucide-arrow-left"] = GetAsset("10709768114"),
	["lucide-arrow-left-circle"] = GetAsset("10709767936"),
	["lucide-arrow-left-right"] = GetAsset("10709768019"),
	["lucide-arrow-right"] = GetAsset("10709768347"),
	["lucide-arrow-right-circle"] = GetAsset("10709768226"),
	["lucide-arrow-up"] = GetAsset("10709768939"),
	["lucide-arrow-up-circle"] = GetAsset("10709768432"),
	["lucide-arrow-up-down"] = GetAsset("10709768538"),
	["lucide-arrow-up-left"] = GetAsset("10709768661"),
	["lucide-arrow-up-right"] = GetAsset("10709768787"),
	["lucide-asterisk"] = GetAsset("10709769095"),
	["lucide-at-sign"] = GetAsset("10709769286"),
	["lucide-award"] = GetAsset("10709769406"),
	["lucide-axe"] = GetAsset("10709769508"),
	["lucide-axis-3d"] = GetAsset("10709769598"),
	["lucide-baby"] = GetAsset("10709769732"),
	["lucide-backpack"] = GetAsset("10709769841"),
	["lucide-baggage-claim"] = GetAsset("10709769935"),
	["lucide-banana"] = GetAsset("10709770005"),
	["lucide-banknote"] = GetAsset("10709770178"),
	["lucide-bar-chart"] = GetAsset("10709773755"),
	["lucide-bar-chart-2"] = GetAsset("10709770317"),
	["lucide-bar-chart-3"] = GetAsset("10709770431"),
	["lucide-bar-chart-4"] = GetAsset("10709770560"),
	["lucide-bar-chart-horizontal"] = GetAsset("10709773669"),
	["lucide-barcode"] = GetAsset("10747360675"),
	["lucide-baseline"] = GetAsset("10709773863"),
	["lucide-bath"] = GetAsset("10709773963"),
	["lucide-battery"] = GetAsset("10709774640"),
	["lucide-battery-charging"] = GetAsset("10709774068"),
	["lucide-battery-full"] = GetAsset("10709774206"),
	["lucide-battery-low"] = GetAsset("10709774370"),
	["lucide-battery-medium"] = GetAsset("10709774513"),
	["lucide-beaker"] = GetAsset("10709774756"),
	["lucide-bed"] = GetAsset("10709775036"),
	["lucide-bed-double"] = GetAsset("10709774864"),
	["lucide-bed-single"] = GetAsset("10709774968"),
	["lucide-beer"] = GetAsset("10709775167"),
	["lucide-bell"] = GetAsset("10709775704"),
	["lucide-bell-minus"] = GetAsset("10709775241"),
	["lucide-bell-off"] = GetAsset("10709775320"),
	["lucide-bell-plus"] = GetAsset("10709775448"),
	["lucide-bell-ring"] = GetAsset("10709775560"),
	["lucide-bike"] = GetAsset("10709775894"),
	["lucide-binary"] = GetAsset("10709776050"),
	["lucide-bitcoin"] = GetAsset("10709776126"),
	["lucide-bluetooth"] = GetAsset("10709776655"),
	["lucide-bluetooth-connected"] = GetAsset("10709776240"),
	["lucide-bluetooth-off"] = GetAsset("10709776344"),
	["lucide-bluetooth-searching"] = GetAsset("10709776501"),
	["lucide-bold"] = GetAsset("10747813908"),
	["lucide-bomb"] = GetAsset("10709781460"),
	["lucide-bone"] = GetAsset("10709781605"),
	["lucide-book"] = GetAsset("10709781824"),
	["lucide-book-open"] = GetAsset("10709781717"),
	["lucide-bookmark"] = GetAsset("10709782154"),
	["lucide-bookmark-minus"] = GetAsset("10709781919"),
	["lucide-bookmark-plus"] = GetAsset("10709782044"),
	["lucide-bot"] = GetAsset("10709782230"),
	["lucide-box"] = GetAsset("10709782497"),
	["lucide-box-select"] = GetAsset("10709782342"),
	["lucide-boxes"] = GetAsset("10709782582"),
	["lucide-briefcase"] = GetAsset("10709782662"),
	["lucide-brush"] = GetAsset("10709782758"),
	["lucide-bug"] = GetAsset("10709782845"),
	["lucide-building"] = GetAsset("10709783051"),
	["lucide-building-2"] = GetAsset("10709782939"),
	["lucide-bus"] = GetAsset("10709783137"),
	["lucide-cake"] = GetAsset("10709783217"),
	["lucide-calculator"] = GetAsset("10709783311"),
	["lucide-calendar"] = GetAsset("10709789505"),
	["lucide-calendar-check"] = GetAsset("10709783474"),
	["lucide-calendar-check-2"] = GetAsset("10709783392"),
	["lucide-calendar-clock"] = GetAsset("10709783577"),
	["lucide-calendar-days"] = GetAsset("10709783673"),
	["lucide-calendar-heart"] = GetAsset("10709783835"),
	["lucide-calendar-minus"] = GetAsset("10709783959"),
	["lucide-calendar-off"] = GetAsset("10709788784"),
	["lucide-calendar-plus"] = GetAsset("10709788937"),
	["lucide-calendar-range"] = GetAsset("10709789053"),
	["lucide-calendar-search"] = GetAsset("10709789200"),
	["lucide-calendar-x"] = GetAsset("10709789407"),
	["lucide-calendar-x-2"] = GetAsset("10709789329"),
	["lucide-camera"] = GetAsset("10709789686"),
	["lucide-camera-off"] = GetAsset("10747822677"),
	["lucide-car"] = GetAsset("10709789810"),
	["lucide-carrot"] = GetAsset("10709789960"),
	["lucide-cast"] = GetAsset("10709790097"),
	["lucide-charge"] = GetAsset("10709790202"),
	["lucide-check"] = GetAsset("10709790644"),
	["lucide-check-circle"] = GetAsset("10709790387"),
	["lucide-check-circle-2"] = GetAsset("10709790298"),
	["lucide-check-square"] = GetAsset("10709790537"),
	["lucide-chef-hat"] = GetAsset("10709790757"),
	["lucide-cherry"] = GetAsset("10709790875"),
	["lucide-chevron-down"] = GetAsset("10709790948"),
	["lucide-chevron-first"] = GetAsset("10709791015"),
	["lucide-chevron-last"] = GetAsset("10709791130"),
	["lucide-chevron-left"] = GetAsset("10709791281"),
	["lucide-chevron-right"] = GetAsset("10709791437"),
	["lucide-chevron-up"] = GetAsset("10709791523"),
	["lucide-chevrons-down"] = GetAsset("10709796864"),
	["lucide-chevrons-down-up"] = GetAsset("10709791632"),
	["lucide-chevrons-left"] = GetAsset("10709797151"),
	["lucide-chevrons-left-right"] = GetAsset("10709797006"),
	["lucide-chevrons-right"] = GetAsset("10709797382"),
	["lucide-chevrons-right-left"] = GetAsset("10709797274"),
	["lucide-chevrons-up"] = GetAsset("10709797622"),
	["lucide-chevrons-up-down"] = GetAsset("10709797508"),
	["lucide-chrome"] = GetAsset("10709797725"),
	["lucide-circle"] = GetAsset("10709798174"),
	["lucide-circle-dot"] = GetAsset("10709797837"),
	["lucide-circle-ellipsis"] = GetAsset("10709797985"),
	["lucide-circle-slashed"] = GetAsset("10709798100"),
	["lucide-citrus"] = GetAsset("10709798276"),
	["lucide-clapperboard"] = GetAsset("10709798350"),
	["lucide-clipboard"] = GetAsset("10709799288"),
	["lucide-clipboard-check"] = GetAsset("10709798443"),
	["lucide-clipboard-copy"] = GetAsset("10709798574"),
	["lucide-clipboard-edit"] = GetAsset("10709798682"),
	["lucide-clipboard-list"] = GetAsset("10709798792"),
	["lucide-clipboard-signature"] = GetAsset("10709798890"),
	["lucide-clipboard-type"] = GetAsset("10709798999"),
	["lucide-clipboard-x"] = GetAsset("10709799124"),
	["lucide-clock"] = GetAsset("10709805144"),
	["lucide-clock-1"] = GetAsset("10709799535"),
	["lucide-clock-10"] = GetAsset("10709799718"),
	["lucide-clock-11"] = GetAsset("10709799818"),
	["lucide-clock-12"] = GetAsset("10709799962"),
	["lucide-clock-2"] = GetAsset("10709803876"),
	["lucide-clock-3"] = GetAsset("10709803989"),
	["lucide-clock-4"] = GetAsset("10709804164"),
	["lucide-clock-5"] = GetAsset("10709804291"),
	["lucide-clock-6"] = GetAsset("10709804435"),
	["lucide-clock-7"] = GetAsset("10709804599"),
	["lucide-clock-8"] = GetAsset("10709804784"),
	["lucide-clock-9"] = GetAsset("10709804996"),
	["lucide-cloud"] = GetAsset("10709806740"),
	["lucide-cloud-cog"] = GetAsset("10709805262"),
	["lucide-cloud-drizzle"] = GetAsset("10709805371"),
	["lucide-cloud-fog"] = GetAsset("10709805477"),
	["lucide-cloud-hail"] = GetAsset("10709805596"),
	["lucide-cloud-lightning"] = GetAsset("10709805727"),
	["lucide-cloud-moon"] = GetAsset("10709805942"),
	["lucide-cloud-moon-rain"] = GetAsset("10709805838"),
	["lucide-cloud-off"] = GetAsset("10709806060"),
	["lucide-cloud-rain"] = GetAsset("10709806277"),
	["lucide-cloud-rain-wind"] = GetAsset("10709806166"),
	["lucide-cloud-snow"] = GetAsset("10709806374"),
	["lucide-cloud-sun"] = GetAsset("10709806631"),
	["lucide-cloud-sun-rain"] = GetAsset("10709806475"),
	["lucide-cloudy"] = GetAsset("10709806859"),
	["lucide-clover"] = GetAsset("10709806995"),
	["lucide-code"] = GetAsset("10709810463"),
	["lucide-code-2"] = GetAsset("10709807111"),
	["lucide-codepen"] = GetAsset("10709810534"),
	["lucide-codesandbox"] = GetAsset("10709810676"),
	["lucide-coffee"] = GetAsset("10709810814"),
	["lucide-cog"] = GetAsset("10709810948"),
	["lucide-coins"] = GetAsset("10709811110"),
	["lucide-columns"] = GetAsset("10709811261"),
	["lucide-command"] = GetAsset("10709811365"),
	["lucide-compass"] = GetAsset("10709811445"),
	["lucide-component"] = GetAsset("10709811595"),
	["lucide-concierge-bell"] = GetAsset("10709811706"),
	["lucide-connection"] = GetAsset("10747361219"),
	["lucide-contact"] = GetAsset("10709811834"),
	["lucide-contrast"] = GetAsset("10709811939"),
	["lucide-cookie"] = GetAsset("10709812067"),
	["lucide-copy"] = GetAsset("10709812159"),
	["lucide-copyleft"] = GetAsset("10709812251"),
	["lucide-copyright"] = GetAsset("10709812311"),
	["lucide-corner-down-left"] = GetAsset("10709812396"),
	["lucide-corner-down-right"] = GetAsset("10709812485"),
	["lucide-corner-left-down"] = GetAsset("10709812632"),
	["lucide-corner-left-up"] = GetAsset("10709812784"),
	["lucide-corner-right-down"] = GetAsset("10709812939"),
	["lucide-corner-right-up"] = GetAsset("10709813094"),
	["lucide-corner-up-left"] = GetAsset("10709813185"),
	["lucide-corner-up-right"] = GetAsset("10709813281"),
	["lucide-cpu"] = GetAsset("10709813383"),
	["lucide-croissant"] = GetAsset("10709818125"),
	["lucide-crop"] = GetAsset("10709818245"),
	["lucide-cross"] = GetAsset("10709818399"),
	["lucide-crosshair"] = GetAsset("10709818534"),
	["lucide-crown"] = GetAsset("10709818626"),
	["lucide-cup-soda"] = GetAsset("10709818763"),
	["lucide-curly-braces"] = GetAsset("10709818847"),
	["lucide-currency"] = GetAsset("10709818931"),
	["lucide-database"] = GetAsset("10709818996"),
	["lucide-delete"] = GetAsset("10709819059"),
	["lucide-diamond"] = GetAsset("10709819149"),
	["lucide-dice-1"] = GetAsset("10709819266"),
	["lucide-dice-2"] = GetAsset("10709819361"),
	["lucide-dice-3"] = GetAsset("10709819508"),
	["lucide-dice-4"] = GetAsset("10709819670"),
	["lucide-dice-5"] = GetAsset("10709819801"),
	["lucide-dice-6"] = GetAsset("10709819896"),
	["lucide-dices"] = GetAsset("10723343321"),
	["lucide-diff"] = GetAsset("10723343416"),
	["lucide-disc"] = GetAsset("10723343537"),
	["lucide-divide"] = GetAsset("10723343805"),
	["lucide-divide-circle"] = GetAsset("10723343636"),
	["lucide-divide-square"] = GetAsset("10723343737"),
	["lucide-dollar-sign"] = GetAsset("10723343958"),
	["lucide-download"] = GetAsset("10723344270"),
	["lucide-download-cloud"] = GetAsset("10723344088"),
	["lucide-droplet"] = GetAsset("10723344432"),
	["lucide-droplets"] = GetAsset("10734883356"),
	["lucide-drumstick"] = GetAsset("10723344737"),
	["lucide-edit"] = GetAsset("10734883598"),
	["lucide-edit-2"] = GetAsset("10723344885"),
	["lucide-edit-3"] = GetAsset("10723345088"),
	["lucide-egg"] = GetAsset("10723345518"),
	["lucide-egg-fried"] = GetAsset("10723345347"),
	["lucide-electricity"] = GetAsset("10723345749"),
	["lucide-electricity-off"] = GetAsset("10723345643"),
	["lucide-equal"] = GetAsset("10723345990"),
	["lucide-equal-not"] = GetAsset("10723345866"),
	["lucide-eraser"] = GetAsset("10723346158"),
	["lucide-euro"] = GetAsset("10723346372"),
	["lucide-expand"] = GetAsset("10723346553"),
	["lucide-external-link"] = GetAsset("10723346684"),
	["lucide-eye"] = GetAsset("10723346959"),
	["lucide-eye-off"] = GetAsset("10723346871"),
	["lucide-factory"] = GetAsset("10723347051"),
	["lucide-fan"] = GetAsset("10723354359"),
	["lucide-fast-forward"] = GetAsset("10723354521"),
	["lucide-feather"] = GetAsset("10723354671"),
	["lucide-figma"] = GetAsset("10723354801"),
	["lucide-file"] = GetAsset("10723374641"),
	["lucide-file-archive"] = GetAsset("10723354921"),
	["lucide-file-audio"] = GetAsset("10723355148"),
	["lucide-file-audio-2"] = GetAsset("10723355026"),
	["lucide-file-axis-3d"] = GetAsset("10723355272"),
	["lucide-file-badge"] = GetAsset("10723355622"),
	["lucide-file-badge-2"] = GetAsset("10723355451"),
	["lucide-file-bar-chart"] = GetAsset("10723355887"),
	["lucide-file-bar-chart-2"] = GetAsset("10723355746"),
	["lucide-file-box"] = GetAsset("10723355989"),
	["lucide-file-check"] = GetAsset("10723356210"),
	["lucide-file-check-2"] = GetAsset("10723356100"),
	["lucide-file-clock"] = GetAsset("10723356329"),
	["lucide-file-code"] = GetAsset("10723356507"),
	["lucide-file-cog"] = GetAsset("10723356830"),
	["lucide-file-cog-2"] = GetAsset("10723356676"),
	["lucide-file-diff"] = GetAsset("10723357039"),
	["lucide-file-digit"] = GetAsset("10723357151"),
	["lucide-file-down"] = GetAsset("10723357322"),
	["lucide-file-edit"] = GetAsset("10723357495"),
	["lucide-file-heart"] = GetAsset("10723357637"),
	["lucide-file-image"] = GetAsset("10723357790"),
	["lucide-file-input"] = GetAsset("10723357933"),
	["lucide-file-json"] = GetAsset("10723364435"),
	["lucide-file-json-2"] = GetAsset("10723364361"),
	["lucide-file-key"] = GetAsset("10723364605"),
	["lucide-file-key-2"] = GetAsset("10723364515"),
	["lucide-file-line-chart"] = GetAsset("10723364725"),
	["lucide-file-lock"] = GetAsset("10723364957"),
	["lucide-file-lock-2"] = GetAsset("10723364861"),
	["lucide-file-minus"] = GetAsset("10723365254"),
	["lucide-file-minus-2"] = GetAsset("10723365086"),
	["lucide-file-output"] = GetAsset("10723365457"),
	["lucide-file-pie-chart"] = GetAsset("10723365598"),
	["lucide-file-plus"] = GetAsset("10723365877"),
	["lucide-file-plus-2"] = GetAsset("10723365766"),
	["lucide-file-question"] = GetAsset("10723365987"),
	["lucide-file-scan"] = GetAsset("10723366167"),
	["lucide-file-search"] = GetAsset("10723366550"),
	["lucide-file-search-2"] = GetAsset("10723366340"),
	["lucide-file-signature"] = GetAsset("10723366741"),
	["lucide-file-spreadsheet"] = GetAsset("10723366962"),
	["lucide-file-symlink"] = GetAsset("10723367098"),
	["lucide-file-terminal"] = GetAsset("10723367244"),
	["lucide-file-text"] = GetAsset("10723367380"),
	["lucide-file-type"] = GetAsset("10723367606"),
	["lucide-file-type-2"] = GetAsset("10723367509"),
	["lucide-file-up"] = GetAsset("10723367734"),
	["lucide-file-video"] = GetAsset("10723373884"),
	["lucide-file-video-2"] = GetAsset("10723367834"),
	["lucide-file-volume"] = GetAsset("10723374172"),
	["lucide-file-volume-2"] = GetAsset("10723374030"),
	["lucide-file-warning"] = GetAsset("10723374276"),
	["lucide-file-x"] = GetAsset("10723374544"),
	["lucide-file-x-2"] = GetAsset("10723374378"),
	["lucide-files"] = GetAsset("10723374759"),
	["lucide-film"] = GetAsset("10723374981"),
	["lucide-filter"] = GetAsset("10723375128"),
	["lucide-fingerprint"] = GetAsset("10723375250"),
	["lucide-flag"] = GetAsset("10723375890"),
	["lucide-flag-off"] = GetAsset("10723375443"),
	["lucide-flag-triangle-left"] = GetAsset("10723375608"),
	["lucide-flag-triangle-right"] = GetAsset("10723375727"),
	["lucide-flame"] = GetAsset("10723376114"),
	["lucide-flashlight"] = GetAsset("10723376471"),
	["lucide-flashlight-off"] = GetAsset("10723376365"),
	["lucide-flask-conical"] = GetAsset("10734883986"),
	["lucide-flask-round"] = GetAsset("10723376614"),
	["lucide-flip-horizontal"] = GetAsset("10723376884"),
	["lucide-flip-horizontal-2"] = GetAsset("10723376745"),
	["lucide-flip-vertical"] = GetAsset("10723377138"),
	["lucide-flip-vertical-2"] = GetAsset("10723377026"),
	["lucide-flower"] = GetAsset("10747830374"),
	["lucide-flower-2"] = GetAsset("10723377305"),
	["lucide-focus"] = GetAsset("10723377537"),
	["lucide-folder"] = GetAsset("10723387563"),
	["lucide-folder-archive"] = GetAsset("10723384478"),
	["lucide-folder-check"] = GetAsset("10723384605"),
	["lucide-folder-clock"] = GetAsset("10723384731"),
	["lucide-folder-closed"] = GetAsset("10723384893"),
	["lucide-folder-cog"] = GetAsset("10723385213"),
	["lucide-folder-cog-2"] = GetAsset("10723385036"),
	["lucide-folder-down"] = GetAsset("10723385338"),
	["lucide-folder-edit"] = GetAsset("10723385445"),
	["lucide-folder-heart"] = GetAsset("10723385545"),
	["lucide-folder-input"] = GetAsset("10723385721"),
	["lucide-folder-key"] = GetAsset("10723385848"),
	["lucide-folder-lock"] = GetAsset("10723386005"),
	["lucide-folder-minus"] = GetAsset("10723386127"),
	["lucide-folder-open"] = GetAsset("10723386277"),
	["lucide-folder-output"] = GetAsset("10723386386"),
	["lucide-folder-plus"] = GetAsset("10723386531"),
	["lucide-folder-search"] = GetAsset("10723386787"),
	["lucide-folder-search-2"] = GetAsset("10723386674"),
	["lucide-folder-symlink"] = GetAsset("10723386930"),
	["lucide-folder-tree"] = GetAsset("10723387085"),
	["lucide-folder-up"] = GetAsset("10723387265"),
	["lucide-folder-x"] = GetAsset("10723387448"),
	["lucide-folders"] = GetAsset("10723387721"),
	["lucide-form-input"] = GetAsset("10723387841"),
	["lucide-forward"] = GetAsset("10723388016"),
	["lucide-frame"] = GetAsset("10723394389"),
	["lucide-framer"] = GetAsset("10723394565"),
	["lucide-frown"] = GetAsset("10723394681"),
	["lucide-fuel"] = GetAsset("10723394846"),
	["lucide-function-square"] = GetAsset("10723395041"),
	["lucide-gamepad"] = GetAsset("10723395457"),
	["lucide-gamepad-2"] = GetAsset("10723395215"),
	["lucide-gauge"] = GetAsset("10723395708"),
	["lucide-gavel"] = GetAsset("10723395896"),
	["lucide-gem"] = GetAsset("10723396000"),
	["lucide-ghost"] = GetAsset("10723396107"),
	["lucide-gift"] = GetAsset("10723396402"),
	["lucide-gift-card"] = GetAsset("10723396225"),
	["lucide-git-branch"] = GetAsset("10723396676"),
	["lucide-git-branch-plus"] = GetAsset("10723396542"),
	["lucide-git-commit"] = GetAsset("10723396812"),
	["lucide-git-compare"] = GetAsset("10723396954"),
	["lucide-git-fork"] = GetAsset("10723397049"),
	["lucide-git-merge"] = GetAsset("10723397165"),
	["lucide-git-pull-request"] = GetAsset("10723397431"),
	["lucide-git-pull-request-closed"] = GetAsset("10723397268"),
	["lucide-git-pull-request-draft"] = GetAsset("10734884302"),
	["lucide-glass"] = GetAsset("10723397788"),
	["lucide-glass-2"] = GetAsset("10723397529"),
	["lucide-glass-water"] = GetAsset("10723397678"),
	["lucide-glasses"] = GetAsset("10723397895"),
	["lucide-globe"] = GetAsset("10723404337"),
	["lucide-globe-2"] = GetAsset("10723398002"),
	["lucide-grab"] = GetAsset("10723404472"),
	["lucide-graduation-cap"] = GetAsset("10723404691"),
	["lucide-grape"] = GetAsset("10723404822"),
	["lucide-grid"] = GetAsset("10723404936"),
	["lucide-grip-horizontal"] = GetAsset("10723405089"),
	["lucide-grip-vertical"] = GetAsset("10723405236"),
	["lucide-hammer"] = GetAsset("10723405360"),
	["lucide-hand"] = GetAsset("10723405649"),
	["lucide-hand-metal"] = GetAsset("10723405508"),
	["lucide-hard-drive"] = GetAsset("10723405749"),
	["lucide-hard-hat"] = GetAsset("10723405859"),
	["lucide-hash"] = GetAsset("10723405975"),
	["lucide-haze"] = GetAsset("10723406078"),
	["lucide-headphones"] = GetAsset("10723406165"),
	["lucide-heart"] = GetAsset("10723406885"),
	["lucide-heart-crack"] = GetAsset("10723406299"),
	["lucide-heart-handshake"] = GetAsset("10723406480"),
	["lucide-heart-off"] = GetAsset("10723406662"),
	["lucide-heart-pulse"] = GetAsset("10723406795"),
	["lucide-help-circle"] = GetAsset("10723406988"),
	["lucide-hexagon"] = GetAsset("10723407092"),
	["lucide-highlighter"] = GetAsset("10723407192"),
	["lucide-history"] = GetAsset("10723407335"),
	["lucide-home"] = GetAsset("10723407389"),
	["lucide-hourglass"] = GetAsset("10723407498"),
	["lucide-ice-cream"] = GetAsset("10723414308"),
	["lucide-image"] = GetAsset("10723415040"),
	["lucide-image-minus"] = GetAsset("10723414487"),
	["lucide-image-off"] = GetAsset("10723414677"),
	["lucide-image-plus"] = GetAsset("10723414827"),
	["lucide-import"] = GetAsset("10723415205"),
	["lucide-inbox"] = GetAsset("10723415335"),
	["lucide-indent"] = GetAsset("10723415494"),
	["lucide-indian-rupee"] = GetAsset("10723415642"),
	["lucide-infinity"] = GetAsset("10723415766"),
	["lucide-info"] = GetAsset("10723415903"),
	["lucide-inspect"] = GetAsset("10723416057"),
	["lucide-italic"] = GetAsset("10723416195"),
	["lucide-japanese-yen"] = GetAsset("10723416363"),
	["lucide-joystick"] = GetAsset("10723416527"),
	["lucide-key"] = GetAsset("10723416652"),
	["lucide-keyboard"] = GetAsset("10723416765"),
	["lucide-lamp"] = GetAsset("10723417513"),
	["lucide-lamp-ceiling"] = GetAsset("10723416922"),
	["lucide-lamp-desk"] = GetAsset("10723417016"),
	["lucide-lamp-floor"] = GetAsset("10723417131"),
	["lucide-lamp-wall-down"] = GetAsset("10723417240"),
	["lucide-lamp-wall-up"] = GetAsset("10723417356"),
	["lucide-landmark"] = GetAsset("10723417608"),
	["lucide-languages"] = GetAsset("10723417703"),
	["lucide-laptop"] = GetAsset("10723423881"),
	["lucide-laptop-2"] = GetAsset("10723417797"),
	["lucide-lasso"] = GetAsset("10723424235"),
	["lucide-lasso-select"] = GetAsset("10723424058"),
	["lucide-laugh"] = GetAsset("10723424372"),
	["lucide-layers"] = GetAsset("10723424505"),
	["lucide-layout"] = GetAsset("10723425376"),
	["lucide-layout-dashboard"] = GetAsset("10723424646"),
	["lucide-layout-grid"] = GetAsset("10723424838"),
	["lucide-layout-list"] = GetAsset("10723424963"),
	["lucide-layout-template"] = GetAsset("10723425187"),
	["lucide-leaf"] = GetAsset("10723425539"),
	["lucide-library"] = GetAsset("10723425615"),
	["lucide-life-buoy"] = GetAsset("10723425685"),
	["lucide-lightbulb"] = GetAsset("10723425852"),
	["lucide-lightbulb-off"] = GetAsset("10723425762"),
	["lucide-line-chart"] = GetAsset("10723426393"),
	["lucide-link"] = GetAsset("10723426722"),
	["lucide-link-2"] = GetAsset("10723426595"),
	["lucide-link-2-off"] = GetAsset("10723426513"),
	["lucide-list"] = GetAsset("10723433811"),
	["lucide-list-checks"] = GetAsset("10734884548"),
	["lucide-list-end"] = GetAsset("10723426886"),
	["lucide-list-minus"] = GetAsset("10723426986"),
	["lucide-list-music"] = GetAsset("10723427081"),
	["lucide-list-ordered"] = GetAsset("10723427199"),
	["lucide-list-plus"] = GetAsset("10723427334"),
	["lucide-list-start"] = GetAsset("10723427494"),
	["lucide-list-video"] = GetAsset("10723427619"),
	["lucide-list-x"] = GetAsset("10723433655"),
	["lucide-loader"] = GetAsset("10723434070"),
	["lucide-loader-2"] = GetAsset("10723433935"),
	["lucide-locate"] = GetAsset("10723434557"),
	["lucide-locate-fixed"] = GetAsset("10723434236"),
	["lucide-locate-off"] = GetAsset("10723434379"),
	["lucide-lock"] = GetAsset("10723434711"),
	["lucide-log-in"] = GetAsset("10723434830"),
	["lucide-log-out"] = GetAsset("10723434906"),
	["lucide-luggage"] = GetAsset("10723434993"),
	["lucide-magnet"] = GetAsset("10723435069"),
	["lucide-mail"] = GetAsset("10734885430"),
	["lucide-mail-check"] = GetAsset("10723435182"),
	["lucide-mail-minus"] = GetAsset("10723435261"),
	["lucide-mail-open"] = GetAsset("10723435342"),
	["lucide-mail-plus"] = GetAsset("10723435443"),
	["lucide-mail-question"] = GetAsset("10723435515"),
	["lucide-mail-search"] = GetAsset("10734884739"),
	["lucide-mail-warning"] = GetAsset("10734885015"),
	["lucide-mail-x"] = GetAsset("10734885247"),
	["lucide-mails"] = GetAsset("10734885614"),
	["lucide-map"] = GetAsset("10734886202"),
	["lucide-map-pin"] = GetAsset("10734886004"),
	["lucide-map-pin-off"] = GetAsset("10734885803"),
	["lucide-maximize"] = GetAsset("10734886735"),
	["lucide-maximize-2"] = GetAsset("10734886496"),
	["lucide-medal"] = GetAsset("10734887072"),
	["lucide-megaphone"] = GetAsset("10734887454"),
	["lucide-megaphone-off"] = GetAsset("10734887311"),
	["lucide-meh"] = GetAsset("10734887603"),
	["lucide-menu"] = GetAsset("10734887784"),
	["lucide-message-circle"] = GetAsset("10734888000"),
	["lucide-message-square"] = GetAsset("10734888228"),
	["lucide-mic"] = GetAsset("10734888864"),
	["lucide-mic-2"] = GetAsset("10734888430"),
	["lucide-mic-off"] = GetAsset("10734888646"),
	["lucide-microscope"] = GetAsset("10734889106"),
	["lucide-microwave"] = GetAsset("10734895076"),
	["lucide-milestone"] = GetAsset("10734895310"),
	["lucide-minimize"] = GetAsset("10734895698"),
	["lucide-minimize-2"] = GetAsset("10734895530"),
	["lucide-minus"] = GetAsset("10734896206"),
	["lucide-minus-circle"] = GetAsset("10734895856"),
	["lucide-minus-square"] = GetAsset("10734896029"),
	["lucide-monitor"] = GetAsset("10734896881"),
	["lucide-monitor-off"] = GetAsset("10734896360"),
	["lucide-monitor-speaker"] = GetAsset("10734896512"),
	["lucide-moon"] = GetAsset("10734897102"),
	["lucide-more-horizontal"] = GetAsset("10734897250"),
	["lucide-more-vertical"] = GetAsset("10734897387"),
	["lucide-mountain"] = GetAsset("10734897956"),
	["lucide-mountain-snow"] = GetAsset("10734897665"),
	["lucide-mouse"] = GetAsset("10734898592"),
	["lucide-mouse-pointer"] = GetAsset("10734898476"),
	["lucide-mouse-pointer-2"] = GetAsset("10734898194"),
	["lucide-mouse-pointer-click"] = GetAsset("10734898355"),
	["lucide-move"] = GetAsset("10734900011"),
	["lucide-move-3d"] = GetAsset("10734898756"),
	["lucide-move-diagonal"] = GetAsset("10734899164"),
	["lucide-move-diagonal-2"] = GetAsset("10734898934"),
	["lucide-move-horizontal"] = GetAsset("10734899414"),
	["lucide-move-vertical"] = GetAsset("10734899821"),
	["lucide-music"] = GetAsset("10734905958"),
	["lucide-music-2"] = GetAsset("10734900215"),
	["lucide-music-3"] = GetAsset("10734905665"),
	["lucide-music-4"] = GetAsset("10734905823"),
	["lucide-navigation"] = GetAsset("10734906744"),
	["lucide-navigation-2"] = GetAsset("10734906332"),
	["lucide-navigation-2-off"] = GetAsset("10734906144"),
	["lucide-navigation-off"] = GetAsset("10734906580"),
	["lucide-network"] = GetAsset("10734906975"),
	["lucide-newspaper"] = GetAsset("10734907168"),
	["lucide-octagon"] = GetAsset("10734907361"),
	["lucide-option"] = GetAsset("10734907649"),
	["lucide-outdent"] = GetAsset("10734907933"),
	["lucide-package"] = GetAsset("10734909540"),
	["lucide-package-2"] = GetAsset("10734908151"),
	["lucide-package-check"] = GetAsset("10734908384"),
	["lucide-package-minus"] = GetAsset("10734908626"),
	["lucide-package-open"] = GetAsset("10734908793"),
	["lucide-package-plus"] = GetAsset("10734909016"),
	["lucide-package-search"] = GetAsset("10734909196"),
	["lucide-package-x"] = GetAsset("10734909375"),
	["lucide-paint-bucket"] = GetAsset("10734909847"),
	["lucide-paintbrush"] = GetAsset("10734910187"),
	["lucide-paintbrush-2"] = GetAsset("10734910030"),
	["lucide-palette"] = GetAsset("10734910430"),
	["lucide-palmtree"] = GetAsset("10734910680"),
	["lucide-paperclip"] = GetAsset("10734910927"),
	["lucide-party-popper"] = GetAsset("10734918735"),
	["lucide-pause"] = GetAsset("10734919336"),
	["lucide-pause-circle"] = GetAsset("10735024209"),
	["lucide-pause-octagon"] = GetAsset("10734919143"),
	["lucide-pen-tool"] = GetAsset("10734919503"),
	["lucide-pencil"] = GetAsset("10734919691"),
	["lucide-percent"] = GetAsset("10734919919"),
	["lucide-person-standing"] = GetAsset("10734920149"),
	["lucide-phone"] = GetAsset("10734921524"),
	["lucide-phone-call"] = GetAsset("10734920305"),
	["lucide-phone-forwarded"] = GetAsset("10734920508"),
	["lucide-phone-incoming"] = GetAsset("10734920694"),
	["lucide-phone-missed"] = GetAsset("10734920845"),
	["lucide-phone-off"] = GetAsset("10734921077"),
	["lucide-phone-outgoing"] = GetAsset("10734921288"),
	["lucide-pie-chart"] = GetAsset("10734921727"),
	["lucide-piggy-bank"] = GetAsset("10734921935"),
	["lucide-pin"] = GetAsset("10734922324"),
	["lucide-pin-off"] = GetAsset("10734922180"),
	["lucide-pipette"] = GetAsset("10734922497"),
	["lucide-pizza"] = GetAsset("10734922774"),
	["lucide-plane"] = GetAsset("10734922971"),
	["lucide-play"] = GetAsset("10734923549"),
	["lucide-play-circle"] = GetAsset("10734923214"),
	["lucide-plus"] = GetAsset("10734924532"),
	["lucide-plus-circle"] = GetAsset("10734923868"),
	["lucide-plus-square"] = GetAsset("10734924219"),
	["lucide-podcast"] = GetAsset("10734929553"),
	["lucide-pointer"] = GetAsset("10734929723"),
	["lucide-pound-sterling"] = GetAsset("10734929981"),
	["lucide-power"] = GetAsset("10734930466"),
	["lucide-power-off"] = GetAsset("10734930257"),
	["lucide-printer"] = GetAsset("10734930632"),
	["lucide-puzzle"] = GetAsset("10734930886"),
	["lucide-quote"] = GetAsset("10734931234"),
	["lucide-radio"] = GetAsset("10734931596"),
	["lucide-radio-receiver"] = GetAsset("10734931402"),
	["lucide-rectangle-horizontal"] = GetAsset("10734931777"),
	["lucide-rectangle-vertical"] = GetAsset("10734932081"),
	["lucide-recycle"] = GetAsset("10734932295"),
	["lucide-redo"] = GetAsset("10734932822"),
	["lucide-redo-2"] = GetAsset("10734932586"),
	["lucide-refresh-ccw"] = GetAsset("10734933056"),
	["lucide-refresh-cw"] = GetAsset("10734933222"),
	["lucide-refrigerator"] = GetAsset("10734933465"),
	["lucide-regex"] = GetAsset("10734933655"),
	["lucide-repeat"] = GetAsset("10734933966"),
	["lucide-repeat-1"] = GetAsset("10734933826"),
	["lucide-reply"] = GetAsset("10734934252"),
	["lucide-reply-all"] = GetAsset("10734934132"),
	["lucide-rewind"] = GetAsset("10734934347"),
	["lucide-rocket"] = GetAsset("10734934585"),
	["lucide-rocking-chair"] = GetAsset("10734939942"),
	["lucide-rotate-3d"] = GetAsset("10734940107"),
	["lucide-rotate-ccw"] = GetAsset("10734940376"),
	["lucide-rotate-cw"] = GetAsset("10734940654"),
	["lucide-rss"] = GetAsset("10734940825"),
	["lucide-ruler"] = GetAsset("10734941018"),
	["lucide-russian-ruble"] = GetAsset("10734941199"),
	["lucide-sailboat"] = GetAsset("10734941354"),
	["lucide-save"] = GetAsset("10734941499"),
	["lucide-scale"] = GetAsset("10734941912"),
	["lucide-scale-3d"] = GetAsset("10734941739"),
	["lucide-scaling"] = GetAsset("10734942072"),
	["lucide-scan"] = GetAsset("10734942565"),
	["lucide-scan-face"] = GetAsset("10734942198"),
	["lucide-scan-line"] = GetAsset("10734942351"),
	["lucide-scissors"] = GetAsset("10734942778"),
	["lucide-screen-share"] = GetAsset("10734943193"),
	["lucide-screen-share-off"] = GetAsset("10734942967"),
	["lucide-scroll"] = GetAsset("10734943448"),
	["lucide-search"] = GetAsset("10734943674"),
	["lucide-send"] = GetAsset("10734943902"),
	["lucide-separator-horizontal"] = GetAsset("10734944115"),
	["lucide-separator-vertical"] = GetAsset("10734944326"),
	["lucide-server"] = GetAsset("10734949856"),
	["lucide-server-cog"] = GetAsset("10734944444"),
	["lucide-server-crash"] = GetAsset("10734944554"),
	["lucide-server-off"] = GetAsset("10734944668"),
	["lucide-settings"] = GetAsset("10734950309"),
	["lucide-settings-2"] = GetAsset("10734950020"),
	["lucide-share"] = GetAsset("10734950813"),
	["lucide-share-2"] = GetAsset("10734950553"),
	["lucide-sheet"] = GetAsset("10734951038"),
	["lucide-shield"] = GetAsset("10734951847"),
	["lucide-shield-alert"] = GetAsset("10734951173"),
	["lucide-shield-check"] = GetAsset("10734951367"),
	["lucide-shield-close"] = GetAsset("10734951535"),
	["lucide-shield-off"] = GetAsset("10734951684"),
	["lucide-shirt"] = GetAsset("10734952036"),
	["lucide-shopping-bag"] = GetAsset("10734952273"),
	["lucide-shopping-cart"] = GetAsset("10734952479"),
	["lucide-shovel"] = GetAsset("10734952773"),
	["lucide-shower-head"] = GetAsset("10734952942"),
	["lucide-shrink"] = GetAsset("10734953073"),
	["lucide-shrub"] = GetAsset("10734953241"),
	["lucide-shuffle"] = GetAsset("10734953451"),
	["lucide-sidebar"] = GetAsset("10734954301"),
	["lucide-sidebar-close"] = GetAsset("10734953715"),
	["lucide-sidebar-open"] = GetAsset("10734954000"),
	["lucide-sigma"] = GetAsset("10734954538"),
	["lucide-signal"] = GetAsset("10734961133"),
	["lucide-signal-high"] = GetAsset("10734954807"),
	["lucide-signal-low"] = GetAsset("10734955080"),
	["lucide-signal-medium"] = GetAsset("10734955336"),
	["lucide-signal-zero"] = GetAsset("10734960878"),
	["lucide-siren"] = GetAsset("10734961284"),
	["lucide-skip-back"] = GetAsset("10734961526"),
	["lucide-skip-forward"] = GetAsset("10734961809"),
	["lucide-skull"] = GetAsset("10734962068"),
	["lucide-slack"] = GetAsset("10734962339"),
	["lucide-slash"] = GetAsset("10734962600"),
	["lucide-slice"] = GetAsset("10734963024"),
	["lucide-sliders"] = GetAsset("10734963400"),
	["lucide-sliders-horizontal"] = GetAsset("10734963191"),
	["lucide-smartphone"] = GetAsset("10734963940"),
	["lucide-smartphone-charging"] = GetAsset("10734963671"),
	["lucide-smile"] = GetAsset("10734964441"),
	["lucide-smile-plus"] = GetAsset("10734964188"),
	["lucide-snowflake"] = GetAsset("10734964600"),
	["lucide-sofa"] = GetAsset("10734964852"),
	["lucide-sort-asc"] = GetAsset("10734965115"),
	["lucide-sort-desc"] = GetAsset("10734965287"),
	["lucide-speaker"] = GetAsset("10734965419"),
	["lucide-sprout"] = GetAsset("10734965572"),
	["lucide-square"] = GetAsset("10734965702"),
	["lucide-star"] = GetAsset("10734966248"),
	["lucide-star-half"] = GetAsset("10734965897"),
	["lucide-star-off"] = GetAsset("10734966097"),
	["lucide-stethoscope"] = GetAsset("10734966384"),
	["lucide-sticker"] = GetAsset("10734972234"),
	["lucide-sticky-note"] = GetAsset("10734972463"),
	["lucide-stop-circle"] = GetAsset("10734972621"),
	["lucide-stretch-horizontal"] = GetAsset("10734972862"),
	["lucide-stretch-vertical"] = GetAsset("10734973130"),
	["lucide-strikethrough"] = GetAsset("10734973290"),
	["lucide-subscript"] = GetAsset("10734973457"),
	["lucide-sun"] = GetAsset("10734974297"),
	["lucide-sun-dim"] = GetAsset("10734973645"),
	["lucide-sun-medium"] = GetAsset("10734973778"),
	["lucide-sun-moon"] = GetAsset("10734973999"),
	["lucide-sun-snow"] = GetAsset("10734974130"),
	["lucide-sunrise"] = GetAsset("10734974522"),
	["lucide-sunset"] = GetAsset("10734974689"),
	["lucide-superscript"] = GetAsset("10734974850"),
	["lucide-swiss-franc"] = GetAsset("10734975024"),
	["lucide-switch-camera"] = GetAsset("10734975214"),
	["lucide-sword"] = GetAsset("10734975486"),
	["lucide-swords"] = GetAsset("10734975692"),
	["lucide-syringe"] = GetAsset("10734975932"),
	["lucide-table"] = GetAsset("10734976230"),
	["lucide-table-2"] = GetAsset("10734976097"),
	["lucide-tablet"] = GetAsset("10734976394"),
	["lucide-tag"] = GetAsset("10734976528"),
	["lucide-tags"] = GetAsset("10734976739"),
	["lucide-target"] = GetAsset("10734977012"),
	["lucide-tent"] = GetAsset("10734981750"),
	["lucide-terminal"] = GetAsset("10734982144"),
	["lucide-terminal-square"] = GetAsset("10734981995"),
	["lucide-text-cursor"] = GetAsset("10734982395"),
	["lucide-text-cursor-input"] = GetAsset("10734982297"),
	["lucide-thermometer"] = GetAsset("10734983134"),
	["lucide-thermometer-snowflake"] = GetAsset("10734982571"),
	["lucide-thermometer-sun"] = GetAsset("10734982771"),
	["lucide-thumbs-down"] = GetAsset("10734983359"),
	["lucide-thumbs-up"] = GetAsset("10734983629"),
	["lucide-ticket"] = GetAsset("10734983868"),
	["lucide-timer"] = GetAsset("10734984606"),
	["lucide-timer-off"] = GetAsset("10734984138"),
	["lucide-timer-reset"] = GetAsset("10734984355"),
	["lucide-toggle-left"] = GetAsset("10734984834"),
	["lucide-toggle-right"] = GetAsset("10734985040"),
	["lucide-tornado"] = GetAsset("10734985247"),
	["lucide-toy-brick"] = GetAsset("10747361919"),
	["lucide-train"] = GetAsset("10747362105"),
	["lucide-trash"] = GetAsset("10747362393"),
	["lucide-trash-2"] = GetAsset("10747362241"),
	["lucide-tree-deciduous"] = GetAsset("10747362534"),
	["lucide-tree-pine"] = GetAsset("10747362748"),
	["lucide-trees"] = GetAsset("10747363016"),
	["lucide-trending-down"] = GetAsset("10747363205"),
	["lucide-trending-up"] = GetAsset("10747363465"),
	["lucide-triangle"] = GetAsset("10747363621"),
	["lucide-trophy"] = GetAsset("10747363809"),
	["lucide-truck"] = GetAsset("10747364031"),
	["lucide-tv"] = GetAsset("10747364593"),
	["lucide-tv-2"] = GetAsset("10747364302"),
	["lucide-type"] = GetAsset("10747364761"),
	["lucide-umbrella"] = GetAsset("10747364971"),
	["lucide-underline"] = GetAsset("10747365191"),
	["lucide-undo"] = GetAsset("10747365484"),
	["lucide-undo-2"] = GetAsset("10747365359"),
	["lucide-unlink"] = GetAsset("10747365771"),
	["lucide-unlink-2"] = GetAsset("10747397871"),
	["lucide-unlock"] = GetAsset("10747366027"),
	["lucide-upload"] = GetAsset("10747366434"),
	["lucide-upload-cloud"] = GetAsset("10747366266"),
	["lucide-usb"] = GetAsset("10747366606"),
	["lucide-user"] = GetAsset("10747373176"),
	["lucide-user-check"] = GetAsset("10747371901"),
	["lucide-user-cog"] = GetAsset("10747372167"),
	["lucide-user-minus"] = GetAsset("10747372346"),
	["lucide-user-plus"] = GetAsset("10747372702"),
	["lucide-user-x"] = GetAsset("10747372992"),
	["lucide-users"] = GetAsset("10747373426"),
	["lucide-utensils"] = GetAsset("10747373821"),
	["lucide-utensils-crossed"] = GetAsset("10747373629"),
	["lucide-venetian-mask"] = GetAsset("10747374003"),
	["lucide-verified"] = GetAsset("10747374131"),
	["lucide-vibrate"] = GetAsset("10747374489"),
	["lucide-vibrate-off"] = GetAsset("10747374269"),
	["lucide-video"] = GetAsset("10747374938"),
	["lucide-video-off"] = GetAsset("10747374721"),
	["lucide-view"] = GetAsset("10747375132"),
	["lucide-voicemail"] = GetAsset("10747375281"),
	["lucide-volume"] = GetAsset("10747376008"),
	["lucide-volume-1"] = GetAsset("10747375450"),
	["lucide-volume-2"] = GetAsset("10747375679"),
	["lucide-volume-x"] = GetAsset("10747375880"),
	["lucide-wallet"] = GetAsset("10747376205"),
	["lucide-wand"] = GetAsset("10747376565"),
	["lucide-wand-2"] = GetAsset("10747376349"),
	["lucide-watch"] = GetAsset("10747376722"),
	["lucide-waves"] = GetAsset("10747376931"),
	["lucide-webcam"] = GetAsset("10747381992"),
	["lucide-wifi"] = GetAsset("10747382504"),
	["lucide-wifi-off"] = GetAsset("10747382268"),
	["lucide-wind"] = GetAsset("10747382750"),
	["lucide-wrap-text"] = GetAsset("10747383065"),
	["lucide-wrench"] = GetAsset("10747383470"),
	["lucide-x"] = GetAsset("10747384394"),
	["lucide-x-circle"] = GetAsset("10747383819"),
	["lucide-x-octagon"] = GetAsset("10747384037"),
	["lucide-x-square"] = GetAsset("10747384217"),
	["lucide-zoom-in"] = GetAsset("10747384552"),
	["lucide-zoom-out"] = GetAsset("10747384679"),
};

Compkiller.FontAwesome = {
	a = GetAsset("74244459944328"),
	['accessible-icon'] = GetAsset("135242143909610"),
	accusoft = GetAsset("94057545767519"),
	['address-book'] = GetAsset("129578640498728"),
	['address-card'] = 'rbxassetid://102106715141928',
	['align-center'] = GetAsset("84408132800466"),
	['align-justify'] = GetAsset("125569339749500"),
	['align-left'] = GetAsset("110008004178539"),
	['align-right'] = GetAsset("79774893981710"),
	alipay = GetAsset("134274199490629"),
	anchor = GetAsset("94979524088900"),
	['anchor-circle-check'] = GetAsset("91871463373335"),
	['anchor-circle-exclamation'] = GetAsset("72303311082053"),
	['anchor-circle-xmark'] = GetAsset("106917001300524"),
	['anchor-lock'] = GetAsset("109198662645391"),
	android = GetAsset("93605821179752"),
	['angle-down'] = GetAsset("122395101934469"),
	['angle-left'] = GetAsset("132632410309959"),
	['angle-right'] = GetAsset("105971664068240"),
	['angles-down'] = GetAsset("96703500127872"),
	['angles-left'] = GetAsset("70595546989447"),
	['angles-right'] = GetAsset("131176182882747"),
	['angles-up'] = GetAsset("96847020381396"),
	['angle-up'] = GetAsset("136517226470297"),
	['arrow-down'] = GetAsset("100174052036797"),
	['arrow-left'] = GetAsset("133922718486450"),
	['arrow-pointer'] = GetAsset("128639550333559"),
	['arrow-right'] = 'rbxassetid://105166519175969',
	['arrow-right-arrow-left'] = GetAsset("87405428139040"),
	['arrow-right-from-bracket'] = GetAsset("111722018253482"),
	['arrow-right-to-bracket'] = GetAsset("79400903745367"),
	['arrow-rotate-left'] = GetAsset("127876635051023"),
	['arrow-rotate-right'] = GetAsset("82773599534347"),
	['arrows-left-right'] = GetAsset("85625938291926"),
	['arrows-rotate'] = GetAsset("109882153776270"),
	['arrows-up-down'] = GetAsset("88240470530518"),
	['arrows-up-down-left-right'] = GetAsset("136830364721572"),
	['arrow-trend-down'] = GetAsset("138593805214121"),
	['arrow-trend-up'] = GetAsset("121301107868410"),
	['arrow-up'] = GetAsset("116473498857626"),
	['arrow-up-from-bracket'] = GetAsset("77716847027695"),
	['arrow-up-right-from-square'] = GetAsset("101883941536459"),
	at = GetAsset("116468402170315"),
	atom = GetAsset("136905279132440"),
	['audio-description'] = 'rbxassetid://137490376195308',
	award = GetAsset("134322732056464"),
	backward = GetAsset("115437448962693"),
	['backward-fast'] = GetAsset("133478473989228"),
	['backward-step'] = GetAsset("118301206125870"),
	ban = GetAsset("89004310664420"),
	bandage = GetAsset("109104902535966"),
	bars = GetAsset("127661324755454"),
	['bars-progress'] = GetAsset("77774174241071"),
	['bars-staggered'] = GetAsset("97337529919486"),
	baseball = GetAsset("87677782809968"),
	basketball = GetAsset("71403045563776"),
	['basket-shopping'] = GetAsset("129578273645224"),
	['battery-empty'] = GetAsset("99777750808099"),
	['battery-full'] = GetAsset("93999278270214"),
	['battery-half'] = GetAsset("87762099115036"),
	['battery-quarter'] = GetAsset("96680551535938"),
	['battery-three-quarters'] = GetAsset("130840615974067"),
	bell = GetAsset("109971903438934"),
	['bell-slash'] = GetAsset("101758939103378"),
	bilibili = GetAsset("85834752961243"),
	biohazard = GetAsset("102610067899783"),
	bitcoin = GetAsset("131632152157382"),
	['bitcoin-sign'] = GetAsset("127809070259506"),
	['bluetooth-b'] = GetAsset("96522278309021"),
	bluetooth = GetAsset("113081372628241"),
	bolt = GetAsset("89858717966393"),
	bomb = GetAsset("113184250292244"),
	book = GetAsset("134006112957521"),
	['book-open'] = GetAsset("109774137257967"),
	bug = GetAsset("105314179657552"),
	['bug-slash'] = GetAsset("133973969610093"),
	broom = GetAsset("95267009545395"),
	bullhorn = GetAsset("87251830910561"),
	['bullseye'] = GetAsset("83080500555400"),
	bus = GetAsset("126579638968493"),
	calculator = GetAsset("119527046782470"),
	camera = GetAsset("133029797251962"),
	['cc-amazon-pay'] = GetAsset("108859760370504"),
	['cc-amex'] = GetAsset("138233598058785"),
	['cc-apple-pay'] = GetAsset("133747941882534"),
	['cc-diners-club'] = GetAsset("99626539664553"),
	['cc-mastercard'] = GetAsset("118541621561504"),
	['cc-visa'] = GetAsset("120055576031063"),
	['cc-paypal'] = GetAsset("87250418163030"),
	check = GetAsset("129443092324752"),
	['chevron-down'] = GetAsset("109535175596957"),
	['chevron-left'] = GetAsset("129113930144228"),
	['chevron-right'] = GetAsset("105723602996553"),
	['chevron-up'] = GetAsset("117264500851637"),
	chromecast = GetAsset("71543589030583"),
	circle = GetAsset("131274957777266"),
	['circle-check'] = GetAsset("98678528147000"),
	['circle-info'] = GetAsset("97519285421665"),
	clipboard = 'rbxassetid://111512950362265',
	['clipboard-check'] = GetAsset("118535733506457"),
	clock = GetAsset("98767608471295"),
	code = GetAsset("91882036126433"),
	['computer-mouse'] = GetAsset("114752565381440"),
	cookie = GetAsset("101854685117513"),
	copy = GetAsset("76996819137437"),
	copyright = GetAsset("131736117717053"),
	['credit-card'] = GetAsset("85213342061383"),
	['crosshairs'] = GetAsset("133441774847498"),
	database = GetAsset("109882554524389"),
	discord = GetAsset("75871011309830"),
	display = GetAsset("101851152220134"),
	download = GetAsset("122321311031549"),
	['earth-africa'] = GetAsset("107029199584204"),
	['earth-americas'] = GetAsset("105574352653407"),
	['earth-asia'] = GetAsset("138155660327900"),
	['earth-europe'] = GetAsset("134638370907021"),
	['earth-oceania'] = GetAsset("121780690380624"),
	envelope = GetAsset("136184483524922"),
	['envelope-open'] = GetAsset("132492127839357"),
	envira = GetAsset("75781570526788"),
	equals = GetAsset("134271902308970"),
	eraser = GetAsset("128970640154301"),
	ethereum = GetAsset("103421769879532"),
	exclamation = GetAsset("125718656366676"),
	eye = GetAsset("95235861336970"),
	feather = GetAsset("135995843954302"),
	fingerprint = GetAsset("125379360015007"),
	fire = GetAsset("122498238725085"),
	['floppy-disk'] = GetAsset("101374426361499"),
	folder = GetAsset("131374292202389"),
	['folder-open'] = GetAsset("78238714442180"),
	forward = GetAsset("107937467448020"),
	['forward-fast'] = GetAsset("83735840669276"),
	['forward-step'] = GetAsset("104040171143566"),
	gear = GetAsset("137945854328407"),
	gift = GetAsset("129718366414314"),
	git = GetAsset("117711060446092"),
	github = GetAsset("123783733365919"),
	globe = GetAsset("102861769355196"),
	['hand-holding-hand'] = GetAsset("120797412134954"),
	headphones = GetAsset("86076153665072"),
	headset = GetAsset("108070801288944"),
	['headphones-simple'] = GetAsset("97516570978183"),
	house = GetAsset("86540166012974"),
	['house-chimney'] = GetAsset("90066192203346"),
	image = GetAsset("107205506080751"),
	infinity = GetAsset("129024756905166"),
	info = GetAsset("113157514619684"),
	keyboard = GetAsset("97417417526948"),
	list = GetAsset("87155993544457"),
	['location-arrow'] = GetAsset("72621673664457"),
	['location-crosshairs'] = GetAsset("93887450723164"),
	lock = 'rbxassetid://80031239225283',
	palette = GetAsset("81372281623830"),
	paste = GetAsset("88846256867074"),
	paw = GetAsset("80005916079930"),
	pen = GetAsset("97404859124912"),
	pencil = GetAsset("76590960968733"),
	['pen-nib'] = GetAsset("91232219924341"),
	['pen-ruler'] = GetAsset("138407458813207"),
	phone = GetAsset("72814141651992"),
	plane = GetAsset("136248807279679"),
	plus = GetAsset("133137619535544"),
	['right-left'] = GetAsset("91273051324368"),
	['right-to-bracket'] = GetAsset("137132451900886"),
	rotate = GetAsset("95883878890200"),
	['rotate-right'] = GetAsset("93357988077552"),
	['rotate-left'] = GetAsset("96753646113822"),
	shield = GetAsset("73441026473893"),
	['shield-halved'] = GetAsset("114554606211174"),
	user = GetAsset("98376828270066"),
	unlock = GetAsset("99060354229117"),
	trash = GetAsset("82859108629080"),
	['trash-can'] = GetAsset("81463703129214"),
	skull = GetAsset("99276754296574"),
	robot = GetAsset("134497060038109"),
	tag = GetAsset("129024358125754"),
	thumbtack = GetAsset("119847869089109"),
	['thumbs-up'] = GetAsset("74340984021785"),
	['thumbs-down'] = GetAsset("86090492737223"),
	['user-gear'] = GetAsset("137604201056497"),
	video = GetAsset("112274059143251"),
	virus = GetAsset("91843339206686"),
	volleyball = GetAsset("73870192536894"),
	['magnifying-glass'] = GetAsset("74387839235930"),
};

function Compkiller:OptimizeMode(v)
	Compkiller.PerformanceMode = v;
end;

function Compkiller:IsStudio()
	return RunService:IsStudio()	
end;

function Compkiller:CustomIconHighlight()
	Compkiller.CustomHighlightMode = true;
end;

function Compkiller:_SetNilP(Ins: Instance , Parent: Instance)
	Compkiller.WindowsNil = Compkiller.WindowsNil or {};
	Compkiller.NilFolder = Compkiller.NilFolder or Instance.new('Folder');

	if not Compkiller.WindowsNil[Ins] then
		local win = Compkiller:_GetWindowFromElement(Ins);

		Compkiller.WindowsNil[Ins] = win;
	end;

	Ins.Parent = Parent or Compkiller.NilFolder;
end;

function Compkiller:SetAllText(flags : {[string] : string})
	if not flags then -- reset to default
		for i,v in next , Compkiller.Flags do
			if v.SetText then
				v:SetText(nil);
			end;
		end;

		return;
	end;

	flags = flags or {};

	for i,v in next , flags do
		if Compkiller.Flags[i] and Compkiller.Flags[i].SetText then
			Compkiller.Flags[i]:SetText(v);
		end;
	end;
end;

function Compkiller:_GetIcon(name : string , font_aws) : string
	if Compkiller.SecureMode then
		local AssetId;

		if font_aws then
			AssetId = Compkiller.FontAwesome[name] or name;
		else
			AssetId = Compkiller.Lucide['lucide-'..tostring(name)] or Compkiller.Lucide[name] or Compkiller.Lucide[tostring(name)] or Compkiller.FontAwesome[name] or name;
		end;

		if AssetId and AssetId ~= nil then
			local asset = Compkiller:CacheImage(AssetId);

			return asset;	
		end;	

		return "";
	end;

	if font_aws then
		return Compkiller.FontAwesome[name] or name;
	end;

	return Compkiller.Lucide['lucide-'..tostring(name)] or Compkiller.Lucide[name] or Compkiller.Lucide[tostring(name)] or Compkiller.FontAwesome[name] or name;
end;

function Compkiller:_RandomString() : string
	return "CK="..string.char(math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102));	
end;

function Compkiller:_IsMouseOverFrame(Frame : Frame) : boolean
	if not Frame then
		return;
	end;

	local AbsPos: Vector2, AbsSize: Vector2 = Frame.AbsolutePosition, Frame.AbsoluteSize;

	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
		return true;
	end;
end;

function Compkiller:_Rounding(num: number, numDecimalPlaces: number) : number
	local mult: number = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end;

function Compkiller:_Animation(Self: Instance , Info: TweenInfo , Property :{[K] : V})
	local Tween = TweenService:Create(Self , Info or TweenInfo.new(0.25) , Property);

	Tween:Play();

	return Tween;
end;

function Compkiller:_Input(Frame : Frame , Callback : () -> ()) : TextButton
	local Button = Instance.new('TextButton',Frame);

	Button.ZIndex = Frame.ZIndex + 10;
	Button.Size = UDim2.fromScale(1,1);
	Button.BackgroundTransparency = 1;
	Button.TextTransparency = 1;

	if Callback then
		Button.MouseButton1Click:Connect(Callback);
	end;

	return Button;
end;

function Compkiller:GetCalculatePosition(planePos: number, planeNormal: number, rayOrigin: number, rayDirection: number) : number
	local n = planeNormal;
	local d = rayDirection;
	local v = rayOrigin - planePos;

	local num = (n.x * v.x) + (n.y * v.y) + (n.z * v.z);
	local den = (n.x * d.x) + (n.y * d.y) + (n.z * d.z);
	local a = -num / den;

	return rayOrigin + (a * rayDirection);
end;

function Compkiller:_Blur(element : Frame , WindowRemote) : RBXScriptSignal
	if Compkiller.SecureMode and not Compkiller.SecurityConfig.BlurEnabled then
		return game.Changed:Connect(function() end);
	end;

	local Part = Instance.new('Part',Compkiller.ArcylicParent);
	local DepthOfField = Instance.new('DepthOfFieldEffect',cloneref(game:GetService('Lighting')));
	local BlockMesh = Instance.new("BlockMesh");
	local userSettings = UserSettings():GetService("UserGameSettings");

	BlockMesh.Parent = Part;

	Part.Material = Enum.Material.Glass;
	Part.Transparency = 1;
	Part.Reflectance = 1;
	Part.CastShadow = false;
	Part.Anchored = true;
	Part.CanCollide = false;
	Part.CanQuery = false;
	Part.CollisionGroup = Compkiller:_RandomString();
	Part.Size = Vector3.new(1, 1, 1) * 0.01;
	Part.Color = Color3.fromRGB(0,0,0);

	DepthOfField.Enabled = true;
	DepthOfField.FarIntensity = 0;
	DepthOfField.FocusDistance = 0;
	DepthOfField.InFocusRadius = 1000;
	DepthOfField.NearIntensity = 1;
	DepthOfField.Name = Compkiller:_RandomString();

	Part.Name = Compkiller:_RandomString();

	local disconnect;

	local UpdateFunction = function()
		if Compkiller.SecureMode then
			if Part then
				Part:Destroy();
				Part = nil;
			end;

			if DepthOfField then
				DepthOfField:Destroy();
				DepthOfField = nil;
			end;

			if BlockMesh then
				BlockMesh:Destroy();
				BlockMesh = nil;
			end;

			if disconnect then
				disconnect();
				disconnect = nil;
			end;

			return;
		end;

		local IsWindowActive = WindowRemote:GetValue();

		if IsWindowActive then

			Compkiller:_Animation(DepthOfField,TweenInfo.new(0.1),{
				NearIntensity = 1
			})

			Compkiller:_Animation(Part,TweenInfo.new(0.1),{
				Transparency = 0.97,
				Size = Vector3.new(1, 1, 1) * 0.01;
			})
		else
			Compkiller:_Animation(DepthOfField,TweenInfo.new(0.1),{
				NearIntensity = 0
			})

			Compkiller:_Animation(Part,TweenInfo.new(0.1),{
				Size = Vector3.zero,
				Transparency = 1.5,
			})

			return false;
		end;

		if IsWindowActive then
			local corner0 = element.AbsolutePosition;
			local corner1 = corner0 + element.AbsoluteSize;

			local ray0 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner0.X, corner0.Y, 1);
			local ray1 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner1.X, corner1.Y, 1);

			local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ);

			local planeNormal = CurrentCamera.CFrame.LookVector;

			local pos0 = Compkiller:GetCalculatePosition(planeOrigin, planeNormal, ray0.Origin, ray0.Direction);
			local pos1 = Compkiller:GetCalculatePosition(planeOrigin, planeNormal, ray1.Origin, ray1.Direction);

			pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0);
			pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1);

			local size   = pos1 - pos0;
			local center = (pos0 + pos1) / 2;

			BlockMesh.Offset = center
			BlockMesh.Scale  = size / 0.0101;
			Part.CFrame = CurrentCamera.CFrame;
		end;
	end;

	local rbxsignal = CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(UpdateFunction)
	local loopThread = UserInputService.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			pcall(UpdateFunction);
		end;
	end);

	local THREAD = task.spawn(function()
		while true do task.wait(0.1)
			pcall(UpdateFunction);
		end;
	end);

	disconnect = function()
		rbxsignal:Disconnect();
		loopThread:Disconnect();
		task.cancel(THREAD);
		Part:Destroy();
		DepthOfField:Destroy();
	end;

	element.Destroying:Connect(disconnect);

	return rbxsignal;
end;

function Compkiller:_AddDragBlacklist(Frame: Frame)
	local IsAdded = false;
	local BASE_TIME = 0.01;

	local SET_BLACKLIST = function(value)
		local index = table.find(Compkiller.DragBlacklist , Frame);

		if value and not Compkiller.IS_DRAG_MOVE then
			if not index then
				table.insert(Compkiller.DragBlacklist,Frame);
			end;
		else
			if index then
				table.remove(Compkiller.DragBlacklist,index);
			end;
		end;
	end;

	Frame.InputBegan:Connect(function(input)
		if Compkiller:_IsMouseOverFrame(Frame) then
			SET_BLACKLIST(true)
		end;
	end);

	Frame.InputEnded:Connect(function(input)
		SET_BLACKLIST(false);
	end);

	UserInputService.InputChanged:Connect(function()
		if not Compkiller:_IsMouseOverFrame(Frame) then
			SET_BLACKLIST(false);
		end
	end);
end;

function Compkiller:_GetWindowFromElement(Element)
	if Compkiller.WindowsNil[Element] then
		return Compkiller.WindowsNil[Element];
	end;

	for i,v : ScreenGui in next , Compkiller.Windows do
		if v and Element:IsDescendantOf(v) then
			return v;
		end;
	end;

	for Frame,Window in next , Compkiller.WindowsNil do
		if Element:IsDescendantOf(Frame) or Frame == Element then
			return Window;
		end;
	end;
end;

function Compkiller.__SIGNAL(default)
	local Bindable = Instance.new('BindableEvent');

	Bindable.Name = string.sub(tostring({}),7);

	Bindable:SetAttribute('Value',default);

	local Binds = {
		__signals = {}	
	};

	function Binds:Connect(event)
		event(Bindable:GetAttribute("Value"));

		local signal = Bindable.Event:Connect(event);

		table.insert(Binds.__signals,signal);

		return signal;
	end;

	function Binds:Fire(value)
		local IsSame = Bindable:GetAttribute("Value") == value;

		Bindable:SetAttribute('Value',value);

		if not IsSame then
			Bindable:Fire(value);
		end;
	end;

	function Binds:GetValue()
		return Bindable:GetAttribute("Value");
	end;

	return Binds;
end;

function Compkiller:_Hover(Frame: Frame , OnHover: () -> any?, Release: () -> any?)
	Frame.MouseEnter:Connect(OnHover);

	Frame.MouseLeave:Connect(Release);
end;

function Compkiller.__CONFIG(config , default)
	config = config or {};

	for i,v in next , default do
		if config[i] == nil then
			config[i] = v;
		end;
	end;

	return config;
end;

function Compkiller:Drag(InputFrame: Frame, MoveFrame: Frame, Speed : number)
	local dragToggle: boolean = false;
	local dragStart: Vector3 = nil;
	local startPos: UDim2 = nil;
	local Tween = TweenInfo.new(Speed);

	local updateInput = function(input)
		local delta = input.Position - dragStart;
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y);

		Compkiller:_Animation(MoveFrame,Tween,{
			Position = position
		});
	end;

	InputFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and #Compkiller.DragBlacklist <= 0 then 
			dragToggle = true
			dragStart = input.Position
			startPos = MoveFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false;
					Compkiller.IS_DRAG_MOVE = false;
				end
			end)
		end

		if not Compkiller.IsDrage and dragToggle then
			Compkiller.LastDrag = tick();
		end;

		Compkiller.IaDrag = dragToggle;
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch and #Compkiller.DragBlacklist <= 0 then
			if dragToggle then
				Compkiller.IS_DRAG_MOVE = true;
				updateInput(input)
			else
				Compkiller.IS_DRAG_MOVE = false;
			end
		else
			if #Compkiller.DragBlacklist > 0 then
				dragToggle = false
				Compkiller.IS_DRAG_MOVE = false;
			end
		end

		Compkiller.IaDrag = dragToggle;
	end);
end;

function Compkiller:_IsMobile()
	return UserInputService.TouchEnabled;
end;

function Compkiller:_AddLinkValue(Name , Default , GlobalBlock , LinkValues , rep , Signal)
	if Name == "Toggle" then
		local Toggle = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ToggleValue = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")

		Toggle.Name = Compkiller:_RandomString()
		Toggle.Parent = LinkValues
		Toggle.BackgroundColor3 = Compkiller.Colors.DropColor
		Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Toggle.BorderSizePixel = 0
		Toggle.Size = UDim2.new(0, 30, 0, 16)
		Toggle.ZIndex = GlobalBlock.ZIndex + 1
		Toggle.LayoutOrder = -#LinkValues:GetChildren();

		table.insert(Compkiller.Elements.DropColor , {
			Element = Toggle,
			Property = "BackgroundColor3"
		})

		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = Toggle

		UIStroke.Color = Compkiller.Colors.HighStrokeColor
		UIStroke.Parent = Toggle

		table.insert(Compkiller.Elements.HighStrokeColor,{
			Element = UIStroke,
			Property = "Color"
		})

		ToggleValue.Name = Compkiller:_RandomString()
		ToggleValue.Parent = Toggle
		ToggleValue.AnchorPoint = Vector2.new(0.5, 0.5)
		ToggleValue.BackgroundColor3 = Compkiller.Colors.SwitchColor
		ToggleValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleValue.BorderSizePixel = 0
		ToggleValue.Position = UDim2.new(0.25, 0, 0.5, 0)
		ToggleValue.Size = UDim2.new(0.550000012, 0, 0.550000012, 0)
		ToggleValue.SizeConstraint = Enum.SizeConstraint.RelativeYY
		ToggleValue.ZIndex = GlobalBlock.ZIndex + 2

		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = ToggleValue;

		local ToggleElement = function(bool,noChange)
			if not noChange then
				Default = bool;
			end;

			if bool then
				Toggle:SetAttribute('Enabled',true);

				Compkiller:_Animation(ToggleValue,rep.Tween,{
					Position = UDim2.new(0.75, 0, 0.5, 0)
				})

				Compkiller:_Animation(Toggle,rep.Tween,{
					BackgroundColor3 = Compkiller.Colors.Toggle
				})
			else
				Toggle:SetAttribute('Enabled',false);

				Compkiller:_Animation(ToggleValue,rep.Tween,{
					Position = UDim2.new(0.25, 0, 0.5, 0)
				})

				Compkiller:_Animation(Toggle,rep.Tween,{
					BackgroundColor3 = Compkiller.Colors.DropColor
				})
			end;
		end;

		local Input = Compkiller:_Input(Toggle);

		Compkiller:_Hover(Input , function()
			if not Default then
				Compkiller:_Animation(ToggleValue,rep.Tween,{
					Size = UDim2.new(0.6, 0, 0.6, 0)
				})
			end;
		end , function()
			Compkiller:_Animation(ToggleValue,rep.Tween,{
				Size = UDim2.new(0.550000012, 0, 0.550000012, 0)
			})
		end);

		local ToggleUI = function(bool)
			if bool then
				ToggleElement(Default,true);

				Compkiller:_Animation(ToggleValue,rep.Tween,{
					BackgroundTransparency = 0
				})

				Compkiller:_Animation(Toggle,rep.Tween,{
					BackgroundTransparency = 0
				})

				Compkiller:_Animation(UIStroke,rep.Tween,{
					Transparency = 0
				})
			else
				ToggleElement(false,true);

				Compkiller:_Animation(ToggleValue,rep.Tween,{
					BackgroundTransparency = 1
				})

				Compkiller:_Animation(Toggle,rep.Tween,{
					BackgroundTransparency = 1
				})

				Compkiller:_Animation(UIStroke,rep.Tween,{
					Transparency = 1
				})
			end;
		end;

		ToggleElement(Default);

		Signal:Connect(ToggleUI)

		return {
			Root = Toggle,
			ChangeValue = ToggleElement,
			Input = Input,
			ToggleUI = ToggleUI,
		};
	elseif Name == "ColorPicker" then
		local ColorPicker = Instance.new("Frame")
		local ColorFrame = Instance.new("Frame")
		local UIScale = Instance.new("UIScale")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")

		ColorPicker.Name = Compkiller:_RandomString()
		ColorPicker.Parent = LinkValues
		ColorPicker.BackgroundTransparency = 1.000
		ColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorPicker.BorderSizePixel = 0
		ColorPicker.Size = UDim2.new(0, 16, 0, 16)
		ColorPicker.ZIndex = GlobalBlock.ZIndex + 1
		ColorPicker.LayoutOrder = -#LinkValues:GetChildren();

		ColorFrame.Name = Compkiller:_RandomString()
		ColorFrame.Parent = ColorPicker
		ColorFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		ColorFrame.BackgroundColor3 = Color3.fromRGB(15, 255, 207)
		ColorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorFrame.BorderSizePixel = 0
		ColorFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		ColorFrame.Size = UDim2.new(1, -1, 1, -1)
		ColorFrame.ZIndex = GlobalBlock.ZIndex + 1

		UIScale.Parent = ColorFrame

		UIStroke.Color = Compkiller.Colors.HighStrokeColor
		UIStroke.Parent = ColorFrame

		table.insert(Compkiller.Elements.HighStrokeColor,{
			Element = UIStroke,
			Property = "Color"
		})

		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = ColorFrame

		Signal:Connect(function(bool)
			if bool then
				Compkiller:_Animation(ColorFrame,TweenInfo.new(0.15),{
					BackgroundTransparency = 0,
				})

				Compkiller:_Animation(UIStroke,TweenInfo.new(0.15),{
					Transparency = 0,
				})
			else
				Compkiller:_Animation(ColorFrame,TweenInfo.new(0.15),{
					BackgroundTransparency = 1,
				})

				Compkiller:_Animation(UIStroke,TweenInfo.new(0.15),{
					Transparency = 1,
				})
			end;
		end)

		Compkiller:_Hover(ColorPicker, function()
			if Signal:GetValue() then
				Compkiller:_Animation(UIScale,TweenInfo.new(0.35),{
					Scale = 1.2
				})
			end;
		end , function()
			if Signal:GetValue() then
				Compkiller:_Animation(UIScale,TweenInfo.new(0.35),{
					Scale = 1
				})
			end;
		end)

		return ColorPicker , ColorFrame;
	elseif Name == "Keybind" then
		local Keys = {
			One = '1',
			Two = '2',
			Three = '3',
			Four = '4',
			Five = '5',
			Six = '6',
			Seven = '7',
			Eight = '8',
			Nine = '9',
			Zero = '0',
			['Minus'] = "-",
			['Plus'] = "+",
			BackSlash = "\\",
			Slash = "/",
			Period = '.',
			Semicolon = ';',
			Colon = ":",
			LeftControl = "LCtrl",
			RightControl = "RCtrl",
			LeftShift = "LShift",
			RightShift = "RShift",
			Return = "Enter",
			LeftBracket = "[",
			RightBracket = "]",
			Quote = "'",
			Comma = ",",
			Equals = "=",
			LeftSuper = "Super",
			RightSuper = "Super",
			LeftAlt = "LAlt",
			RightAlt = "RAlt",
			Escape = "Esc",
		};

		local GetItem = function(item)
			if item then
				if typeof(item) == 'EnumItem' then
					return Keys[item.Name] or item.Name;
				else
					return Keys[tostring(item)] or tostring(item);
				end;
			else
				return 'None';
			end;
		end;

		local Keybind = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local TextLabel = Instance.new("TextLabel")

		Keybind.Name = Compkiller:_RandomString()
		Keybind.Parent = LinkValues
		Keybind.BackgroundColor3 = Compkiller.Colors.DropColor
		Keybind.BackgroundTransparency = 0.8
		Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Keybind.BorderSizePixel = 0
		Keybind.Size = UDim2.new(0, 45, 0, 16)
		Keybind.ZIndex = GlobalBlock.ZIndex + 2
		Keybind.ClipsDescendants = true
		Keybind.LayoutOrder = -#LinkValues:GetChildren();


		table.insert(Compkiller.Elements.DropColor , {
			Element = Keybind,
			Property = "BackgroundColor3"
		})

		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = Keybind

		UIStroke.Color = Compkiller.Colors.HighStrokeColor
		UIStroke.Parent = Keybind

		table.insert(Compkiller.Elements.HighStrokeColor,{
			Element = UIStroke,
			Property = "Color"
		})

		TextLabel.Parent = Keybind
		TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextLabel.Size = UDim2.new(1, -5, 1, -5)
		TextLabel.ZIndex = GlobalBlock.ZIndex + 3
		TextLabel.Font = Enum.Font.Gotham
		TextLabel.Text = GetItem(Default or "None");
		TextLabel.TextColor3 = Compkiller.Colors.SwitchColor
		TextLabel.TextSize = 12.000
		TextLabel.TextTransparency = 0.200

		table.insert(Compkiller.Elements.SwitchColor,{
			Element = TextLabel,
			Property = "TextColor3"
		});

		local Update = function()
			local size = TextService:GetTextSize(TextLabel.Text,TextLabel.TextSize,TextLabel.Font,Vector2.new(math.huge,math.huge));

			Compkiller:_Animation(Keybind,TweenInfo.new(0.1),{
				Size = UDim2.new(0, size.X + 5, 0, 16)
			});
		end;

		Update();

		local ToggleUI = function(bool)
			if bool then
				Compkiller:_Animation(Keybind,rep.Tween,{
					BackgroundTransparency = 0.8
				})

				Compkiller:_Animation(UIStroke,rep.Tween,{
					Transparency = 0
				})

				Compkiller:_Animation(TextLabel,rep.Tween,{
					TextTransparency = 0.200
				})
			else
				Compkiller:_Animation(Keybind,rep.Tween,{
					BackgroundTransparency = 1
				})

				Compkiller:_Animation(UIStroke,rep.Tween,{
					Transparency = 1
				})

				Compkiller:_Animation(TextLabel,rep.Tween,{
					TextTransparency = 1
				})
			end;
		end;

		Signal:Connect(ToggleUI);

		return {
			SetValue = function(text)
				TextLabel.Text = GetItem(text or "None");

				Update();
			end,
			Root = Keybind,
		};
	elseif Name == "Helper" then
		local InfoButton = Instance.new("ImageButton")
		local UICorner = Instance.new("UICorner")
		local BlockText = Instance.new("TextLabel")
		local UIStroke = Instance.new("UIStroke")
		local UICorner_2 = Instance.new("UICorner")

		InfoButton.Name = Compkiller:_RandomString()
		InfoButton.Parent = LinkValues
		InfoButton.BackgroundTransparency = 1.000
		InfoButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		InfoButton.BorderSizePixel = 0
		InfoButton.LayoutOrder = -#LinkValues:GetChildren();
		InfoButton.Size = UDim2.new(0, 15, 0, 15)
		InfoButton.ZIndex = GlobalBlock.ZIndex + 25
		InfoButton.Image = Compkiller:CacheImage(GetAsset("10723415903"))
		InfoButton.ImageTransparency = 0.500

		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = InfoButton

		BlockText.Name = Compkiller:_RandomString()
		BlockText.Parent = InfoButton
		BlockText.AnchorPoint = Vector2.new(0, 0)
		BlockText.BackgroundColor3 = Compkiller.Colors.BlockColor

		table.insert(Compkiller.Elements.BlockColor , {
			Element = BlockText,
			Property = "BackgroundColor3"
		});

		BlockText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BlockText.BorderSizePixel = 0
		BlockText.Position = UDim2.new(0, 5, 0, 0)
		BlockText.Size = UDim2.new(0, 250, 0, 15)
		BlockText.ZIndex = GlobalBlock.ZIndex + 26
		BlockText.Font = Enum.Font.GothamMedium
		BlockText.Text = " "
		BlockText.TextColor3 = Compkiller.Colors.SwitchColor
		BlockText.TextSize = 13.000
		BlockText.TextTransparency = 0.300
		BlockText.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(Compkiller.Elements.SwitchColor,{
			Element = BlockText,
			Property = "TextColor3"
		});

		UIStroke.Color = Compkiller.Colors.StrokeColor
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Parent = BlockText

		table.insert(Compkiller.Elements.StrokeColor,{
			Element = UIStroke,
			Property = "Color"
		});

		UICorner_2.CornerRadius = UDim.new(0, 3)
		UICorner_2.Parent = BlockText

		Signal:Connect(function(bool)
			if bool then
				Compkiller:_Animation(InfoButton,TweenInfo.new(0.15),{
					ImageTransparency = 0.500
				})
			else
				Compkiller:_Animation(InfoButton,TweenInfo.new(0.15),{
					ImageTransparency = 1
				})
			end;
		end)

		Compkiller:_Hover(InfoButton, function()
			if Signal:GetValue() then
				Compkiller:_Animation(InfoButton,TweenInfo.new(0.15),{
					ImageTransparency = 0.1
				})
			end;
		end , function()
			if Signal:GetValue() then
				Compkiller:_Animation(InfoButton,TweenInfo.new(0.15),{
					ImageTransparency = 0.500
				})
			end;
		end)

		return {
			Text = BlockText,
			UIStroke = UIStroke,
			InfoButton = InfoButton,
		};
	elseif Name == "Option" then
		local OptionButton = Instance.new("ImageButton")
		local UICorner = Instance.new("UICorner")

		OptionButton.Name = Compkiller:_RandomString()
		OptionButton.Parent = LinkValues
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Size = UDim2.new(0, 15, 0, 15)
		OptionButton.ZIndex = GlobalBlock.ZIndex + 2
		OptionButton.Image = Compkiller:CacheImage(GetAsset("14007344336"))
		OptionButton.ImageTransparency = 0.500
		OptionButton.LayoutOrder = -#LinkValues:GetChildren();

		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = OptionButton

		Signal:Connect(function(bool)
			if bool then
				Compkiller:_Animation(OptionButton,TweenInfo.new(0.15),{
					ImageTransparency = 0.500
				})
			else
				Compkiller:_Animation(OptionButton,TweenInfo.new(0.15),{
					ImageTransparency = 1
				})
			end;
		end)

		Compkiller:_Hover(OptionButton, function()
			if Signal:GetValue() then
				Compkiller:_Animation(OptionButton,TweenInfo.new(0.15),{
					ImageTransparency = 0.1
				})
			end;
		end , function()
			if Signal:GetValue() then
				Compkiller:_Animation(OptionButton,TweenInfo.new(0.15),{
					ImageTransparency = 0.500
				})
			end;
		end)

		return OptionButton;
	end;
end;

function Compkiller:_CreateBlock(Signal)
	local GlobalBlock = Instance.new("Frame")
	local BlockText = Instance.new("TextLabel")
	local LinkValues = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local BlockLine = Instance.new("Frame")

	if Compkiller:_IsMobile() then
		Compkiller:_AddDragBlacklist(GlobalBlock);
	end;

	GlobalBlock.Name = Compkiller:_RandomString()
	GlobalBlock.BackgroundTransparency = 1.000
	GlobalBlock.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GlobalBlock.BorderSizePixel = 0
	GlobalBlock.Size = UDim2.new(1, -1, 0, 30)
	GlobalBlock.ZIndex = 10

	BlockText.Name = Compkiller:_RandomString()
	BlockText.Parent = GlobalBlock
	BlockText.AnchorPoint = Vector2.new(0, 0.5)
	BlockText.BackgroundTransparency = 1.000
	BlockText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BlockText.BorderSizePixel = 0
	BlockText.Position = UDim2.new(0, 12, 0.5, 0)
	BlockText.Size = UDim2.new(1, -20, 0, 25)
	BlockText.ZIndex = 10
	BlockText.Font = Enum.Font.GothamMedium
	BlockText.Text = "Block"
	BlockText.TextColor3 = Compkiller.Colors.SwitchColor
	BlockText.TextSize = 14.000
	BlockText.TextTransparency = 0.300
	BlockText.TextXAlignment = Enum.TextXAlignment.Left

	table.insert(Compkiller.Elements.SwitchColor , {
		Element = BlockText,
		Property = 'TextColor3'
	});

	LinkValues.Name = Compkiller:_RandomString()
	LinkValues.Parent = GlobalBlock
	LinkValues.AnchorPoint = Vector2.new(1, 0.540000021)
	LinkValues.BackgroundTransparency = 1.000
	LinkValues.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LinkValues.BorderSizePixel = 0
	LinkValues.Position = UDim2.new(1, -12, 0.5, 0)
	LinkValues.Size = UDim2.new(1, 0, 0, 18)
	LinkValues.ZIndex = 11

	UIListLayout.Parent = LinkValues
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 8)

	BlockLine.Name = Compkiller:_RandomString()
	BlockLine.Parent = GlobalBlock
	BlockLine.AnchorPoint = Vector2.new(0.5, 1)
	BlockLine.BackgroundColor3 = Compkiller.Colors.LineColor
	BlockLine.BackgroundTransparency = 0.500
	BlockLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BlockLine.BorderSizePixel = 0
	BlockLine.Position = UDim2.new(0.5, 0, 1, 0)
	BlockLine.Size = UDim2.new(1, -26, 0, 1)
	BlockLine.ZIndex = 12

	table.insert(Compkiller.Elements.LineColor,{
		Element = BlockLine,
		Property = "BackgroundColor3"
	});

	local rep = {
		TextTransparency = 0.300,
		Root = GlobalBlock,
		Tween = TweenInfo.new(0.25),
	};

	function rep:SetText(Text)
		BlockText.Text = Text;
	end;

	function rep:GetText()
		return BlockText.Text;
	end;

	function rep:SetTextColor(Color)
		local oldIndex = table.find(Compkiller.Elements.SwitchColor , BlockText);

		table.remove(Compkiller.Elements.SwitchColor , oldIndex);

		BlockText.TextColor3 = Color;

		table.insert(Compkiller.Elements.Risky , {
			Element = BlockText,
			Property = 'TextColor3'
		});

	end;

	function rep:SetLine(visible)
		BlockLine.Visible = visible;

		if not visible then
			BlockLine.Parent = nil;
		else
			BlockLine.Parent = rep.Root;
		end;
	end;

	function rep:SetTransparency(num)
		rep.TextTransparency = num;

		Compkiller:_Animation(BlockText,TweenInfo.new(0.3),{
			TextTransparency = rep.TextTransparency
		});
	end;

	function rep:SetParent(parent: Frame)
		GlobalBlock.Parent = parent;

		local ZINDEX = parent.ZIndex;

		GlobalBlock.ZIndex = ZINDEX + 1;
		BlockText.ZIndex = ZINDEX + 2;
		LinkValues.ZIndex = ZINDEX + 2;
		BlockLine.ZIndex = ZINDEX + 2;
	end;

	function rep:SetVisible(bool)
		if bool then
			Compkiller:_Animation(BlockText,rep.Tween,{
				TextTransparency = rep.TextTransparency
			});

			Compkiller:_Animation(BlockLine,rep.Tween,{
				BackgroundTransparency = 0.500
			});
		else
			Compkiller:_Animation(BlockText,rep.Tween,{
				TextTransparency = 1
			});

			Compkiller:_Animation(BlockLine,rep.Tween,{
				BackgroundTransparency = 1
			});
		end;
	end;

	function rep:AddLink(Name , Default)
		return Compkiller:_AddLinkValue(Name , Default , GlobalBlock , LinkValues , rep , Signal);
	end;

	return rep;
end;

Compkiller.Hash = function(str: string)
	if typeof(str) ~= "string" then
		return "ck-unknow";
	end;

	local hex = #str;

	string.gsub(str,'.',function(byte)
		hex += byte:byte() + #str;
	end);

	local dh = string.match(str,'%d+');

	return "ck-"..tostring(math.round(hex + 15))..tostring(dh);
end;

function Compkiller:CacheImage(id: string) : string
	if not Compkiller.SecureMode or not id or not id:byte() then
		return id or "";
	end;

	assert(Compkiller.SecureMode , "please use Compkiller:Security(< string >) before cache image")
	assert(Compkiller.CacheDirectory , "please use Compkiller:Security(< string >) before cache image")

	local ids = string.match(id , "%d+");

	if ids == nil then
		return id;
	end;

	local Hash = Compkiller.Hash(id);

	local cache_path = string.format("%s/cache-%s.png" ,Compkiller.CacheDirectory , Hash);

	if isfile(cache_path) then
		return (getcustomasset or getsynasset or function() return ''; end)(cache_path);
	end;

	local imgSize = Compkiller.SecurityConfig.ImageScale;

	local imagesize = (imgSize and string.format("%sx%s", tostring(math.round(imgSize)), tostring(math.round(imgSize)))) or "150x150"

	if imagesize == nil then
		return ''
	end;

	local endpoint = string.format(
		"https://thumbnails.roblox.com/v1/assets?assetIds=%s&size=%s&format=Png&isCircular=false",
		ids,
		imagesize
	);

	local json = game:HttpGet(endpoint);

	local JSON_Decode = select(2, pcall(function()
		return HttpService:JSONDecode(json);
	end));

	if typeof(JSON_Decode) == "table" and JSON_Decode and JSON_Decode.data and JSON_Decode.data[1] and JSON_Decode.data[1].imageUrl and JSON_Decode.data[1].state == "Completed" then task.wait()
		local en = JSON_Decode.data[1].imageUrl;

		writefile(cache_path , game:HttpGet(en));

		task.wait();

		return (getcustomasset or getsynasset or function() return ''; end)(cache_path);
	end;

	return "";
end;

function Compkiller:PreloadIcons()
	local RequiredAssets = {
		"http://www.roblox.com/asset/?id=112554223509763",
		GetAsset("4805639000"),
		GetAsset("6198493000"),
		GetAsset("10709790948"),
		GetAsset("18518299306"),
		GetAsset("10747362393"),
		GetAsset("18720640102"),
		GetAsset("10723344270"),
		GetAsset("109535175596957"),
		GetAsset("10747384394"),
		GetAsset("10734941499"),
		Compkiller.Logo,
	};

	if Compkiller.SecureMode then
		for i,v in next , RequiredAssets do task.wait()
			pcall(function()
				Compkiller:CacheImage(v);
			end);
		end;
	else
		local ContentProvider: ContentProvider = cloneref(game:GetService('ContentProvider'));

		for i,v in next , RequiredAssets do
			ContentProvider:Preload(v);
		end;
	end;
end;

function Compkiller:Security(directory: string,Config: SecurityConfig) -- Security Mode
	directory = directory or "Compkiller-Cache";

	if not isfolder(directory) then
		makefolder(directory);
	end;

	Compkiller.SecureMode = true;

	Compkiller.SecurityConfig = Config or {};

	Compkiller.CacheDirectory = directory;
end;

function Compkiller:_AddColorPickerPanel(Button: ImageButton , Callback: (Color: Color3) -> any?)
	local Window = Compkiller:_GetWindowFromElement(Button);
	local BaseZ_Index = math.random(1,15) * 100;

	local ColorPickerWindow = Instance.new("Frame")
	local UIStroke = Instance.new("UIStroke")
	local UICorner = Instance.new("UICorner")
	local ColorPickBox = Instance.new("ImageLabel")
	local MouseMovement = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local ColorRedGreenBlue = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_3 = Instance.new("UICorner")
	local ColorRGBSlide = Instance.new("Frame")
	local Left = Instance.new("Frame")
	local UIStroke_3 = Instance.new("UIStroke")
	local Right = Instance.new("Frame")
	local UIStroke_4 = Instance.new("UIStroke")
	local ColorOpc = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local ColorOptSlide = Instance.new("Frame")
	local Left_2 = Instance.new("Frame")
	local UIStroke_5 = Instance.new("UIStroke")
	local Right_2 = Instance.new("Frame")
	local UIStroke_6 = Instance.new("UIStroke")
	local UIGradient_2 = Instance.new("UIGradient")
	local UIStroke_7 = Instance.new("UIStroke")
	local TransparentImage = Instance.new("ImageLabel")
	local UICorner_5 = Instance.new("UICorner")
	local HexFrame = Instance.new("Frame")
	local UICorner_6 = Instance.new("UICorner")
	local UIStroke_8 = Instance.new("UIStroke")
	local TextLabel = Instance.new("TextLabel")

	ColorPickerWindow.Name = Compkiller:_RandomString()
	ColorPickerWindow.Parent = Window
	ColorPickerWindow.BackgroundColor3 = Compkiller.Colors.BlockBackground
	ColorPickerWindow.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPickerWindow.BorderSizePixel = 0
	ColorPickerWindow.Position = UDim2.new(123, 0, 123, 0)
	ColorPickerWindow.Size = UDim2.new(0, 175, 0, 200)
	ColorPickerWindow.ZIndex = BaseZ_Index
	ColorPickerWindow.AnchorPoint = Vector2.new(0.5,0)
	ColorPickerWindow.Active = true;

	table.insert(Compkiller.Elements.BlockBackground,{
		Element = ColorPickerWindow,
		Property = "BackgroundColor3"
	});

	Compkiller:_AddDragBlacklist(ColorPickerWindow)

	UIStroke.Color = Compkiller.Colors.HighStrokeColor
	UIStroke.Parent = ColorPickerWindow

	table.insert(Compkiller.Elements.HighStrokeColor , {
		Element = UIStroke,
		Property = "Color"
	})

	UICorner.CornerRadius = UDim.new(0, 6)
	UICorner.Parent = ColorPickerWindow

	ColorPickBox.Name = Compkiller:_RandomString()
	ColorPickBox.Parent = ColorPickerWindow
	ColorPickBox.BackgroundColor3 = Color3.fromRGB(39, 255, 35)
	ColorPickBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPickBox.BorderSizePixel = 0
	ColorPickBox.Position = UDim2.new(0, 7, 0, 7)
	ColorPickBox.Size = UDim2.new(0, 145, 0, 145)
	ColorPickBox.ZIndex = BaseZ_Index + 1
	ColorPickBox.Image = Compkiller:CacheImage("http://www.roblox.com/asset/?id=112554223509763");

	MouseMovement.Name = Compkiller:_RandomString()
	MouseMovement.Parent = ColorPickBox
	MouseMovement.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MouseMovement.BackgroundTransparency = 1.000
	MouseMovement.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MouseMovement.BorderSizePixel = 0
	MouseMovement.Position = UDim2.new(0.822222233, 0, 0.0592592582, 0)
	MouseMovement.Size = UDim2.new(0, 12, 0, 12)
	MouseMovement.ZIndex = BaseZ_Index + 5
	MouseMovement.AnchorPoint = Vector2.new(0.5,0.5)
	MouseMovement.Image = Compkiller:CacheImage(GetAsset("4805639000"))

	UICorner_2.CornerRadius = UDim.new(0, 2)
	UICorner_2.Parent = ColorPickBox

	UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_2.Parent = ColorPickBox

	ColorRedGreenBlue.Name = Compkiller:_RandomString()
	ColorRedGreenBlue.Parent = ColorPickerWindow
	ColorRedGreenBlue.AnchorPoint = Vector2.new(1, 0)
	ColorRedGreenBlue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorRedGreenBlue.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorRedGreenBlue.BorderSizePixel = 0
	ColorRedGreenBlue.ClipsDescendants = true
	ColorRedGreenBlue.Position = UDim2.new(1, -7, 0, 7)
	ColorRedGreenBlue.Size = UDim2.new(0, 10, 0, 145)
	ColorRedGreenBlue.ZIndex = BaseZ_Index + 6

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(203, 255, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(50, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 101, 255)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(50, 0, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))}
	UIGradient.Rotation = 90
	UIGradient.Parent = ColorRedGreenBlue

	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = ColorRedGreenBlue

	ColorRGBSlide.Name = Compkiller:_RandomString()
	ColorRGBSlide.Parent = ColorRedGreenBlue
	ColorRGBSlide.AnchorPoint = Vector2.new(0.5, 0)
	ColorRGBSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorRGBSlide.BackgroundTransparency = 1.000
	ColorRGBSlide.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorRGBSlide.BorderSizePixel = 0
	ColorRGBSlide.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorRGBSlide.Size = UDim2.new(1, 0, 0, 2)
	ColorRGBSlide.ZIndex = BaseZ_Index + 7

	Left.Name = Compkiller:_RandomString()
	Left.Parent = ColorRGBSlide
	Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Left.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Left.BorderSizePixel = 0
	Left.Size = UDim2.new(0, 2, 1, 0)
	Left.ZIndex = BaseZ_Index + 100

	UIStroke_3.Parent = Left

	Right.Name = Compkiller:_RandomString()
	Right.Parent = ColorRGBSlide
	Right.AnchorPoint = Vector2.new(1, 0)
	Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Right.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Right.BorderSizePixel = 0
	Right.Position = UDim2.new(1, 0, 0, 0)
	Right.Size = UDim2.new(0, 2, 1, 0)
	Right.ZIndex = BaseZ_Index + 100

	UIStroke_4.Parent = Right

	ColorOpc.Name = Compkiller:_RandomString()
	ColorOpc.Parent = ColorPickerWindow
	ColorOpc.BackgroundColor3 = Color3.fromRGB(102, 255, 0)
	ColorOpc.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorOpc.BorderSizePixel = 0
	ColorOpc.Position = UDim2.new(0, 7, 0, 160)
	ColorOpc.Size = UDim2.new(1, -30, 0, 9)
	ColorOpc.ZIndex = BaseZ_Index + 6

	UICorner_4.CornerRadius = UDim.new(1, 0)
	UICorner_4.Parent = ColorOpc

	ColorOptSlide.Name = Compkiller:_RandomString()
	ColorOptSlide.Parent = ColorOpc
	ColorOptSlide.AnchorPoint = Vector2.new(0, 0.5)
	ColorOptSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorOptSlide.BackgroundTransparency = 1.000
	ColorOptSlide.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorOptSlide.BorderSizePixel = 0
	ColorOptSlide.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorOptSlide.Size = UDim2.new(0, 2, 1, 0)
	ColorOptSlide.ZIndex = BaseZ_Index + 7

	Left_2.Name = Compkiller:_RandomString()
	Left_2.Parent = ColorOptSlide
	Left_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Left_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Left_2.BorderSizePixel = 0
	Left_2.Size = UDim2.new(1, 0, 0, 2)
	Left_2.ZIndex = BaseZ_Index + 100

	UIStroke_5.Parent = Left_2

	Right_2.Name = Compkiller:_RandomString()
	Right_2.Parent = ColorOptSlide
	Right_2.AnchorPoint = Vector2.new(0, 1)
	Right_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Right_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Right_2.BorderSizePixel = 0
	Right_2.Position = UDim2.new(0, 0, 1, 0)
	Right_2.Size = UDim2.new(1, 0, 0, 2)
	Right_2.ZIndex = BaseZ_Index + 100

	UIStroke_6.Parent = Right_2

	UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
	UIGradient_2.Parent = ColorOpc

	UIStroke_7.Transparency = 0.500
	UIStroke_7.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_7.Parent = ColorOpc

	TransparentImage.Name = Compkiller:_RandomString()
	TransparentImage.Parent = ColorOpc
	TransparentImage.BackgroundTransparency = 1.000
	TransparentImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TransparentImage.BorderSizePixel = 0
	TransparentImage.Size = UDim2.new(1, 0, 1, 0)
	TransparentImage.ZIndex = BaseZ_Index + 5
	TransparentImage.Image = Compkiller:CacheImage(GetAsset("6198493000"))
	TransparentImage.ImageColor3 = Color3.fromRGB(206, 206, 206)
	TransparentImage.ScaleType = Enum.ScaleType.Crop

	UICorner_5.CornerRadius = UDim.new(1, 0)
	UICorner_5.Parent = TransparentImage

	HexFrame.Name = Compkiller:_RandomString()
	HexFrame.Parent = ColorPickerWindow
	HexFrame.AnchorPoint = Vector2.new(0.5, 1)
	HexFrame.BackgroundColor3 = Compkiller.Colors.BlockColor
	HexFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HexFrame.BorderSizePixel = 0
	HexFrame.Position = UDim2.new(0.5, 0, 1, -5)
	HexFrame.Size = UDim2.new(1, -16, 0, 20)
	HexFrame.ZIndex = BaseZ_Index + 205

	table.insert(Compkiller.Elements.BlockColor,{
		Element = HexFrame,
		Property = "BackgroundColor3"
	});

	UICorner_6.CornerRadius = UDim.new(0, 4)
	UICorner_6.Parent = HexFrame

	UIStroke_8.Color = Compkiller.Colors.HighStrokeColor
	UIStroke_8.Parent = HexFrame

	table.insert(Compkiller.Elements.HighStrokeColor,{
		Element = UIStroke_8,
		Property = "Color"
	});

	TextLabel.Parent = HexFrame
	TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextLabel.Size = UDim2.new(1, -10, 1, -5)
	TextLabel.ZIndex = BaseZ_Index + 206
	TextLabel.Font = Enum.Font.Gotham
	TextLabel.Text = "#FFFFFFF"
	TextLabel.TextColor3 = Compkiller.Colors.SwitchColor
	TextLabel.TextSize = 13.000
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left

	table.insert(Compkiller.Elements.SwitchColor , {
		Element = TextLabel,
		Property = 'TextColor3'
	});

	local Args = {
		IsHold = false,
		IsVisible = false,
	};

	local Tween = TweenInfo.new(0.2 , Enum.EasingStyle.Quad);
	local Tween2 = TweenInfo.new(0.275 , Enum.EasingStyle.Quad);

	Compkiller:_AddPropertyEvent(ColorPickerWindow,function(v)
		ColorPickerWindow.Visible = v;

		if Compkiller.PerformanceMode then
			if ColorPickerWindow.Visible then
				Compkiller:_SetNilP(ColorPickerWindow , Window);
			else
				Compkiller:_SetNilP(ColorPickerWindow , nil);
			end;
		else
			Compkiller:_SetNilP(ColorPickerWindow , Window);
		end;
	end)

	local ToggleUI = function(bool)
		local IsSame = Args.IsVisible == bool;

		Args.IsVisible = bool;

		local MainPosition = UDim2.new(0,Button.AbsolutePosition.X + 95,0,Button.AbsolutePosition.Y + 65);
		local DropPosition = UDim2.new(0,MainPosition.X.Offset,0,MainPosition.Y.Offset + 15);

		local MUL = Window.AbsoluteSize.Y / 2;

		if MainPosition.Y.Offset > MUL then -- go up
			MainPosition = UDim2.fromOffset(Button.AbsolutePosition.X,Button.AbsolutePosition.Y + 45);
			DropPosition = UDim2.fromOffset(MainPosition.X.Offset,MainPosition.Y.Offset - 25);

			ColorPickerWindow.AnchorPoint = Vector2.new(0.5,1)
		else
			ColorPickerWindow.AnchorPoint = Vector2.new(0.5,0)
		end;

		if bool then

			if not IsSame then
				ColorPickerWindow.Position = DropPosition
			end;

			Compkiller:_Animation(ColorPickerWindow,Tween2,{
				BackgroundTransparency = 0,
				Size = UDim2.new(0, 175, 0, 200)
			});

			Compkiller:_Animation(ColorPickerWindow,Tween,{
				Position = MainPosition,
			});

			Compkiller:_Animation(UIStroke_8,Tween,{
				Transparency = 0
			});

			Compkiller:_Animation(UIStroke_7,Tween,{
				Transparency = 0.5
			});

			Compkiller:_Animation(UIStroke_6,Tween,{
				Transparency = 0
			});

			Compkiller:_Animation(UIStroke_5,Tween,{
				Transparency = 0
			});

			Compkiller:_Animation(UIStroke_4,Tween,{
				Transparency = 0
			});

			Compkiller:_Animation(UIStroke_3,Tween,{
				Transparency = 0
			});

			Compkiller:_Animation(UIStroke_2,Tween,{
				Transparency = 0
			});

			Compkiller:_Animation(UIStroke,Tween,{
				Transparency = 0
			});

			Compkiller:_Animation(ColorPickBox,Tween,{
				BackgroundTransparency = 0,
				ImageTransparency = 0
			});

			Compkiller:_Animation(MouseMovement,Tween,{
				ImageTransparency = 0
			});

			Compkiller:_Animation(ColorOpc,Tween,{
				BackgroundTransparency = 0
			});

			Compkiller:_Animation(TransparentImage,Tween,{
				ImageTransparency = 0
			});

			Compkiller:_Animation(Left,Tween,{
				BackgroundTransparency = 0
			});

			Compkiller:_Animation(Left_2,Tween,{
				BackgroundTransparency = 0
			});

			Compkiller:_Animation(Right,Tween,{
				BackgroundTransparency = 0
			});

			Compkiller:_Animation(Right_2,Tween,{
				BackgroundTransparency = 0
			});

			Compkiller:_Animation(ColorRedGreenBlue,Tween,{
				BackgroundTransparency = 0
			});

			Compkiller:_Animation(HexFrame,Tween,{
				BackgroundTransparency = 0
			});

			Compkiller:_Animation(TextLabel,Tween,{
				TextTransparency = 0
			});
		else
			Compkiller:_Animation(UIStroke_8,Tween,{
				Transparency = 1
			});

			Compkiller:_Animation(UIStroke_7,Tween,{
				Transparency = 1
			});

			Compkiller:_Animation(UIStroke_6,Tween,{
				Transparency = 1
			});

			Compkiller:_Animation(UIStroke_5,Tween,{
				Transparency = 1
			});

			Compkiller:_Animation(UIStroke_4,Tween,{
				Transparency = 1
			});

			Compkiller:_Animation(UIStroke_3,Tween,{
				Transparency = 1
			});

			Compkiller:_Animation(UIStroke_2,Tween,{
				Transparency = 1
			});

			Compkiller:_Animation(UIStroke,Tween,{
				Transparency = 1
			});

			Compkiller:_Animation(ColorPickerWindow,Tween2,{
				BackgroundTransparency = 1,
			});

			Compkiller:_Animation(ColorPickerWindow,Tween,{
				Position = DropPosition,
			});

			Compkiller:_Animation(ColorPickBox,Tween,{
				BackgroundTransparency = 1,
				ImageTransparency = 1
			});

			Compkiller:_Animation(MouseMovement,Tween,{
				ImageTransparency = 1
			});

			Compkiller:_Animation(ColorOpc,Tween,{
				BackgroundTransparency = 1
			});

			Compkiller:_Animation(TransparentImage,Tween,{
				ImageTransparency = 1
			});

			Compkiller:_Animation(Left,Tween,{
				BackgroundTransparency = 1
			});

			Compkiller:_Animation(Left_2,Tween,{
				BackgroundTransparency = 1
			});

			Compkiller:_Animation(Right,Tween,{
				BackgroundTransparency = 1
			});

			Compkiller:_Animation(Right_2,Tween,{
				BackgroundTransparency = 1
			});

			Compkiller:_Animation(ColorRedGreenBlue,Tween,{
				BackgroundTransparency = 1
			});

			Compkiller:_Animation(HexFrame,Tween,{
				BackgroundTransparency = 1
			});

			Compkiller:_Animation(TextLabel,Tween,{
				TextTransparency = 1
			});
		end;
	end;

	Button.MouseButton1Click:Connect(function()
		ToggleUI(true);
	end)

	local H , S , V = 0,0,0;
	local Transparency = 0;

	function Args:SetColor(Color: Color3 , TransparencyValue: number)
		H , S , V = Color:ToHSV();
		Transparency = TransparencyValue;
	end;

	function Args:Update()
		local MainColor = Color3.fromHSV(H , S , 1);
		local RealColor = Color3.fromHSV(H , S , V);

		Compkiller:_Animation(ColorPickBox,TweenInfo.new(0.2),{
			BackgroundColor3 = Color3.fromHSV(H , 1 , 1)
		});

		Compkiller:_Animation(ColorOpc,TweenInfo.new(0.2),{
			BackgroundColor3 = RealColor
		});

		Compkiller:_Animation(MouseMovement,TweenInfo.new(0.2),{
			Position = UDim2.fromScale(S , 1 - V)
		});

		Compkiller:_Animation(ColorOptSlide,TweenInfo.new(0.2),{
			Position = UDim2.new(Transparency ,0 , 0.5 ,0)
		});

		Compkiller:_Animation(ColorRGBSlide,TweenInfo.new(0.2),{
			Position = UDim2.new(0.5 ,0 , H ,0)
		});

		TextLabel.Text = "#" .. tostring(RealColor:ToHex())

		Callback(RealColor , Transparency);
	end;

	local SPAWN_THREAD;

	ColorPickerWindow.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Args.IsHold = true;

			if SPAWN_THREAD then
				task.cancel(SPAWN_THREAD);
				SPAWN_THREAD = nil;
			end;

			SPAWN_THREAD = task.spawn(function()
				while true do task.wait(0.00001)
					if not Args.IsHold then
						break;	
					end;

					Callback(Color3.fromHSV(H , S , V),Transparency);
				end;
			end);
		end;
	end)

	ColorPickerWindow.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Args.IsHold = false;

			if SPAWN_THREAD then
				task.cancel(SPAWN_THREAD);
				SPAWN_THREAD = nil;
			end;
		end;
	end)

	UserInputService.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			if not Compkiller:_IsMouseOverFrame(ColorPickerWindow) then
				ToggleUI(false);
			end;
		end;
	end)

	ColorRedGreenBlue.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Args.IsHold = true;

			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or Args.IsHold) do task.wait()
				local ColorY = ColorRedGreenBlue.AbsolutePosition.Y
				local ColorYM = ColorY + ColorRedGreenBlue.AbsoluteSize.Y;
				local Value = math.clamp(Mouse.Y, ColorY, ColorYM)
				local Code = ((Value - ColorY) / (ColorYM - ColorY));

				H = Code;

				Args:Update();
			end;
		end;
	end);

	ColorOpc.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Args.IsHold = true;

			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or Args.IsHold) do task.wait()
				local transparency = math.clamp((((Mouse.X) - ColorOpc.AbsolutePosition.X) / ColorOpc.AbsoluteSize.X), 0, 1);
				local RealColor = Color3.fromHSV(H , S , V);

				TextLabel.Text = "#" .. tostring(RealColor:ToHex())

				Transparency = transparency;

				Args:Update();
			end;
		end;
	end);

	ColorPickBox.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Args.IsHold = true;

			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or Args.IsHold) do task.wait();
				local PosX = ColorPickBox.AbsolutePosition.X
				local ScaleX = PosX + ColorPickBox.AbsoluteSize.X
				local Value, PosY = math.clamp(Mouse.X, PosX, ScaleX), ColorPickBox.AbsolutePosition.Y
				local ScaleY = PosY + ColorPickBox.AbsoluteSize.Y
				local Vals = math.clamp(Mouse.Y, PosY, ScaleY)
				local RealColor = Color3.fromHSV(H , S , V);

				S = (Value - PosX) / (ScaleX - PosX);
				V = (1 - ((Vals - PosY) / (ScaleY - PosY)));

				TextLabel.Text = "#" .. tostring(RealColor:ToHex())

				Args:Update();
			end
		end
	end)

	return Args;
end;

function Compkiller:_DrawKeybinds(Window: ScreenGui)
	if Compkiller.__KEYBINDS_CACHE then
		return Compkiller.__KEYBINDS_CACHE;
	end;

	local Keybinds = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local IconFrame = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local Frame = Instance.new("Frame")
	local Icon = Instance.new("ImageLabel")
	local HeaderFrame = Instance.new("Frame")
	local HeadLabel = Instance.new("TextLabel")
	local MainFrame = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local MovingFrame = Instance.new("Frame")

	Keybinds.Name = Compkiller:_RandomString()
	Keybinds.Parent = Window
	Keybinds.BackgroundColor3 = Compkiller.Colors.BGDBColor;
	Keybinds.BackgroundTransparency = 0.025
	Keybinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Keybinds.BorderSizePixel = 0
	Keybinds.Position = UDim2.new(0,100,0,100)
	Keybinds.Size = UDim2.new(0, 125, 0, 25)
	Keybinds.ZIndex = 150

	table.insert(Compkiller.Elements.BGDBColor,{
		Element = Keybinds,
		Property = 'BackgroundColor3'
	});


	UICorner.CornerRadius = UDim.new(0, 3)
	UICorner.Parent = Keybinds

	IconFrame.Name = Compkiller:_RandomString()
	IconFrame.Parent = Keybinds
	IconFrame.AnchorPoint = Vector2.new(1, 0.5)
	IconFrame.BackgroundColor3 = Compkiller.Colors.BGDBColor
	IconFrame.BackgroundTransparency = 0.300
	IconFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	IconFrame.BorderSizePixel = 0
	IconFrame.Position = UDim2.new(0, 5, 0.5, 0)
	IconFrame.Size = UDim2.new(1, 10, 1, 0)
	IconFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
	IconFrame.ZIndex = 149

	table.insert(Compkiller.Elements.BGDBColor,{
		Element = IconFrame,
		Property = 'BackgroundColor3'
	});

	UICorner_2.CornerRadius = UDim.new(0, 3)
	UICorner_2.Parent = IconFrame

	Frame.Parent = IconFrame
	Frame.AnchorPoint = Vector2.new(0, 0.5)
	Frame.BackgroundColor3 = Compkiller.Colors.Highlight;
	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(1, -5, 0.5, 0)
	Frame.Size = UDim2.new(0, 2, 1, 0)
	Frame.ZIndex = 151

	table.insert(Compkiller.Elements.Highlight,{
		Element = Frame,
		Property = 'BackgroundColor3'
	});

	Icon.Name = Compkiller:_RandomString()
	Icon.Parent = IconFrame
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.BackgroundTransparency = 1.000
	Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Icon.BorderSizePixel = 0
	Icon.Position = UDim2.new(0.5, -2, 0.5, 0)
	Icon.Size = UDim2.new(0, 20, 0, 20)
	Icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
	Icon.ZIndex = 159
	Icon.Image = Compkiller:CacheImage(GetAsset("10723416765"));

	HeaderFrame.Name = Compkiller:_RandomString()
	HeaderFrame.Parent = Keybinds
	HeaderFrame.AnchorPoint = Vector2.new(0.5, 0)
	HeaderFrame.BackgroundTransparency = 1.000
	HeaderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderFrame.BorderSizePixel = 0
	HeaderFrame.ClipsDescendants = true
	HeaderFrame.Position = UDim2.new(0.5, 0, 0, 0)
	HeaderFrame.Size = UDim2.new(1, -10, 1, 0)
	HeaderFrame.ZIndex = 155

	HeadLabel.Name = Compkiller:_RandomString()
	HeadLabel.Parent = HeaderFrame
	HeadLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	HeadLabel.BackgroundTransparency = 1.000
	HeadLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeadLabel.BorderSizePixel = 0
	HeadLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	HeadLabel.Size = UDim2.new(1, -10, 1, 0)
	HeadLabel.ZIndex = 156
	HeadLabel.Font = Enum.Font.GothamMedium
	HeadLabel.Text = "Keybinds"
	HeadLabel.TextColor3 = Compkiller.Colors.SwitchColor
	HeadLabel.TextSize = 12.000

	table.insert(Compkiller.Elements.SwitchColor,{
		Element = HeadLabel,
		Property = 'TextColor3'
	});

	MainFrame.Name = Compkiller:_RandomString()
	MainFrame.Parent = Keybinds
	MainFrame.AnchorPoint = Vector2.new(1, 0)
	MainFrame.BackgroundTransparency = 1.000
	MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(1, 0, 1, 5)
	MainFrame.Size = UDim2.new(1, 30, 1, 3)
	MainFrame.ZIndex = 156;
	MainFrame.ClipsDescendants = true;

	UIListLayout.Parent = MainFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	MovingFrame.Name = Compkiller:_RandomString()
	MovingFrame.Parent = Keybinds
	MovingFrame.AnchorPoint = Vector2.new(1, 0.5)
	MovingFrame.BackgroundTransparency = 1.000
	MovingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MovingFrame.BorderSizePixel = 0
	MovingFrame.Position = UDim2.new(1, 0, 0.5, 0)
	MovingFrame.Size = UDim2.new(1, 30, 1, 0)

	Compkiller:Drag(MovingFrame,Keybinds,0.1);

	local Ref = {
		Root = Keybinds
	};

	Ref.THREAD = task.spawn(function()
		while true do task.wait()
			Compkiller:_Animation(MainFrame,TweenInfo.new(0.4),{
				Size = UDim2.new(1, 30, 1, UIListLayout.AbsoluteContentSize.Y + 1)
			});

			if UIListLayout.AbsoluteContentSize.Y > 1 then
				Compkiller:_Animation(IconFrame,TweenInfo.new(0.25),{
					BackgroundTransparency = 0.3
				})

				Compkiller:_Animation(Frame,TweenInfo.new(0.25),{
					BackgroundTransparency = 0
				})

				Compkiller:_Animation(HeadLabel,TweenInfo.new(0.25),{
					TextTransparency = 0
				})

				Compkiller:_Animation(Icon,TweenInfo.new(0.25),{
					ImageTransparency = 0
				});

				local LargF = 100;

				for i,v in next , MainFrame:GetChildren() do
					if v:GetAttribute('AvgScale') then
						if v:GetAttribute('AvgScale') > LargF then
							LargF = v:GetAttribute('AvgScale');
						end;
					end;
				end;

				Compkiller:_Animation(Keybinds,TweenInfo.new(0.25),{
					BackgroundTransparency = 0.025,
					Size = UDim2.new(0, LargF, 0, 25)
				})
			else
				Compkiller:_Animation(HeadLabel,TweenInfo.new(0.25),{
					TextTransparency = 1
				})

				Compkiller:_Animation(Keybinds,TweenInfo.new(0.25),{
					BackgroundTransparency = 1
				})

				Compkiller:_Animation(IconFrame,TweenInfo.new(0.25),{
					BackgroundTransparency = 1
				})

				Compkiller:_Animation(Frame,TweenInfo.new(0.25),{
					BackgroundTransparency = 1
				})

				Compkiller:_Animation(Icon,TweenInfo.new(0.25),{
					ImageTransparency = 1
				});
			end;

			Keybinds.Visible = (Keybinds.BackgroundTransparency < 0.9 and true) or false;

			if Compkiller.PerformanceMode then
				if Keybinds.Visible then
					Compkiller:_SetNilP(Keybinds , Window);
				else
					Compkiller:_SetNilP(Keybinds , nil);
				end;
			else
				Compkiller:_SetNilP(Keybinds , Window);
			end;
		end;
	end);

	function Ref:AddFrame()
		local Keyholder = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Label = Instance.new("TextLabel")
		local Line = Instance.new("Frame")
		local TypeLabel = Instance.new("TextLabel")
		local UICorner_2 = Instance.new("UICorner")

		Keyholder.Name = Compkiller:_RandomString()
		Keyholder.BackgroundColor3 = Compkiller.Colors.BGDBColor
		Keyholder.BackgroundTransparency = 1
		Keyholder.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Keyholder.BorderSizePixel = 0
		Keyholder.Size = UDim2.new(1, 0, 0, 28)
		Keyholder.ZIndex = MainFrame.ZIndex + 3
		Keyholder.ClipsDescendants = true;

		table.insert(Compkiller.Elements.BGDBColor,{
			Element = Keyholder,
			Property = 'BackgroundColor3'
		});

		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = Keyholder

		Label.Name = Compkiller:_RandomString()
		Label.Parent = Keyholder
		Label.AnchorPoint = Vector2.new(0.5, 0.5)
		Label.BackgroundTransparency = 1.000
		Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Label.BorderSizePixel = 0
		Label.Position = UDim2.new(0.5, 0, 0.5, 0)
		Label.Size = UDim2.new(1, -10, 1, 0)
		Label.ZIndex = MainFrame.ZIndex + 5;
		Label.Font = Enum.Font.GothamMedium
		Label.TextColor3 = Compkiller.Colors.SwitchColor
		Label.TextSize = 11.000
		Label.TextTransparency = 1
		Label.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(Compkiller.Elements.SwitchColor,{
			Element = Label,
			Property = 'TextColor3'
		});

		Line.Name = Compkiller:_RandomString()
		Line.Parent = Keyholder
		Line.AnchorPoint = Vector2.new(1, 0.5)
		Line.BackgroundColor3 = Compkiller.Colors.BGDBColor
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(1, 0, 0.5, 0)
		Line.Size = UDim2.new(0, 30, 1, 0)
		Line.ZIndex = MainFrame.ZIndex + 4

		table.insert(Compkiller.Elements.BGDBColor,{
			Element = Line,
			Property = 'BackgroundColor3'
		});

		TypeLabel.Name = Compkiller:_RandomString()
		TypeLabel.Parent = Line
		TypeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		TypeLabel.BackgroundTransparency = 1.000
		TypeLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TypeLabel.BorderSizePixel = 0
		TypeLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		TypeLabel.Size = UDim2.new(1, 0, 1, 0)
		TypeLabel.ZIndex = MainFrame.ZIndex + 6
		TypeLabel.Font = Enum.Font.GothamMedium
		TypeLabel.TextColor3 = Compkiller.Colors.SwitchColor
		TypeLabel.TextSize = 11.000

		table.insert(Compkiller.Elements.SwitchColor,{
			Element = TypeLabel,
			Property = 'TextColor3'
		});

		UICorner_2.CornerRadius = UDim.new(0, 3)
		UICorner_2.Parent = Line

		local UpdateScale = function()
			local t = TextService:GetTextSize(TypeLabel.Text , TypeLabel.TextSize , TypeLabel.Font , Vector2.new(math.huge,math.huge));
			local z = TextService:GetTextSize(Label.Text , Label.TextSize , Label.Font , Vector2.new(math.huge,math.huge));

			Line.Size = UDim2.new(0, t.X + 5, 1, 0);

			Keyholder:SetAttribute('AvgScale',(t.X + z.X) + 55);
		end;

		UpdateScale();

		local frame_ref = {};

		function frame_ref:SetName(str: string)
			Label.Text = str or Label.Text;

			UpdateScale();
		end;

		function frame_ref:SetType(str: string)
			TypeLabel.Text = str or TypeLabel.Text;

			UpdateScale();
		end;

		function frame_ref:SetVisible(v)
			if v then
				Compkiller:_Animation(Keyholder,TweenInfo.new(0.1),{
					BackgroundTransparency = 0.600,
					Size = UDim2.new(1, 0, 0, 28)
				});

				Compkiller:_Animation(Label,TweenInfo.new(0.15),{
					TextTransparency = 0.100
				});

				Compkiller:_Animation(Line,TweenInfo.new(0.15),{
					BackgroundTransparency = 0
				});

				Compkiller:_Animation(TypeLabel,TweenInfo.new(0.15),{
					TextTransparency = 0
				});
			else
				Compkiller:_Animation(Keyholder,TweenInfo.new(0.1),{
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0)
				});

				Compkiller:_Animation(Label,TweenInfo.new(0.15),{
					TextTransparency = 1
				});

				Compkiller:_Animation(Line,TweenInfo.new(0.15),{
					BackgroundTransparency = 1
				});

				Compkiller:_Animation(TypeLabel,TweenInfo.new(0.15),{
					TextTransparency = 1
				});
			end;

			if Keyholder.BackgroundTransparency <= 0.95 then
				Keyholder.Parent = MainFrame;
			else
				Keyholder.Parent = nil;
			end;

			UpdateScale();
		end;

		return frame_ref;
	end;

	Compkiller.__KEYBINDS_CACHE = Ref;

	return Ref;
end;

function Compkiller:_KeybindHandler(Parent: Frame , ObjectType: string , ElementAPI: Toggle & Slider , Signal , Zindex: number , ElementCFG: Slider)
	local Window = Compkiller:_GetWindowFromElement(Parent);
	local KB_Signal = Compkiller.__SIGNAL(false);
	local SubIndex = math.random(40,100);
	local KeybindInd = Compkiller:_DrawKeybinds(Window);
	local KeybindFrame = KeybindInd:AddFrame();

	local KeybindHandler = Instance.new("Frame")
	local UIStroke = Instance.new("UIStroke")
	local UICorner = Instance.new("UICorner")
	local ElementObjs = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	KeybindHandler.Name = Compkiller:_RandomString()
	KeybindHandler.Parent = Window
	KeybindHandler.BackgroundColor3 = Compkiller.Colors.BlockBackground
	KeybindHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
	KeybindHandler.BorderSizePixel = 0
	KeybindHandler.ClipsDescendants = true
	KeybindHandler.Position = UDim2.new(1,999,1,999)
	KeybindHandler.Size = UDim2.new(0, 225, 0, 0)
	KeybindHandler.ZIndex = Zindex + SubIndex
	KeybindHandler.AnchorPoint = Vector2.new(0.5,0)

	table.insert(Compkiller.Elements.BlockBackground,{
		Element = KeybindHandler,
		Property = 'BackgroundColor3'
	});

	UIStroke.Color = Compkiller.Colors.HighStrokeColor
	UIStroke.Parent = KeybindHandler

	table.insert(Compkiller.Elements.HighStrokeColor,{
		Element = UIStroke,
		Property = 'Color'
	});

	UICorner.CornerRadius = UDim.new(0, 6)
	UICorner.Parent = KeybindHandler

	ElementObjs.Name = Compkiller:_RandomString()
	ElementObjs.Parent = KeybindHandler
	ElementObjs.AnchorPoint = Vector2.new(0.5, 0.5)
	ElementObjs.BackgroundTransparency = 1.000
	ElementObjs.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ElementObjs.BorderSizePixel = 0
	ElementObjs.Position = UDim2.new(0.5, 0, 0.5, 0)
	ElementObjs.Size = UDim2.new(1, -5, 1, -5)
	ElementObjs.ZIndex = Zindex + SubIndex + 10

	UIListLayout.Parent = ElementObjs
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local refreshPF = function()
		if Compkiller.PerformanceMode then
			if KeybindHandler.Size.Y.Offset > 1 then
				Compkiller:_SetNilP(KeybindHandler , Window);
			else
				Compkiller:_SetNilP(KeybindHandler , nil);
			end;
		else
			Compkiller:_SetNilP(KeybindHandler , Window);
		end;
	end;

	KeybindHandler:GetPropertyChangedSignal('Size'):Connect(refreshPF);

	task.delay(0.1,refreshPF);

	local ToggleUI = function(bool)
		if bool then
			KeybindHandler.Position = UDim2.new(0,Parent.AbsolutePosition.X + 225,0,Parent.AbsolutePosition.Y)

			Compkiller:_Animation(KeybindHandler,TweenInfo.new(0.25),{
				BackgroundTransparency = 0,
				Size = UDim2.new(0, 225, 0, UIListLayout.AbsoluteContentSize.Y + 5)
			});

			Compkiller:_Animation(UIStroke,TweenInfo.new(0.3),{
				Transparency = 0
			});
		else
			Compkiller:_Animation(KeybindHandler,TweenInfo.new(0.3),{
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 225, 0, 0)
			});

			Compkiller:_Animation(UIStroke,TweenInfo.new(0.3),{
				Transparency = 1
			});
		end;
	end;

	ToggleUI(false);

	KB_Signal:Connect(ToggleUI);

	local APIRef = {
		Name = ElementAPI:GetText()
	};

	local ModeEnum = {
		[1] = 'Off', -- disabled / off
		[2] = "Hold",
		[3] = "Toggle",
		[4] = "On", -- alway on
	};

	local e_m = {
		['Off'] = 1,
		['Hold'] = 2,
		['Toggle'] = 3,
		['On'] = 4,
	};

	if ObjectType == "Toggle" then
		APIRef.Off = false;
		APIRef.On = true;
		APIRef.Keybind = nil;
		APIRef.Mode = e_m.Off;


	elseif ObjectType == "Number" then
		APIRef.Off = 1;
		APIRef.On = 0;
		APIRef.Keybind = nil;
		APIRef.Mode = e_m.Off;
	end;

	local Flag = {};

	APIRef.Update = function()
		KeybindFrame:SetName(APIRef.Name);
		KeybindFrame:SetType(ModeEnum[APIRef.Mode]);
	end

	local ElementAPIs = Compkiller:_LoadElement(ElementObjs , true , KB_Signal , true);

	Flag.Key = ElementAPIs:AddKeybind({
		Name = "Key",
		Default = APIRef.Keybind,
		Callback = function(v)
			APIRef.Keybind = v;
		end,
	});

	Flag.Mode = ElementAPIs:AddDropdown({
		Name = "Mode",
		Default = ModeEnum[APIRef.Mode],
		Values = ModeEnum,
		Callback = function(v)
			APIRef.Mode = e_m[v];

			if APIRef.Mode == 4 then
				ElementAPI:SetValue(APIRef.On);
			end;
		end,
	});

	if ObjectType == "Toggle" then
		Flag.On = ElementAPIs:AddToggle({
			Name = "ON Value",
			Default = APIRef.On,
			Callback = function(v)
				APIRef.On = v;
			end,
		});

		Flag.Off = ElementAPIs:AddToggle({
			Name = "OFF Value",
			Default = APIRef.Off,
			Callback = function(v)
				APIRef.Off = v;
			end,
		});
	elseif ObjectType == "Number" then
		Flag.On = ElementAPIs:AddSlider({
			Name = "ON Value",
			Default = APIRef.On,
			Min = ElementCFG.Min,
			Round = ElementCFG.Round,
			Max = ElementCFG.Max,
			Type = ElementCFG.Type,
			Callback = function(v)
				APIRef.On = v;
			end,
		});

		Flag.Off = ElementAPIs:AddSlider({
			Name = "OFF Value",
			Default = APIRef.Off,
			Min = ElementCFG.Min,
			Round = ElementCFG.Round,
			Max = ElementCFG.Max,
			Type = ElementCFG.Type,
			Callback = function(v)
				APIRef.Off = v;
			end,
		});
	end;

	Flag.ShowInKeybindList = ElementAPIs:AddTextBox({
		Name = "Name",
		Default = APIRef.Name,
		Placeholder = "Keybind Name",
		Callback = function(v)
			APIRef.Name = v;
		end,
	})

	function APIRef:GetSettings()
		APIRef.Update();

		return {
			Key = APIRef.Keybind,
			On = APIRef.On,
			Off = APIRef.Off,
			Mode = APIRef.Mode,
			Name = APIRef.Name,
		};
	end;

	function APIRef:LoadSettings(cfg : KeybindSettings)
		Flag.ShowInKeybindList:SetValue(cfg.Name);
		Flag.Off:SetValue(cfg.Off);
		Flag.On:SetValue(cfg.On);
		Flag.Mode:SetValue(ModeEnum[cfg.Mode]);
		Flag.Key:SetValue(cfg.Key);

		APIRef.Update();
	end;

	APIRef.Thread = task.spawn(function()
		while true do task.wait(0.01)
			if APIRef.Mode ~= 1 then
				if ElementAPI:GetValue() == APIRef.On then
					KeybindFrame:SetVisible(true);
				else
					KeybindFrame:SetVisible(false);
				end;

				APIRef.Update();
			else
				KeybindFrame:SetVisible(false);
			end;
		end;
	end)

	Parent.InputEnded:Connect(function(Input,Typing)
		if Input.UserInputType == Enum.UserInputType.MouseButton2 and not Typing then
			KB_Signal:Fire(true);
		end;
	end);

	UserInputService.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.MouseButton2 or Input.UserInputType == Enum.UserInputType.Touch then
			if not Compkiller:_IsMouseOverFrame(Parent) and not Compkiller:_IsMouseOverFrame(KeybindHandler) then
				KB_Signal:Fire(false);
			end;
		end;
	end);

	UserInputService.InputBegan:Connect(function(Input,Typing)
		if Input.KeyCode.Name == APIRef.Keybind or Input.KeyCode == APIRef.Keybind or (Input.UserInputType == Enum.UserInputType.MouseButton1 and APIRef.Keybind == "MouseLeft") or (Input.UserInputType == Enum.UserInputType.MouseButton2 and APIRef.Keybind == "MouseRight") then

			if APIRef.Mode == 2 or APIRef.Mode == 4 then
				ElementAPI:SetValue(APIRef.On);
			elseif APIRef.Mode == 3 then
				if ElementAPI:GetValue() == APIRef.On then
					ElementAPI:SetValue(APIRef.Off);
				else
					ElementAPI:SetValue(APIRef.On);
				end;
			end;
		end;
	end);

	UserInputService.InputEnded:Connect(function(Input,Typing)
		if Input.KeyCode.Name == APIRef.Keybind or Input.KeyCode == APIRef.Keybind or (Input.UserInputType == Enum.UserInputType.MouseButton1 and APIRef.Keybind == "MouseLeft") or (Input.UserInputType == Enum.UserInputType.MouseButton2 and APIRef.Keybind == "MouseRight") then

			if APIRef.Mode == 2 then
				ElementAPI:SetValue(APIRef.Off);
			elseif APIRef.Mode == 4 then
				ElementAPI:SetValue(APIRef.On);
			end;
		end;
	end);

	return APIRef;
end;

function Compkiller:_AddPropertyEvent(Target: Frame , Callback: (boolean) -> any)
	Target:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
		Callback(Target.BackgroundTransparency <= 0.9)
	end)
end;

function Compkiller:_LoadOption(Value , TabSignal)
	local Args = {};
	local Window = Compkiller:_GetWindowFromElement(Value.Root);
	local Tween = TweenInfo.new(0.3,Enum.EasingStyle.Quint);

	function Args:AddKeybind(Config: MiniKeybind)
		Config = Compkiller.__CONFIG(Config,{
			Name = "Keybind",
			Default = nil,
			Flag = nil,
			Callback = function() end;
			Blacklist = {}
		});

		local Keybind = Value:AddLink('Keybind' , Config.Default);

		local IsBinding = false;

		local IsBlacklist = function(v)
			return Config.Blacklist and (Config.Blacklist[v] or table.find(Config.Blacklist,v))
		end;

		Compkiller:_Input(Keybind.Root,function()
			if IsBinding then
				return;
			end;

			Keybind.SetValue("...");

			local Selected = nil;

			while not Selected do
				local Key = UserInputService.InputBegan:Wait();

				if Key.KeyCode ~= Enum.KeyCode.Unknown and not IsBlacklist(Key.KeyCode) and not IsBlacklist(Key.KeyCode.Name) then
					Selected = Key.KeyCode;
				else
					if Key.UserInputType == Enum.UserInputType.MouseButton1 and not IsBlacklist(Enum.UserInputType.MouseButton1) and not IsBlacklist("MouseLeft") then
						Selected = "MouseLeft";
					elseif Key.UserInputType == Enum.UserInputType.MouseButton2 and not IsBlacklist(Enum.UserInputType.MouseButton2) and not IsBlacklist("MouseRight") then
						Selected = "MouseRight";
					end;
				end;
			end;

			local KeyName = (typeof(Selected) == "string" and Selected) or Selected.Name;

			Config.Default = KeyName;

			Keybind.SetValue(Selected);

			IsBinding = false;

			Config.Callback(KeyName);
		end);

		local Args = {};

		Args.Flag = Config.Flag;

		function Args:SetValue(value)
			Config.Default = value;

			Keybind.SetValue(Config.Default);

			Config.Callback(Config.Default);
		end;

		function Args:GetValue()
			return (typeof(Config.Default) == "string" and Config.Default) or Config.Default.Name;
		end;

		if Config.Flag then
			Compkiller.Flags[Config.Flag] = Args;
		end;

		return Args;
	end;

	function Args:AddHelper(Config: Helper)
		Config = Compkiller.__CONFIG(Config,{
			Text = "Information."
		});

		local Helper = Value:AddLink("Helper" , Config.Default);
		local Button: ImageButton = Helper.InfoButton;

		Helper.Text.Parent = Window;

		Helper.UIStroke:GetPropertyChangedSignal('Transparency'):Connect(function()
			if Helper.UIStroke.Transparency > 0.9 then
				Helper.Text.Visible = false;
			else
				Helper.Text.Visible = true;
			end;

			if Compkiller.PerformanceMode then
				if Helper.Text.Visible then
					Compkiller:_SetNilP(Helper.Text , Window);
				else
					Compkiller:_SetNilP(Helper.Text , nil);
				end;
			else
				Compkiller:_SetNilP(Helper.Text , Window);
			end;
		end)

		local Update = function()
			local mainText = " "..Config.Text;

			mainText = string.gsub(mainText,'\n','\n ')

			Helper.Text.Text = mainText;

			local scale = TextService:GetTextSize(Helper.Text.Text,Helper.Text.TextSize,Helper.Text.Font,Vector2.new(math.huge,math.huge));

			Compkiller:_Animation(Helper.Text , TweenInfo.new(0.15), {
				Size = UDim2.fromOffset(scale.X + 50, scale.Y + 5)
			})

			return scale;
		end;

		local Release = function()
			local scale = Update()

			Compkiller:_Animation(Helper.Text,TweenInfo.new(0.15),{
				TextTransparency = 1,
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(Button.AbsolutePosition.X,Button.AbsolutePosition.Y + (45))
			});

			Compkiller:_Animation(Helper.UIStroke,TweenInfo.new(0.15),{
				Transparency = 1
			});
		end;

		local Hold = function()
			local scale = Update()

			if not Helper.Text.Visible then
				Helper.Text.Position = UDim2.fromOffset(Button.AbsolutePosition.X,Button.AbsolutePosition.Y + (45))
			end;

			Compkiller:_Animation(Helper.Text,TweenInfo.new(0.15),{
				TextTransparency = 0.35,
				BackgroundTransparency = 0,
				Position = UDim2.fromOffset(Button.AbsolutePosition.X,Button.AbsolutePosition.Y + (40 - (scale.Y / 2)))
			});

			Compkiller:_Animation(Helper.UIStroke,TweenInfo.new(0.15),{
				Transparency = 0
			});

		end;

		Compkiller:_Hover(Button,  Hold, Release);

		Release();

		local Args = {};

		function Args:SetValue(value)
			Config.Text = value;
		end;

		return Args;
	end;

	function Args:AddColorPicker(Config: MiniColorPicker)
		Config = Compkiller.__CONFIG(Config,{
			Default = Color3.fromRGB(255,255,255),
			Transparency = 0,
			Callback = function() end
		});

		local ColorPicker:Frame , ColorFrame: Frame = Value:AddLink('ColorPicker' , Config.Default);

		local Button = Compkiller:_Input(ColorPicker);

		local ColorPicker = Compkiller:_AddColorPickerPanel(Button,function(color,opc)
			Config.Default = color;
			Config.Transparency = opc;

			ColorFrame.BackgroundColor3 = color;
			ColorFrame.BackgroundTransparency = opc;

			Config.Callback(Config.Default , Config.Transparency);
		end);

		ColorPicker:SetColor(Config.Default,Config.Transparency);
		ColorPicker:Update()

		local Args = {};

		Args.Flag = Config.Flag;

		function Args:SetValue(value,opc)
			Config.Default = value;
			Config.Transparency = opc;

			ColorPicker:SetColor(value,opc)

			ColorPicker:Update()

			Config.Callback(value,opc);
		end;

		function Args:GetValue()
			return {
				ColorPicker = {
					Color = Config.Default,
					Transparency = Config.Transparency
				}
			};
		end;

		if Config.Flag then
			Compkiller.Flags[Config.Flag] = Args;
		end;

		return Args;
	end;

	function Args:AddToggle(Config : MiniToggle)
		Config = Compkiller.__CONFIG(Config,{
			Flag = nil,
			Default = false,
			Callback = function() end;
		});

		local Toggle = Value:AddLink("Toggle" , Config.Default);

		Toggle.Input.MouseButton1Click:Connect(function()
			Config.Default = not Config.Default;

			Toggle.ChangeValue(Config.Default);

			Config.Callback(Config.Default);
		end);

		local Args = {};

		Args.Flag = Config.Flag

		function Args:SetValue(value)
			Config.Default = value;

			Toggle.ChangeValue(Config.Default);

			Config.Callback(Config.Default);
		end;

		function Args:GetValue()
			return Config.Default;
		end;

		if Config.Flag then
			Compkiller.Flags[Config.Flag] = Args;
		end;

		return Args;
	end;

	function Args:AddOption()
		local Element: ImageButton = Value:AddLink("Option");
		local BaseZ_Index = math.random(1,15) * 100;

		local Signal = Compkiller.__SIGNAL(false);

		local ExtractElement = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local Elements = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local Toggl = false;

		local ToggleUI = function(bool)
			local IsSameValue = bool == Toggl;

			Toggl = bool;

			local MainPosition = UDim2.fromOffset(Element.AbsolutePosition.X,Element.AbsolutePosition.Y + 80);
			local DropPosition = UDim2.fromOffset(MainPosition.X.Offset,MainPosition.Y.Offset + 15);
			local MUL = Window.AbsoluteSize.Y / 2;

			if MainPosition.Y.Offset > MUL then -- go up
				MainPosition = UDim2.fromOffset(Element.AbsolutePosition.X,Element.AbsolutePosition.Y + 45);
				DropPosition = UDim2.fromOffset(MainPosition.X.Offset,MainPosition.Y.Offset - 25);
				ExtractElement.AnchorPoint = Vector2.new(0,1)
			else
				ExtractElement.AnchorPoint = Vector2.new(0,0)
			end;

			if bool then
				Signal:Fire(true);

				if not IsSameValue then
					ExtractElement.Position = DropPosition
				end;

				Compkiller:_Animation(ExtractElement , Tween , {
					Position = MainPosition,
					BackgroundTransparency = 0,
					Size = UDim2.new(0, 225, 0, UIListLayout.AbsoluteContentSize.Y)
				});

				Compkiller:_Animation(UIStroke , Tween , {
					Transparency = 0
				});

			else
				Signal:Fire(false);

				Compkiller:_Animation(ExtractElement , Tween , {
					Position = DropPosition,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 225, 0, UIListLayout.AbsoluteContentSize.Y - 10)
				});

				Compkiller:_Animation(UIStroke , Tween , {
					Transparency = 1
				});
			end;
		end;

		Compkiller:_AddPropertyEvent(ExtractElement,function(bool)
			ExtractElement.Visible = bool;

			if Compkiller.PerformanceMode then
				if ExtractElement.Visible then
					Compkiller:_SetNilP(ExtractElement , Window);
				else
					Compkiller:_SetNilP(ExtractElement , nil);
				end;
			else
				Compkiller:_SetNilP(ExtractElement , Window);
			end;
		end);

		Compkiller:_AddDragBlacklist(ExtractElement);

		ExtractElement.Name = Compkiller:_RandomString()
		ExtractElement.Parent = Window
		ExtractElement.BackgroundColor3 = Compkiller.Colors.BlockBackground
		ExtractElement.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ExtractElement.BorderSizePixel = 0
		ExtractElement.ClipsDescendants = true
		ExtractElement.Position = UDim2.new(123, 0, 123, 0)
		ExtractElement.Size = UDim2.new(0, 225, 0, 35)
		ExtractElement.ZIndex = BaseZ_Index
		ExtractElement.Visible = false
		ExtractElement.ClipsDescendants = true

		table.insert(Compkiller.Elements.BlockBackground,{
			Element = ExtractElement,
			Property = "BackgroundColor3"
		});

		UIStroke.Color = Compkiller.Colors.HighStrokeColor
		UIStroke.Parent = ExtractElement

		table.insert(Compkiller.Elements.HighStrokeColor,{
			Element = UIStroke,
			Property = "Color"
		});

		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = ExtractElement

		Elements.Name = Compkiller:_RandomString()
		Elements.Parent = ExtractElement
		Elements.AnchorPoint = Vector2.new(0.5, 0.5)
		Elements.BackgroundTransparency = 1.000
		Elements.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Elements.BorderSizePixel = 0
		Elements.Position = UDim2.new(0.5, 0, 0.5, 0)
		Elements.Size = UDim2.new(1, -5, 1,-1)
		Elements.ZIndex = BaseZ_Index + 20

		UIListLayout.Parent = Elements
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 0)

		ToggleUI(false);

		Element.MouseButton1Click:Connect(function()
			ToggleUI(true);
		end);

		UserInputService.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if Toggl and not Compkiller:_IsMouseOverFrame(ExtractElement) and not Compkiller:_IsMouseOverFrame(Element) then
					ToggleUI(false);
				end;
			end
		end)		

		return Compkiller:_LoadElement(Elements , true , Signal)
	end;

	return Args;
end;

function Compkiller:_LoadDropdown(BaseParent: TextButton , Callback: () -> any)
	local Window = Compkiller:_GetWindowFromElement(BaseParent);

	local BaseZ_Index = BaseParent.ZIndex + (math.random(1,15) * 100);

	local DropdownWindow = Instance.new("Frame")
	local UIStroke = Instance.new("UIStroke")
	local UICorner = Instance.new("UICorner")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local ToggleDb = Compkiller.__SIGNAL(false);
	local EventOut = Compkiller.__SIGNAL(0);

	DropdownWindow.Name = Compkiller:_RandomString()
	DropdownWindow.Parent = Window
	DropdownWindow.BackgroundColor3 = Compkiller.Colors.BlockBackground
	DropdownWindow.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DropdownWindow.BorderSizePixel = 0
	DropdownWindow.Position = UDim2.new(123, 0, 123, 0)
	DropdownWindow.Size = UDim2.new(0, 190, 0, 200)
	DropdownWindow.ZIndex = BaseZ_Index

	table.insert(Compkiller.Elements.BlockBackground,{
		Element = DropdownWindow,
		Property = "BackgroundColor3"
	});

	Compkiller:_AddDragBlacklist(DropdownWindow);
	Compkiller:_AddPropertyEvent(DropdownWindow,function(v)
		DropdownWindow.Visible = v;

		if Compkiller.PerformanceMode then
			if DropdownWindow.Visible then
				Compkiller:_SetNilP(DropdownWindow , Window);
			else
				Compkiller:_SetNilP(DropdownWindow , nil);
			end;
		else
			Compkiller:_SetNilP(DropdownWindow , Window);
		end;
	end)

	UIStroke.Color = Compkiller.Colors.HighStrokeColor
	UIStroke.Parent = DropdownWindow

	table.insert(Compkiller.Elements.HighStrokeColor , {
		Element = UIStroke,
		Property = "Color"
	})

	UICorner.CornerRadius = UDim.new(0, 6)
	UICorner.Parent = DropdownWindow

	ScrollingFrame.Parent = DropdownWindow
	ScrollingFrame.Active = true
	ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	ScrollingFrame.Size = UDim2.new(1, -5, 1, -5)
	ScrollingFrame.ZIndex = BaseZ_Index + 5
	ScrollingFrame.BottomImage = ""
	ScrollingFrame.ScrollBarThickness = 0
	ScrollingFrame.TopImage = ""

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 10)

	UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		ScrollingFrame.CanvasSize = UDim2.fromOffset(UIListLayout.AbsoluteContentSize.X,UIListLayout.AbsoluteContentSize.Y)
	end);

	local ToggleUI = function(bool)
		local IsSame = ToggleDb:GetValue() == bool;

		EventOut:Fire(bool);
		ToggleDb:Fire(bool);

		local MUL = Window.AbsoluteSize.Y / 2;

		local MainPosition = UDim2.fromOffset(BaseParent.AbsolutePosition.X + 1,BaseParent.AbsolutePosition.Y + 80);
		local DropPosition = UDim2.fromOffset(MainPosition.X.Offset,MainPosition.Y.Offset + 25);

		if MainPosition.Y.Offset > MUL then -- go up
			MainPosition = UDim2.fromOffset(BaseParent.AbsolutePosition.X + 1,BaseParent.AbsolutePosition.Y + 55);
			DropPosition = UDim2.fromOffset(MainPosition.X.Offset,MainPosition.Y.Offset - 25);

			DropdownWindow.AnchorPoint = Vector2.new(0,1);
		else
			DropdownWindow.AnchorPoint = Vector2.zero;
		end;

		if bool then
			if not IsSame then
				DropdownWindow.Position = DropPosition;
			end;

			Compkiller:_Animation(DropdownWindow,TweenInfo.new(0.2),{
				BackgroundTransparency = 0,
				Position = MainPosition,
				Size = UDim2.new(0, BaseParent.AbsoluteSize.X - 1, 0, math.clamp(UIListLayout.AbsoluteContentSize.Y + 10,10 , 200))
			})

			Compkiller:_Animation(UIStroke,TweenInfo.new(0.2),{
				Transparency = 0
			})
		else
			Compkiller:_Animation(DropdownWindow,TweenInfo.new(0.2),{
				BackgroundTransparency = 1,
				Position = DropPosition,
				Size = UDim2.new(0, BaseParent.AbsoluteSize.X - 1, 0, math.clamp(UIListLayout.AbsoluteContentSize.Y / 1.5, 10 , 200))
			})

			Compkiller:_Animation(UIStroke,TweenInfo.new(0.2),{
				Transparency = 1
			})
		end;
	end;

	ToggleUI(false)

	local SpamUpdate,_Delay = false , tick();
	local __signals = {};
	local Default = nil;
	local Values = nil;
	local IsMulti = false;

	local DrawButton = function()
		local DropdownItem = Instance.new("Frame")
		local BlockText = Instance.new("TextLabel")
		local BlockLine = Instance.new("Frame")

		DropdownItem.Name = Compkiller:_RandomString()
		DropdownItem.BackgroundTransparency = 1.000
		DropdownItem.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DropdownItem.BorderSizePixel = 0
		DropdownItem.Size = UDim2.new(1, -1, 0, 20)
		DropdownItem.ZIndex = BaseZ_Index + 6

		BlockText.Name = Compkiller:_RandomString()
		BlockText.Parent = DropdownItem
		BlockText.AnchorPoint = Vector2.new(0, 0.5)
		BlockText.BackgroundTransparency = 1.000
		BlockText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BlockText.BorderSizePixel = 0
		BlockText.Position = UDim2.new(0, 5, 0.5, 0)
		BlockText.Size = UDim2.new(1, -10, 0, 25)
		BlockText.ZIndex = BaseZ_Index + 6
		BlockText.Font = Enum.Font.GothamMedium
		BlockText.Text = ""
		BlockText.TextColor3 = Compkiller.Colors.SwitchColor
		BlockText.TextSize = 13.000
		BlockText.TextTransparency = 0.500
		BlockText.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = BlockText,
			Property = 'TextColor3'
		});

		BlockLine.Name = Compkiller:_RandomString()
		BlockLine.Parent = DropdownItem
		BlockLine.AnchorPoint = Vector2.new(0.5, 1)
		BlockLine.BackgroundColor3 = Compkiller.Colors.LineColor
		BlockLine.BackgroundTransparency = 0.500
		BlockLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BlockLine.BorderSizePixel = 0
		BlockLine.Position = UDim2.new(0.5, 0, 1, 0)
		BlockLine.Size = UDim2.new(1, -6, 0, 1)
		BlockLine.ZIndex = BaseZ_Index + 7

		table.insert(Compkiller.Elements.LineColor,{
			Element = BlockLine,
			Property = "BackgroundColor3"
		});

		return {
			BlockText = BlockText,
			DropdownItem = DropdownItem,
			BlockLine = BlockLine,
		};
	end;

	local ClearDropdown = function()
		for i,v in next , ScrollingFrame:GetChildren() do
			if v:IsA('Frame') then
				v:Destroy();
			end;
		end;

		for i,v in next,  __signals do
			v:Disconnect();
		end;
	end;

	local IsDefault = function(v)
		return (typeof(Default) == 'table' and (Default[v] or table.find(Default,v))) or Default == v;
	end;

	local MatchDefault = function(v,DataFrame)
		return (typeof(DataFrame) == 'table' and (DataFrame[v] or table.find(DataFrame,v))) or DataFrame == v;
	end;

	local UpdateDropdown = function()
		local DataFrame;

		if IsMulti then
			DataFrame = {};
		end;

		for i,v in next , Values do
			local bth = DrawButton();

			bth.BlockText.Text = tostring(v);

			bth.DropdownItem.Parent = ScrollingFrame;

			bth.Value = v;

			table.insert(__signals , ToggleDb:Connect(function(bool)
				if bool then
					Compkiller:_Animation(bth.BlockText,TweenInfo.new(0.2),{
						TextTransparency = ((IsDefault(v) or MatchDefault(v,DataFrame)) and 0) or 0.5
					});

					Compkiller:_Animation(bth.BlockLine,TweenInfo.new(0.2),{
						BackgroundTransparency = 0
					});
				else
					Compkiller:_Animation(bth.BlockText,TweenInfo.new(0.2),{
						TextTransparency = 1
					});

					Compkiller:_Animation(bth.BlockLine,TweenInfo.new(0.2),{
						BackgroundTransparency = 1
					});
				end;
			end));

			if ToggleDb:GetValue() then
				Compkiller:_Animation(bth.BlockText,TweenInfo.new(0.2),{
					TextTransparency = ((IsDefault(v) or MatchDefault(v,DataFrame)) and 0) or 0.5
				});
			end;

			if IsDefault(v) and not IsMulti then
				DataFrame = bth;
			end;

			if IsMulti then
				if IsDefault(v) or MatchDefault(v,DataFrame) then
					DataFrame[v] = true;
				else
					DataFrame[v] = false;
				end;

				Compkiller:_Animation(bth.BlockText,TweenInfo.new(0.2),{
					TextTransparency = ((MatchDefault(v,DataFrame)) and 0) or 0.5
				});

				Compkiller:_Input(bth.DropdownItem,function()
					DataFrame[v] = not DataFrame[v];

					Compkiller:_Animation(bth.BlockText,TweenInfo.new(0.2),{
						TextTransparency = ((MatchDefault(v,DataFrame)) and 0) or 0.5
					});

					Callback(DataFrame)
				end);
			else
				Compkiller:_Input(bth.DropdownItem,function()
					if DataFrame then
						Compkiller:_Animation(DataFrame.BlockText,TweenInfo.new(0.2),{
							TextTransparency = ((IsDefault(v) or MatchDefault(v,DataFrame)) and 0) or 0.5
						});
					end;

					Default = v;

					DataFrame = bth;

					Compkiller:_Animation(bth.BlockText,TweenInfo.new(0.2),{
						TextTransparency = ((IsDefault(v) or MatchDefault(v,DataFrame)) and 0) or 0.5
					});

					Callback(DataFrame.Value)
				end);
			end;
		end;
	end;

	BaseParent.MouseButton1Click:Connect(function()
		if SpamUpdate then
			ClearDropdown();
			UpdateDropdown();
		end;

		ToggleUI(true);

		if not ToggleDb:GetValue() then
			ToggleUI(false);
		end
	end);

	UserInputService.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			if not Compkiller:_IsMouseOverFrame(DropdownWindow) then
				ToggleUI(false);
			end;
		end;
	end);

	local Args = {};

	function Args:SetDefault(v)
		Default = v;
	end;

	function Args:SetData(Def,Val,Multi,Vis)
		if Vis and ((tick() - _Delay) <= 0.5 or #Val > 10) then
			_Delay = tick();
			SpamUpdate = true;
		else
			SpamUpdate = false;	
		end;

		IsMulti = Multi;
		Default = Def;
		Values = Val;

		if Vis and not SpamUpdate then
			ClearDropdown();
			UpdateDropdown();
		end;
	end;

	function Args:Refersh()
		ClearDropdown();
		UpdateDropdown();
	end;

	Args.EventOut = EventOut;

	return Args;
end;

function Compkiller:_LoadElement(Parent: Frame , EnabledLine: boolean , Signal , DisableStackKeybind)
	local Zindex = Parent.ZIndex + 1;
	local Tween = TweenInfo.new(0.25,Enum.EasingStyle.Quint);

	local Args = {};

	function Args:AddToggle(Config : Toggle)
		Config = Compkiller.__CONFIG(Config,{
			Name = "Toggle",
			Default = false,
			Flag = nil,
			Risky = false,
			Callback = function() end;
		});

		local Block = Compkiller:_CreateBlock(Signal);

		Block:SetParent(Parent);

		Block:SetText(Config.Name);

		if Config.Risky then
			Block:SetTextColor(Compkiller.Colors.Risky);
		end;

		Block:SetLine(EnabledLine);

		Block:SetVisible(Signal:GetValue());

		local Toggle = Block:AddLink('Toggle' , Config.Default);

		Toggle.Input.MouseButton1Click:Connect(function()
			Config.Default = not Config.Default;

			Toggle.ChangeValue(Config.Default);

			Block:SetTransparency((Config.Default and 0.1) or 0.3);

			Config.Callback(Config.Default);
		end);

		local Args = {};

		Args.Flag = Config.Flag;

		function Args:SetValue(value)
			Config.Default = value;

			Toggle.ChangeValue(Config.Default);

			Block:SetTransparency((Config.Default and 0.1) or 0.3);

			Config.Callback(Config.Default);
		end;

		Args.Signal = Signal:Connect(function(bool)
			Block:SetVisible(bool);

		end);

		Args.Link = Compkiller:_LoadOption(Block);

		function Args:GetValue()
			return Config.Default;
		end;

		function Args:SetText(str : string)
			Block:SetText(str or Config.Name);
		end;

		function Args:GetText()
			return Block:GetText();
		end;

		if Config.Flag then
			Compkiller.Flags[Config.Flag] = Args;
		end;

		if not DisableStackKeybind then
			local AutoKeybind = Compkiller:_KeybindHandler(Block.Root , "Toggle" , Args , Signal , Zindex , Config);

			Args.AutoKeybind = AutoKeybind;
		end;

		return Args;
	end;

	function Args:AddKeybind(Config : Keybind)
		Config = Compkiller.__CONFIG(Config,{
			Name = "Keybind",
			Default = nil,
			Flag = nil,
			Callback = function() end;
			Blacklist = {}
		});

		local Block = Compkiller:_CreateBlock(Signal);

		Block:SetParent(Parent);

		Block:SetText(Config.Name);

		Block:SetLine(EnabledLine);

		Block:SetVisible(Signal:GetValue());

		local Keybind = Block:AddLink('Keybind' , Config.Default);

		local IsBinding = false;

		local IsBlacklist = function(v)
			return Config.Blacklist and (Config.Blacklist[v] or table.find(Config.Blacklist,v))
		end;

		Compkiller:_Input(Keybind.Root,function()
			if IsBinding then
				return;
			end;

			Keybind.SetValue("...");

			local Selected = nil;

			while not Selected do
				local Key = UserInputService.InputBegan:Wait();

				if Key.KeyCode ~= Enum.KeyCode.Unknown and not IsBlacklist(Key.KeyCode) and not IsBlacklist(Key.KeyCode.Name) then
					Selected = Key.KeyCode;
				else
					if Key.UserInputType == Enum.UserInputType.MouseButton1 and not IsBlacklist(Enum.UserInputType.MouseButton1) and not IsBlacklist("MouseLeft") then
						Selected = "MouseLeft";
					elseif Key.UserInputType == Enum.UserInputType.MouseButton2 and not IsBlacklist(Enum.UserInputType.MouseButton2) and not IsBlacklist("MouseRight") then
						Selected = "MouseRight";
					end;
				end;
			end;

			local KeyName = typeof(Selected) == "string" and Selected or Selected.Name;

			Config.Default = KeyName;

			Keybind.SetValue(Selected);

			IsBinding = false;

			Config.Callback(KeyName);
		end);

		local Args = {};

		Args.Flag = Config.Flag;

		function Args:SetText(str : string)
			Block:SetText(str or Config.Name);
		end;

		function Args:GetText()
			return Block:GetText();
		end;

		function Args:SetValue(value)
			Config.Default = value;

			Keybind.SetValue(Config.Default);

			Config.Callback(Config.Default);
		end;

		Args.Signal = Signal:Connect(function(bool)
			Block:SetVisible(bool);
		end);

		Args.Link = Compkiller:_LoadOption(Block);

		function Args:GetValue()
			return (typeof(Config.Default) == "string" and Config.Default) or Config.Default.Name;
		end;

		if Config.Flag then
			Compkiller.Flags[Config.Flag] = Args;
		end;

		return Args;
	end;

	function Args:AddColorPicker(Config: ColorPicker)
		Config = Compkiller.__CONFIG(Config,{
			Name = "ColorPicker",
			Default = Color3.fromRGB(255,255,255),
			Flag = nil,
			Transparency = 0,
			Callback = function() end;
		});

		local Block = Compkiller:_CreateBlock(Signal);

		Block:SetParent(Parent);

		Block:SetText(Config.Name);

		Block:SetLine(EnabledLine);

		Block:SetVisible(Signal:GetValue());

		local ColorPicker:Frame , ColorFrame: Frame = Block:AddLink('ColorPicker' , Config.Default);

		local Button = Compkiller:_Input(ColorPicker);

		local ColorPicker = Compkiller:_AddColorPickerPanel(Button,function(color,opc)
			Config.Default = color;
			Config.Transparency = opc;

			ColorFrame.BackgroundColor3 = color;
			ColorFrame.BackgroundTransparency = opc;

			Config.Callback(Config.Default , Config.Transparency);
		end);

		ColorPicker:SetColor(Config.Default,Config.Transparency);
		ColorPicker:Update()

		local Args = {};

		Args.Flag = Config.Flag;

		function Args:SetValue(value,opc)
			Config.Default = value;
			Config.Transparency = opc;

			ColorPicker:SetColor(value,opc);
			ColorPicker:Update();

			Config.Callback(value,opc);
		end;

		function Args:SetText(str : string)
			Block:SetText(str or Config.Name);
		end;

		function Args:GetText()
			return Block:GetText();
		end;

		Args.Signal = Signal:Connect(function(bool)
			Block:SetVisible(bool);
		end);

		Args.Link = Compkiller:_LoadOption(Block);

		function Args:GetValue()
			return {
				ColorPicker = {
					Color = Config.Default,
					Transparency = Config.Transparency
				}
			};
		end;

		if Config.Flag then
			Compkiller.Flags[Config.Flag] = Args;
		end;

		return Args;
	end;

	function Args:AddButton(Config: Button)
		Config = Compkiller.__CONFIG(Config , {
			Name = 'Button',
			Callback = function() end
		});

		local Button = Instance.new("Frame")
		local BlockLine = Instance.new("Frame")
		local Frame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local TextLabel = Instance.new("TextLabel")

		if Compkiller:_IsMobile() then
			Compkiller:_AddDragBlacklist(Button);
		end;

		Button.Name = Compkiller:_RandomString()
		Button.Parent = Parent
		Button.BackgroundTransparency = 1.000
		Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Button.BorderSizePixel = 0
		Button.Size = UDim2.new(1, -1, 0, 30)
		Button.ZIndex = Zindex + 5

		BlockLine.Name = Compkiller:_RandomString()
		BlockLine.Parent = Button
		BlockLine.AnchorPoint = Vector2.new(0.5, 1)
		BlockLine.BackgroundColor3 = Compkiller.Colors.LineColor
		BlockLine.BackgroundTransparency = 0.500
		BlockLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BlockLine.BorderSizePixel = 0
		BlockLine.Position = UDim2.new(0.5, 0, 1, 0)
		BlockLine.Size = UDim2.new(1, -26, 0, 1)
		BlockLine.ZIndex = Zindex + 6

		table.insert(Compkiller.Elements.LineColor,{
			Element = BlockLine,
			Property = "BackgroundColor3"
		});

		Frame.Parent = Button
		Frame.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame.BackgroundColor3 = Compkiller.Colors.Highlight
		Frame.BackgroundTransparency = 0.100
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
		Frame.Size = UDim2.new(1, -15, 1, -5)
		Frame.ZIndex = Zindex + 7;

		table.insert(Compkiller.Elements.Highlight,{
			Element = Frame,
			Property = "BackgroundColor3"
		});

		UIStroke.Color = Compkiller.Colors.StrokeColor
		UIStroke.Parent = Frame

		table.insert(Compkiller.Elements.StrokeColor,{
			Element = UIStroke,
			Property = "Color"
		});

		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = Frame

		TextLabel.Parent = Frame
		TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextLabel.Size = UDim2.new(1, 0, 1, 0)
		TextLabel.ZIndex = Zindex + 8
		TextLabel.Font = Enum.Font.GothamMedium
		TextLabel.Text = Config.Name;
		TextLabel.TextColor3 = Compkiller.Colors.SwitchColor
		TextLabel.TextSize = 12.000
		TextLabel.TextStrokeTransparency = 0.900

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = TextLabel,
			Property = 'TextColor3'
		});

		Compkiller:_Hover(Frame,function()
			if Signal:GetValue() then
				Compkiller:_Animation(Frame,TweenInfo.new(0.2),{
					BackgroundTransparency = 0
				})
			end;
		end,function()
			if Signal:GetValue() then
				Compkiller:_Animation(Frame,TweenInfo.new(0.2),{
					BackgroundTransparency = 0.1
				})
			end;
		end);

		Compkiller:_Input(Frame,function()
			Config.Callback();
		end);

		local Args = {};

		Args.Signal = Signal:Connect(function(bool)
			if bool then
				Compkiller:_Animation(BlockLine, TweenInfo.new(0.35),{
					BackgroundTransparency = 0.500
				});

				Compkiller:_Animation(Frame, TweenInfo.new(0.35),{
					BackgroundTransparency = 0.1
				});

				Compkiller:_Animation(UIStroke, TweenInfo.new(0.35),{
					Transparency = 0
				});

				Compkiller:_Animation(TextLabel, TweenInfo.new(0.35),{
					TextStrokeTransparency = 0.900,
					TextTransparency = 0
				});

			else
				Compkiller:_Animation(BlockLine, TweenInfo.new(0.35),{
					BackgroundTransparency = 1
				});

				Compkiller:_Animation(Frame, TweenInfo.new(0.35),{
					BackgroundTransparency = 1
				});

				Compkiller:_Animation(UIStroke, TweenInfo.new(0.35),{
					Transparency = 1
				});

				Compkiller:_Animation(TextLabel, TweenInfo.new(0.35),{
					TextStrokeTransparency = 1,
					TextTransparency = 1
				});
			end;
		end);

		function Args:SetText(t)
			Config.Name = t;
			TextLabel.Text = Config.Name;
		end;

		function Args:GetText()
			return TextLabel.Text;
		end;

		return Args;
	end;

	function Args:AddSlider(Config: Slider)
		Config = Compkiller.__CONFIG(Config , {
			Name = 'Slider',
			Default = 50,
			Min = 0,
			Max = 100,
			Type = "",
			Round = 0,
			Callback = function() end
		});

		local Slider = Instance.new("Frame")
		local BlockText = Instance.new("TextLabel")
		local BlockLine = Instance.new("Frame")
		local SliderBar = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local SliderInput = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local Frame = Instance.new("Frame")
		local UICorner_3 = Instance.new("UICorner")
		local UIScale = Instance.new("UIScale")
		local ValueText = Instance.new("TextLabel")

		Compkiller:_AddDragBlacklist(Slider);

		Slider.Name = Compkiller:_RandomString()
		Slider.Parent = Parent
		Slider.BackgroundTransparency = 1.000
		Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Slider.BorderSizePixel = 0
		Slider.Size = UDim2.new(1, -1, 0, 45)
		Slider.ZIndex = Zindex + 1

		BlockText.Name = Compkiller:_RandomString()
		BlockText.Parent = Slider
		BlockText.BackgroundTransparency = 1.000
		BlockText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BlockText.BorderSizePixel = 0
		BlockText.Position = UDim2.new(0, 12, 0, 1)
		BlockText.Size = UDim2.new(1, -20, 0, 25)
		BlockText.ZIndex = Zindex + 2
		BlockText.Font = Enum.Font.GothamMedium
		BlockText.Text = Config.Name
		BlockText.TextColor3 = Compkiller.Colors.SwitchColor
		BlockText.TextSize = 14.000
		BlockText.TextTransparency = 0.100
		BlockText.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = BlockText,
			Property = 'TextColor3'
		});

		BlockLine.Name = Compkiller:_RandomString()
		BlockLine.Parent = Slider
		BlockLine.AnchorPoint = Vector2.new(0.5, 1)
		BlockLine.BackgroundColor3 = Compkiller.Colors.LineColor
		BlockLine.BackgroundTransparency = 0.500
		BlockLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BlockLine.BorderSizePixel = 0
		BlockLine.Position = UDim2.new(0.5, 0, 1, 0)
		BlockLine.Size = UDim2.new(1, -26, 0, 1)
		BlockLine.ZIndex = Zindex + 2
		BlockLine.Visible = EnabledLine or false;

		table.insert(Compkiller.Elements.LineColor,{
			Element = BlockLine,
			Property = "BackgroundColor3"
		});

		SliderBar.Name = Compkiller:_RandomString()
		SliderBar.Parent = Slider
		SliderBar.AnchorPoint = Vector2.new(0.5, 1)
		SliderBar.BackgroundColor3 = Compkiller.Colors.DropColor
		SliderBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SliderBar.BorderSizePixel = 0
		SliderBar.ClipsDescendants = true
		SliderBar.Position = UDim2.new(0.5, 0, 1, -9)
		SliderBar.Size = UDim2.new(1, -25, 0, 10)
		SliderBar.ZIndex = Zindex + 3

		table.insert(Compkiller.Elements.DropColor , {
			Element = SliderBar,
			Property = "BackgroundColor3"
		})

		UIStroke.Color = Compkiller.Colors.StrokeColor
		UIStroke.Parent = SliderBar

		table.insert(Compkiller.Elements.StrokeColor,{
			Element = UIStroke,
			Property = "Color"
		});

		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = SliderBar

		SliderInput.Name = Compkiller:_RandomString()
		SliderInput.Parent = SliderBar
		SliderInput.AnchorPoint = Vector2.new(0, 0.5)
		SliderInput.BackgroundColor3 = Compkiller.Colors.Highlight
		SliderInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SliderInput.BorderSizePixel = 0
		SliderInput.Position = UDim2.new(0, 0, 0.5, 0)
		SliderInput.Size = UDim2.new(math.max((Config.Default - Config.Min) / (Config.Max - Config.Min) , 0.045), 0, 1, 0)
		SliderInput.ZIndex = Zindex + 4

		table.insert(Compkiller.Elements.Highlight,{
			Element = SliderInput,
			Property = "BackgroundColor3"
		});

		UICorner_2.CornerRadius = UDim.new(0, 6)
		UICorner_2.Parent = SliderInput

		Frame.Parent = SliderInput
		Frame.AnchorPoint = Vector2.new(1, 0.5)
		Frame.BackgroundColor3 = Compkiller.Colors.SwitchColor
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Position = UDim2.new(1, 5, 0.5, 0)
		Frame.Rotation = 45.000
		Frame.Size = UDim2.new(1, 0, 1, 0)
		Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY
		Frame.ZIndex = Zindex + 6

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = Frame,
			Property = 'BackgroundColor3'
		});

		UICorner_3.CornerRadius = UDim.new(3, 0)
		UICorner_3.Parent = Frame

		UIScale.Parent = Frame
		UIScale.Scale = 1.300

		ValueText.Name = Compkiller:_RandomString()
		ValueText.Parent = Slider
		ValueText.BackgroundTransparency = 1.000
		ValueText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueText.BorderSizePixel = 0
		ValueText.Position = UDim2.new(0, 12, 0, 1)
		ValueText.Size = UDim2.new(1, -20, 0, 25)
		ValueText.ZIndex = Zindex + 4
		ValueText.Font = Enum.Font.GothamMedium
		ValueText.Text = tostring(Config.Default)..tostring(Config.Type)
		ValueText.TextColor3 = Compkiller.Colors.SwitchColor
		ValueText.TextSize = 12.000
		ValueText.TextTransparency = 0.750
		ValueText.TextXAlignment = Enum.TextXAlignment.Right

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = ValueText,
			Property = 'TextColor3'
		});

		Compkiller:_Hover(SliderBar,function()
			if Signal:GetValue() then
				Compkiller:_Animation(ValueText,TweenInfo.new(0.2),{
					TextTransparency = 0.2
				})
			end;
		end,function()
			if Signal:GetValue() then
				Compkiller:_Animation(ValueText,TweenInfo.new(0.2),{
					TextTransparency = 0.750
				})
			end;
		end)	

		local IsHold = false;

		local Update = function(Input)
			local SizeScale = math.clamp((((Input.Position.X) - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X), 0, 1);

			local Main = ((Config.Max - Config.Min) * SizeScale) + Config.Min;

			local Value = Compkiller:_Rounding(Main,Config.Round);

			local PositionX = UDim2.fromScale(SizeScale, 1);

			local Size = (Value - Config.Min) / (Config.Max - Config.Min);

			TweenService:Create(SliderInput , TweenInfo.new(0.2),{
				Size = UDim2.new(math.clamp(Size,0.045,1), 0, 1, 0)
			}):Play();

			Config.Default = Value;

			ValueText.Text = tostring(Config.Default)..tostring(Config.Type)

			Config.Callback(Value)
		end;

		do
			SliderBar.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					IsHold = true
					Update(Input)
				end
			end)

			SliderBar.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if UserInputService.TouchEnabled then
						if not Compkiller:_IsMouseOverFrame(SliderBar) then
							IsHold = false
						end;
					else
						IsHold = false
					end;
				end
			end)

			UserInputService.InputChanged:Connect(function(Input)
				if IsHold then
					if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)  then
						if UserInputService.TouchEnabled then
							if not Compkiller:_IsMouseOverFrame(SliderBar) then
								IsHold = false
							else
								Update(Input)
							end;
						else
							Update(Input)
						end;
					end;
				end;
			end);
		end;

		local Args = {};

		Args.Flag = Config.Flag;

		function Args:SetValue(Value)
			Config.Default = Value;

			ValueText.Text = tostring(Config.Default)..tostring(Config.Type)

			Compkiller:_Animation(SliderInput, TweenInfo.new(0.35),{
				Size = UDim2.new(math.max((Config.Default - Config.Min) / (Config.Max - Config.Min) , 0.045), 0, 1, 0)
			});

			Config.Callback(Value);
		end;

		function Args:SetText(str : string)
			BlockText.Text = str or Config.Name
		end;

		function Args:GetText()
			return BlockText.Text;
		end;

		Args.Signal = Signal:Connect(function(bool)
			if bool then
				Compkiller:_Animation(SliderInput, TweenInfo.new(0.35),{
					Size = UDim2.new(math.max((Config.Default - Config.Min) / (Config.Max - Config.Min) , 0.045), 0, 1, 0)
				});

				Compkiller:_Animation(ValueText,Tween,{
					TextTransparency = 0.750
				})

				Compkiller:_Animation(Frame,Tween,{
					BackgroundTransparency = 0
				})

				Compkiller:_Animation(SliderInput,Tween,{
					BackgroundTransparency = 0
				})

				Compkiller:_Animation(UIStroke,Tween,{
					Transparency = 0
				})

				Compkiller:_Animation(SliderBar,Tween,{
					BackgroundTransparency = 0
				})

				Compkiller:_Animation(BlockLine,Tween,{
					BackgroundTransparency = 0.5
				})

				Compkiller:_Animation(BlockText,Tween,{
					TextTransparency = 0.1
				})
			else
				Compkiller:_Animation(SliderInput, TweenInfo.new(0.35),{
					Size = UDim2.new(0, 0, 1, 0)
				});

				Compkiller:_Animation(ValueText,Tween,{
					TextTransparency = 1
				})

				Compkiller:_Animation(Frame,Tween,{
					BackgroundTransparency = 1
				})

				Compkiller:_Animation(SliderInput,Tween,{
					BackgroundTransparency = 1
				})

				Compkiller:_Animation(UIStroke,Tween,{
					Transparency = 1
				})

				Compkiller:_Animation(SliderBar,Tween,{
					BackgroundTransparency = 1
				})

				Compkiller:_Animation(BlockLine,Tween,{
					BackgroundTransparency = 1
				})

				Compkiller:_Animation(BlockText,Tween,{
					TextTransparency = 1
				})
			end;
		end);

		function Args:GetValue()
			return Config.Default;
		end;

		if Config.Flag then
			Compkiller.Flags[Config.Flag] = Args;
		end;

		if not DisableStackKeybind then
			local AutoKeybind = Compkiller:_KeybindHandler(Slider , "Number" , Args , Signal , Zindex , Config);

			Args.AutoKeybind = AutoKeybind;
		end;

		return Args;
	end;

	function Args:AddParagraph(Config: Paragraph) -- request by Neptune
		Config = Compkiller.__CONFIG(Config, {
			Title = "Paragraph",
			Content = "",
		});

		local Paragraph = Instance.new("Frame")
		local BlockText = Instance.new("TextLabel")
		local BlockLine = Instance.new("Frame")
		local DescriptionText = Instance.new("TextLabel")

		if Compkiller:_IsMobile() then
			Compkiller:_AddDragBlacklist(Paragraph);
		end;

		Paragraph.Name = Compkiller:_RandomString()
		Paragraph.Parent = Parent
		Paragraph.BackgroundTransparency = 1.000
		Paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Paragraph.BorderSizePixel = 0
		Paragraph.Size = UDim2.new(1, -1, 0, 40)
		Paragraph.ZIndex = Zindex + 2
		Paragraph.ClipsDescendants = true

		BlockText.Name = Compkiller:_RandomString()
		BlockText.Parent = Paragraph
		BlockText.AnchorPoint = Vector2.new(0, 0.5)
		BlockText.BackgroundTransparency = 1.000
		BlockText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BlockText.BorderSizePixel = 0
		BlockText.Position = UDim2.new(0, 12, 0, 12)
		BlockText.Size = UDim2.new(1, -20, 0, 25)
		BlockText.ZIndex = Zindex + 3
		BlockText.Font = Enum.Font.GothamMedium
		BlockText.Text = Config.Title
		BlockText.TextColor3 = Compkiller.Colors.SwitchColor
		BlockText.TextSize = 14.000
		BlockText.TextTransparency = 0.300
		BlockText.TextXAlignment = Enum.TextXAlignment.Left
		BlockText.RichText = true

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = BlockText,
			Property = 'TextColor3'
		});

		BlockLine.Name = Compkiller:_RandomString()
		BlockLine.Parent = Paragraph
		BlockLine.AnchorPoint = Vector2.new(0.5, 1)
		BlockLine.BackgroundColor3 = Compkiller.Colors.LineColor
		BlockLine.BackgroundTransparency = 0.500
		BlockLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BlockLine.BorderSizePixel = 0
		BlockLine.Position = UDim2.new(0.5, 0, 1, 0)
		BlockLine.Size = UDim2.new(1, -26, 0, 1)
		BlockLine.ZIndex = Zindex + 4

		table.insert(Compkiller.Elements.LineColor,{
			Element = BlockLine,
			Property = "BackgroundColor3"
		});

		DescriptionText.RichText = true
		DescriptionText.Name = Compkiller:_RandomString()
		DescriptionText.Parent = Paragraph
		DescriptionText.BackgroundTransparency = 1.000
		DescriptionText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DescriptionText.BorderSizePixel = 0
		DescriptionText.Position = UDim2.new(0, 12, 0, 22)
		DescriptionText.Size = UDim2.new(1, -20, 1, -25)
		DescriptionText.ZIndex = Zindex + 5
		DescriptionText.Font = Enum.Font.GothamMedium
		DescriptionText.Text = Config.Content
		DescriptionText.TextColor3 = Compkiller.Colors.SwitchColor
		DescriptionText.TextSize = 13.000
		DescriptionText.TextTransparency = 0.500
		DescriptionText.TextXAlignment = Enum.TextXAlignment.Left
		DescriptionText.TextYAlignment = Enum.TextYAlignment.Top

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = DescriptionText,
			Property = 'TextColor3'
		});

		local Base = 15;

		local UpdateScale = function()

			if not DescriptionText.Text:byte() then
				local TitleScale = TextService:GetTextSize(BlockText.Text,BlockText.TextSize,BlockText.Font,Vector2.new(math.huge,math.huge));

				Compkiller:_Animation(Paragraph,TweenInfo.new(0.15),{
					Size = UDim2.new(1, -1, 0, TitleScale.Y + Base)
				});
			else
				local TitleScale = TextService:GetTextSize(BlockText.Text,BlockText.TextSize,BlockText.Font,Vector2.new(math.huge,math.huge));
				local ContentScale = TextService:GetTextSize(DescriptionText.Text,DescriptionText.TextSize,DescriptionText.Font,Vector2.new(math.huge,math.huge));

				Compkiller:_Animation(Paragraph,TweenInfo.new(0.15),{
					Size = UDim2.new(1, -1, 0, (TitleScale.Y + ContentScale.Y) + Base)
				});
			end;
		end;

		UpdateScale();

		local Args = {};

		function Args:SetTitle(title)
			BlockText.Text = title;
			UpdateScale();
		end;

		function Args:SetContent(content)
			DescriptionText.Text = content;
			UpdateScale();
		end;

		Args.Signal = Signal:Connect(function(bool)
			if bool then
				Compkiller:_Animation(BlockText,TweenInfo.new(0.2),{
					TextTransparency = 0.300
				});

				Compkiller:_Animation(DescriptionText,TweenInfo.new(0.2),{
					TextTransparency = 0.500
				});

				Compkiller:_Animation(BlockLine,TweenInfo.new(0.2),{
					BackgroundTransparency = 0.500
				});
			else
				Compkiller:_Animation(BlockText,TweenInfo.new(0.2),{
					TextTransparency = 1
				});

				Compkiller:_Animation(DescriptionText,TweenInfo.new(0.2),{
					TextTransparency = 1
				});

				Compkiller:_Animation(BlockLine,TweenInfo.new(0.2),{
					BackgroundTransparency = 1
				});
			end;
		end);

		return Args;
	end;

	function Args:AddTextBox(Config: TextBoxConfig)
		Config = Compkiller.__CONFIG(Config , {
			Name = "TextBox",
			Default = "",
			Placeholder = "Placeholder",
			Numberic = false,
			Callback = function() end,
		});

		local TextBox = Instance.new("Frame")
		local BlockText = Instance.new("TextLabel")
		local LinkValues = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local TextBox_2 = Instance.new("TextBox")
		local BlockLine = Instance.new("Frame")

		if Compkiller:_IsMobile() then
			Compkiller:_AddDragBlacklist(TextBox);
		end;

		TextBox.Name = Compkiller:_RandomString()
		TextBox.Parent = Parent
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Size = UDim2.new(1, -1, 0, 30)
		TextBox.ZIndex = Zindex + 1

		BlockText.Name = Compkiller:_RandomString()
		BlockText.Parent = TextBox
		BlockText.AnchorPoint = Vector2.new(0, 0.5)
		BlockText.BackgroundTransparency = 1.000
		BlockText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BlockText.BorderSizePixel = 0
		BlockText.Position = UDim2.new(0, 12, 0.5, 0)
		BlockText.Size = UDim2.new(1, -20, 0, 25)
		BlockText.ZIndex = Zindex + 2
		BlockText.Font = Enum.Font.GothamMedium
		BlockText.Text = Config.Name
		BlockText.TextColor3 = Compkiller.Colors.SwitchColor
		BlockText.TextSize = 14.000
		BlockText.TextTransparency = 0.300
		BlockText.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(Compkiller.Elements.SwitchColor,{
			Element = BlockText,
			Property = "TextColor3"
		})

		LinkValues.Name = Compkiller:_RandomString()
		LinkValues.Parent = TextBox
		LinkValues.AnchorPoint = Vector2.new(1, 0.540000021)
		LinkValues.BackgroundColor3 = Compkiller.Colors.DropColor
		LinkValues.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LinkValues.BorderSizePixel = 0
		LinkValues.Position = UDim2.new(1, -12, 0.5, 0)
		LinkValues.Size = UDim2.new(0, 95, 0, 16)
		LinkValues.ZIndex = Zindex + 3

		table.insert(Compkiller.Elements.DropColor,{
			Element = LinkValues,
			Property = "BackgroundColor3"
		})

		UIStroke.Color = Compkiller.Colors.StrokeColor
		UIStroke.Parent = LinkValues

		table.insert(Compkiller.Elements.StrokeColor,{
			Element = UIStroke,
			Property = "Color"
		})

		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = LinkValues

		TextBox_2.Parent = LinkValues
		TextBox_2.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBox_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox_2.BackgroundTransparency = 1.000
		TextBox_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox_2.BorderSizePixel = 0
		TextBox_2.ClipsDescendants = true
		TextBox_2.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextBox_2.Size = UDim2.new(1, -5, 1, 0)
		TextBox_2.ZIndex = Zindex + 5
		TextBox_2.ClearTextOnFocus = false
		TextBox_2.Font = Enum.Font.GothamMedium
		TextBox_2.PlaceholderText = Config.Placeholder
		TextBox_2.Text = Config.Default
		TextBox_2.TextColor3 = Compkiller.Colors.SwitchColor
		TextBox_2.TextSize = 11.000

		table.insert(Compkiller.Elements.SwitchColor,{
			Element = TextBox_2,
			Property = "TextColor3"
		})

		BlockLine.Name = Compkiller:_RandomString()
		BlockLine.Parent = TextBox
		BlockLine.AnchorPoint = Vector2.new(0.5, 1)
		BlockLine.BackgroundColor3 = Compkiller.Colors.LineColor
		BlockLine.BackgroundTransparency = 0.500
		BlockLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BlockLine.BorderSizePixel = 0
		BlockLine.Position = UDim2.new(0.5, 0, 1, 0)
		BlockLine.Size = UDim2.new(1, -26, 0, 1)
		BlockLine.ZIndex = Zindex + 3;

		table.insert(Compkiller.Elements.LineColor,{
			Element = BlockLine,
			Property = "BackgroundColor3"
		})

		local Update = function()
			local scale = TextService:GetTextSize(TextBox_2.Text,TextBox_2.TextSize,TextBox_2.Font,Vector2.new(math.huge,math.huge));
			local Base = TextService:GetTextSize(TextBox_2.PlaceholderText,TextBox_2.TextSize,TextBox_2.Font,Vector2.new(math.huge,math.huge));

			local MainScale = ((scale.X > Base.X) and scale.X) or Base.X;

			local xp = pcall(function()
				Compkiller:_Animation(LinkValues,TweenInfo.new(0.25),{
					Size = UDim2.fromOffset(math.clamp(MainScale + 7 , Base.X , TextBox.AbsoluteSize.X / 2) , 16)
				})
			end);

			if not xp then
				Compkiller:_Animation(LinkValues,TweenInfo.new(0.25),{
					Size = UDim2.fromOffset(MainScale + 7 , 16)
				})
			end;
		end;

		local parse = function(text)
			if not text then
				return "";	
			end;

			if Config.Numeric then
				local out = string.gsub(tostring(text), '[^0-9.]', '')

				if tonumber(out) then
					return tonumber(out);
				end;

				return nil;
			end;

			return text;
		end;

		Update();

		TextBox_2:GetPropertyChangedSignal('Text'):Connect(Update);

		TextBox_2:GetPropertyChangedSignal('Text'):Connect(function()
			local value = parse(TextBox_2.Text);

			if value then

				TextBox_2.Text = tostring(value);

				task.spawn(Config.Callback,value);

				Config.Default = value;
			else
				TextBox_2.Text = string.gsub(TextBox_2.Text, '[^0-9.]', '');

				Config.Default = TextBox_2.Text;
			end;
		end);

		local Args = {};

		Args.Flag = Config.Flag;

		function Args:SetText(str : string)
			BlockText.Text = str or Config.Name
		end;

		function Args:GetText()
			return BlockText.Text;
		end;

		function Args:SetValue(Value)
			Config.Default = Value;

			TextBox_2.Text = tostring(Config.Default);

			Config.Callback(Value);
		end;

		Args.Signal = Signal:Connect(function(bool)
			if bool then
				Compkiller:_Animation(BlockText,TweenInfo.new(0.2),{
					TextTransparency = 0.3
				});

				Compkiller:_Animation(BlockLine,TweenInfo.new(0.2),{
					BackgroundTransparency = 0.5
				});

				Compkiller:_Animation(UIStroke,TweenInfo.new(0.2),{
					Transparency = 0
				});

				Compkiller:_Animation(LinkValues,TweenInfo.new(0.2),{
					BackgroundTransparency = 0
				});

			else
				Compkiller:_Animation(BlockText,TweenInfo.new(0.2),{
					TextTransparency = 1
				});

				Compkiller:_Animation(BlockLine,TweenInfo.new(0.2),{
					BackgroundTransparency = 1
				});

				Compkiller:_Animation(UIStroke,TweenInfo.new(0.2),{
					Transparency = 1
				});

				Compkiller:_Animation(LinkValues,TweenInfo.new(0.2),{
					BackgroundTransparency = 1
				});

			end;
		end);

		function Args:GetValue()
			return Config.Default;
		end;

		if Config.Flag then
			Compkiller.Flags[Config.Flag] = Args;
		end;

		return Args;
	end;

	function Args:AddDropdown(Config : Dropdown)
		Config = Compkiller.__CONFIG(Config,{
			Name = "Dropdown",
			Default = nil,
			Values = {"Item 1","Item 2","Item 3"},
			Multi = false,
			Callback = function() end;
		});

		local DaTabarser = function(value)
			if not value then return ''; end;

			local Out;

			if typeof(value) == 'table' then
				if #value > 0 then
					local x = {};

					for i,v in next , value do
						table.insert(x , tostring(v))
					end;

					Out = table.concat(x,' , ');
				else
					local x = {};

					for i,v in next , value do
						if v == true then
							table.insert(x , tostring(i));
						end			
					end;

					Out = table.concat(x,' , ');
				end;
			else
				Out = tostring(value);
			end;

			return Out;
		end;

		local Dropdown = Instance.new("Frame")
		local BlockText = Instance.new("TextLabel")
		local BlockLine = Instance.new("Frame")
		local LinkValues = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local ValueItems = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local ValueText = Instance.new("TextLabel")
		local MainButton = Instance.new("ImageButton")

		Dropdown.Name = Compkiller:_RandomString()
		Dropdown.Parent = Parent
		Dropdown.BackgroundTransparency = 1.000
		Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown.BorderSizePixel = 0
		Dropdown.Size = UDim2.new(1, -1, 0, 55)
		Dropdown.ZIndex = Zindex + 2

		BlockText.Name = Compkiller:_RandomString()
		BlockText.Parent = Dropdown
		BlockText.BackgroundTransparency = 1.000
		BlockText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BlockText.BorderSizePixel = 0
		BlockText.Position = UDim2.new(0, 12, 0, 1)
		BlockText.Size = UDim2.new(1, -20, 0, 25)
		BlockText.ZIndex = Zindex + 3
		BlockText.Font = Enum.Font.GothamMedium
		BlockText.Text = Config.Name
		BlockText.TextColor3 = Compkiller.Colors.SwitchColor
		BlockText.TextSize = 14.000
		BlockText.TextTransparency = 0.100
		BlockText.TextXAlignment = Enum.TextXAlignment.Left

		if not BlockText.Text:byte() then
			Dropdown.Size = UDim2.new(1, -1, 0, 25)
		end;

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = BlockText,
			Property = 'TextColor3'
		});

		BlockLine.Name = Compkiller:_RandomString()
		BlockLine.Parent = Dropdown
		BlockLine.AnchorPoint = Vector2.new(0.5, 1)
		BlockLine.BackgroundColor3 = Compkiller.Colors.LineColor
		BlockLine.BackgroundTransparency = 0.500
		BlockLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BlockLine.BorderSizePixel = 0
		BlockLine.Position = UDim2.new(0.5, 0, 1, 0)
		BlockLine.Size = UDim2.new(1, -26, 0, 1)
		BlockLine.ZIndex = Zindex + 3

		table.insert(Compkiller.Elements.LineColor,{
			Element = BlockLine,
			Property = "BackgroundColor3"
		});

		LinkValues.Name = Compkiller:_RandomString()
		LinkValues.Parent = Dropdown
		LinkValues.AnchorPoint = Vector2.new(1, 0.540000021)
		LinkValues.BackgroundTransparency = 1.000
		LinkValues.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LinkValues.BorderSizePixel = 0
		LinkValues.Position = UDim2.new(1, -12, 0, 15)
		LinkValues.Size = UDim2.new(1, 0, 0, 18)
		LinkValues.ZIndex = Zindex + 3

		UIListLayout.Parent = LinkValues
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0, 8)

		ValueItems.Name = Compkiller:_RandomString()
		ValueItems.Parent = Dropdown
		ValueItems.AnchorPoint = Vector2.new(0.5, 1)
		ValueItems.BackgroundColor3 = Compkiller.Colors.DropColor
		ValueItems.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueItems.BorderSizePixel = 0
		ValueItems.ClipsDescendants = true
		ValueItems.Position = UDim2.new(0.5, 0, 1, -7)
		ValueItems.Size = UDim2.new(1, -25, 0, 18)
		ValueItems.ZIndex = Zindex + 5

		table.insert(Compkiller.Elements.DropColor , {
			Element = ValueItems,
			Property = "BackgroundColor3"
		})

		UIStroke.Color = Compkiller.Colors.StrokeColor
		UIStroke.Parent = ValueItems

		table.insert(Compkiller.Elements.StrokeColor,{
			Element = UIStroke,
			Property = "Color"
		});

		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = ValueItems

		ValueText.Name = Compkiller:_RandomString()
		ValueText.Parent = ValueItems
		ValueText.AnchorPoint = Vector2.new(0.5, 0.5)
		ValueText.BackgroundTransparency = 1.000
		ValueText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueText.BorderSizePixel = 0
		ValueText.Position = UDim2.new(0.5, 0, 0.5, 0)
		ValueText.Size = UDim2.new(1, -10, 0, 15)
		ValueText.ZIndex = Zindex + 8
		ValueText.Font = Enum.Font.Gotham
		ValueText.Text = DaTabarser(Config.Default)
		ValueText.TextColor3 = Compkiller.Colors.SwitchColor
		ValueText.TextSize = 11.000
		ValueText.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = ValueText,
			Property = 'TextColor3'
		});

		MainButton.Name = Compkiller:_RandomString()
		MainButton.Parent = ValueItems
		MainButton.AnchorPoint = Vector2.new(1, 0.5)
		MainButton.BackgroundTransparency = 1.000
		MainButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MainButton.BorderSizePixel = 0
		MainButton.Position = UDim2.new(1, -5, 0.5, 0)
		MainButton.Size = UDim2.new(0, 13, 0, 13)
		MainButton.ZIndex = Zindex + 5
		MainButton.Image = Compkiller:CacheImage(GetAsset("109535175596957"))

		Compkiller:_Hover(ValueItems,function()
			Compkiller:_Animation(ValueItems,TweenInfo.new(0.3),{
				BackgroundColor3 = Compkiller.Colors.MouseEnter
			});
		end,function()
			Compkiller:_Animation(ValueItems,TweenInfo.new(0.3),{
				BackgroundColor3 = Compkiller.Colors.DropColor
			});
		end);

		local repi;
		local Button = Compkiller:_Input(ValueItems);

		repi = Compkiller:_LoadDropdown(Button,function(value)
			Config.Default = value;

			repi:SetData(Config.Default,Config.Values,Config.Multi,false);
			repi:SetDefault(Config.Default);

			ValueText.Text = DaTabarser(Config.Default);

			Config.Callback(Config.Default);
		end);

		repi.EventOut:Connect(function(v)
			if v then
				Compkiller:_Animation(MainButton,TweenInfo.new(0.2),{
					Rotation = -180
				})
			else
				Compkiller:_Animation(MainButton,TweenInfo.new(0.2),{
					Rotation = 0
				})
			end;
		end)

		repi:SetData(Config.Default,Config.Values,Config.Multi,false);
		repi:Refersh();

		local Args = {};

		Args.Flag = Config.Flag;

		function Args:SetValue(Value)
			Config.Default = Value;

			ValueText.Text = DaTabarser(Config.Default);

			repi:SetData(Config.Default,Config.Values,Config.Multi,true);

			Config.Callback(Value);
		end;

		function Args:SetText(str : string)
			BlockText.Text = str or Config.Name
		end;


		function Args:GetText()
			return BlockText.Text;
		end;

		function Args:SetValues(v)
			Config.Values = v;

			repi:SetData(Config.Default,Config.Values,Config.Multi,true);
		end;

		Args.Signal = Signal:Connect(function(bool)
			if bool then
				Compkiller:_Animation(BlockText,TweenInfo.new(0.2),{
					TextTransparency = 0.100
				});

				Compkiller:_Animation(BlockLine,TweenInfo.new(0.2),{
					BackgroundTransparency = 0.100
				});

				Compkiller:_Animation(ValueItems,TweenInfo.new(0.2),{
					BackgroundTransparency = 0
				});

				Compkiller:_Animation(UIStroke,TweenInfo.new(0.2),{
					Transparency = 0
				});

				Compkiller:_Animation(ValueText,TweenInfo.new(0.32),{
					TextTransparency = 0
				});

				Compkiller:_Animation(MainButton,TweenInfo.new(0.2),{
					ImageTransparency = 0
				});
			else
				Compkiller:_Animation(BlockText,TweenInfo.new(0.2),{
					TextTransparency = 1
				});

				Compkiller:_Animation(BlockLine,TweenInfo.new(0.2),{
					BackgroundTransparency = 1 
				});

				Compkiller:_Animation(ValueItems,TweenInfo.new(0.2),{
					BackgroundTransparency = 1
				});

				Compkiller:_Animation(UIStroke,TweenInfo.new(0.2),{
					Transparency = 1
				});

				Compkiller:_Animation(ValueText,TweenInfo.new(0.2),{
					TextTransparency = 1
				});

				Compkiller:_Animation(MainButton,TweenInfo.new(0.2),{
					ImageTransparency = 1
				});
			end;
		end);

		Args.Link = Compkiller:_LoadOption({
			AddLink = function(self ,Name , Default)
				return Compkiller:_AddLinkValue(Name , Default , LinkValues , LinkValues , {
					Tween = TweenInfo.new(0.2)	
				} , Signal);
			end,
			Root = Dropdown
		});

		function Args:GetValue()
			return Config.Default;
		end;

		if Config.Flag then
			Compkiller.Flags[Config.Flag] = Args;
		end;

		return Args;
	end;

	return Args;
end;

function Compkiller:GetTheme()
	return Compkiller.Colors;
end;

function Compkiller:SetTheme(name)
	if name == "Dark Green" then
		Compkiller.Colors = {
			["BGDBColor"] = Color3.new(0.0429964, 0.110345, 0.0727226),
			["BlockBackground"] = Color3.new(0.159287, 0.234483, 0.201811),
			["BlockColor"] = Color3.new(0, 0.137931, 0.0951249),
			["DropColor"] = Color3.new(0, 0.227586, 0.100452),
			["Highlight"] = Color3.new(0.0666667, 0.992157, 0.628343),
			["LineColor"] = Color3.new(0.263258, 0.372414, 0.329504),
			["MouseEnter"] = Color3.new(0, 0.841379, 0.51063),
			["Risky"] = Color3.new(1, 0.398296, 0.152941),
			["StrokeColor"] = Color3.new(0.132342, 0.241379, 0.198517),
			["SwitchColor"] = Color3.new(0.927586, 1, 0.980523),
			["Toggle"] = Color3.new(0, 0.613793, 0.220119),
			HighStrokeColor = Color3.new(0, 0.241379, 0.186445),
		};
	elseif name == "Default" then
		Compkiller.Colors = {
			Highlight = Color3.fromRGB(17, 238, 253),
			Toggle = Color3.fromRGB(14, 203, 213),
			Risky = Color3.fromRGB(251, 255, 39),
			BGDBColor = Color3.fromRGB(22, 24, 29),
			BlockColor = Color3.fromRGB(28, 29, 34),
			StrokeColor = Color3.fromRGB(37, 38, 43),
			SwitchColor = Color3.fromRGB(255, 255, 255),
			DropColor = Color3.fromRGB(33, 35, 39),
			MouseEnter = Color3.fromRGB(55, 58, 65),
			BlockBackground = Color3.fromRGB(39, 40, 47),
			LineColor = Color3.fromRGB(65, 65, 65),
			HighStrokeColor = Color3.fromRGB(55, 56, 63),
		};
	elseif name == "Dark Blue" then
		Compkiller.Colors = {
			["BGDBColor"] = Color3.new(0.0393817, 0.0754204, 0.165517),
			["BlockBackground"] = Color3.new(0, 0.0618311, 0.172414),
			["BlockColor"] = Color3.new(0, 0.0172414, 0.103448),
			["DropColor"] = Color3.new(0, 0.0965518, 0.289655),
			["HighStrokeColor"] = Color3.new(0, 0.132604, 0.234483),
			["Highlight"] = Color3.new(0.0666667, 0.781528, 0.992157),
			["LineColor"] = Color3.new(0, 0.110345, 0.275862),
			["MouseEnter"] = Color3.new(0, 0.606896, 1),
			["Risky"] = Color3.new(0.0310345, 0.819572, 1),
			["StrokeColor"] = Color3.new(0, 0.119857, 0.248276),
			["SwitchColor"] = Color3.new(1, 1, 1),
			["Toggle"] = Color3.new(0.054902, 0.463935, 0.835294)
		}
	elseif name == "Purple Rose" then
		Compkiller.Colors = {
			["BGDBColor"] = Color3.new(0.0459068, 0.030321, 0.117241),
			["BlockBackground"] = Color3.new(0.156272, 0.119596, 0.324138),
			["BlockColor"] = Color3.new(0.0948428, 0.0576457, 0.165517),
			["DropColor"] = Color3.new(0.131034, 0, 0.0813317),
			["HighStrokeColor"] = Color3.new(0.136259, 0.101237, 0.296552),
			["Highlight"] = Color3.new(0.992157, 0.0666667, 0.33474),
			["LineColor"] = Color3.new(0.20872, 0.137408, 0.372414),
			["MouseEnter"] = Color3.new(0.365517, 0, 0.120999),
			["Risky"] = Color3.new(1, 0.6086, 0.152941),
			["StrokeColor"] = Color3.new(0.148499, 0.137836, 0.248276),
			["SwitchColor"] = Color3.new(1, 1, 1),
			["Toggle"] = Color3.new(0.835294, 0.054902, 0.248654)
		}
	elseif name == "Skeet" then		
		Compkiller.Colors = {
			["BGDBColor"] = Color3.new(0.114578, 0.125191, 0.151724),
			["BlockBackground"] = Color3.new(0.128181, 0.131124, 0.151724),
			["BlockColor"] = Color3.new(0.0732699, 0.0760008, 0.0896552),
			["DropColor"] = Color3.new(0.0809037, 0.0861197, 0.0965517),
			["HighStrokeColor"] = Color3.new(0.119382, 0.1217, 0.137931),
			["Highlight"] = Color3.new(0, 0.634483, 0.0700119),
			["LineColor"] = Color3.new(0.151724, 0.151724, 0.151724),
			["MouseEnter"] = Color3.new(0.134007, 0.141391, 0.158621),
			["Risky"] = Color3.new(0.984314, 1, 0.152941),
			["StrokeColor"] = Color3.new(0.0769798, 0.0790924, 0.0896552),
			["SwitchColor"] = Color3.new(1, 1, 1),
			["Toggle"] = Color3.new(0, 0.324138, 0.10283)
		}
	end;

	Compkiller:RefreshCurrentColor()
end;

function Compkiller:RefreshCurrentColor()
	for i,v in next , Compkiller.Elements.Highlight do
		if v.Element and v.Property then
			v.Element[v.Property] = Compkiller.Colors.Highlight;
		end;
	end;

	for i,v in next , Compkiller.Elements do
		if v.Element and v.Property and v.Element:GetAttribute('Enabled') then
			v.Element[v.Property] = Compkiller.Colors.Highlight;
		end;
	end;

	for i,v in next , Compkiller.Elements.Risky do
		if v.Element and v.Property then
			v.Element[v.Property] = Compkiller.Colors.Risky;
		end;
	end;

	for i,v in next , Compkiller.Elements.BlockColor do
		if v.Element and v.Property then
			v.Element[v.Property] = Compkiller.Colors.BlockColor;
		end;
	end;

	for i,v in next , Compkiller.Elements.BGDBColor do
		if v.Element and v.Property then
			v.Element[v.Property] = Compkiller.Colors.BGDBColor;
		end;
	end;

	for i,v in next , Compkiller.Elements.StrokeColor do
		if v.Element and v.Property then
			v.Element[v.Property] = Compkiller.Colors.StrokeColor;
		end;
	end;

	for i,v in next , Compkiller.Elements.SwitchColor do
		if v.Element and v.Property and v.Element[v.Property] ~= Compkiller.Colors.MouseEnter then
			v.Element[v.Property] = Compkiller.Colors.SwitchColor;
		end;
	end;

	for i,v in next , Compkiller.Elements.BlockBackground do
		if v.Element and v.Property and v.Element[v.Property] then
			v.Element[v.Property] = Compkiller.Colors.BlockBackground;
		end;
	end;

	for i,v in next , Compkiller.Elements.DropColor do
		if v.Element and v.Property then
			v.Element[v.Property] = Compkiller.Colors.DropColor;
		end;
	end;

	for i,v in next , Compkiller.Elements.LineColor do
		if v.Element and v.Property then
			v.Element[v.Property] = Compkiller.Colors.LineColor;
		end;
	end;

	for i,v in next , Compkiller.Elements.HighStrokeColor do
		if v.Element and v.Property then
			v.Element[v.Property] = Compkiller.Colors.HighStrokeColor;
		end;
	end;
end;

function Compkiller:ChangeHighlightColor(NewColor: Color3)
	local H,S,V = NewColor:ToHSV();

	Compkiller.Colors.Highlight = NewColor;
	Compkiller.Colors.Toggle = Color3.fromHSV(H,S,V - 0.2);

	for i,v in next , Compkiller.Elements.Highlight do
		if v.Element and v.Property then
			v.Element[v.Property] = NewColor;
		end;
	end;

	for i,v in next , Compkiller.Elements do
		if v.Element and v.Property and v.Element:GetAttribute('Enabled') then
			v.Element[v.Property] = NewColor;
		end;
	end;
end;

function Compkiller.new(Config : Window)

	if not Config.Scale then
		if Compkiller:_IsMobile() then
			Config.Scale = Compkiller.Scale.Mobile;
		else
			Config.Scale = Compkiller.Scale.Window;
		end;
	end;

	Config = Compkiller.__CONFIG(Config , {
		Name = "COMPKILLER",
		Keybind = "Insert",
		Logo = Compkiller.Logo;
		Scale = Compkiller.Scale.Window,
		TextSize = 15
	});

	local TabHover = Compkiller.__SIGNAL(false);
	local WindowOpen = Compkiller.__SIGNAL(true);
	local WindowArgs = {
		SelectedTab = nil,
		Tabs = {},
		LastTab = nil,
		IsOpen = true,
		AlwayShowTab = false,
		THREADS = {},
		PerformanceMode = false,
		Notify = Compkiller.newNotify()
	};

	WindowArgs.Username = LocalPlayer.Name;

	if Compkiller:_IsMobile() then
		WindowArgs.AlwayShowTab = true;
	end;

	local CompKiller = Instance.new("ScreenGui")
	local MainFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local TabFrame = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local LineFrame1 = Instance.new("Frame")
	local CompLogo = Instance.new("ImageLabel")
	local WindowLabel = Instance.new("TextLabel")
	local TabButtons = Instance.new("Frame")
	local SelectionFrame = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local TabButtonScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local Userinfo = Instance.new("Frame")
	local UserProfile = Instance.new("ImageLabel")
	local UICorner_4 = Instance.new("UICorner")
	local UserText = Instance.new("TextLabel")
	local ExpireText = Instance.new("TextLabel")
	local TabMainFrame = Instance.new("Frame")

	Compkiller:_DrawKeybinds(CompKiller);

	UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		TabButtonScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y)
	end);

	CompKiller.Name = "u?name=compkiller_?"..Compkiller:_RandomString();
	CompKiller.Parent = CoreGui;
	CompKiller.ResetOnSpawn = false
	CompKiller.IgnoreGuiInset = true;
	CompKiller.ZIndexBehavior = Enum.ZIndexBehavior.Global;

	Compkiller.ProtectGui(CompKiller);

	WindowArgs.Root = CompKiller;

	table.insert(Compkiller.Windows , CompKiller);

	MainFrame.Active = true;
	MainFrame.Name = Compkiller:_RandomString()
	MainFrame.Parent = CompKiller
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Compkiller.Colors.BGDBColor

	table.insert(Compkiller.Elements.BGDBColor,{
		Element = MainFrame,
		Property = 'BackgroundColor3'
	});

	MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.fromScale(0.5,0.5);
	MainFrame.Size = Compkiller.Scale.Window
	MainFrame.ZIndex = 4

	MainFrame:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
		if MainFrame.BackgroundTransparency > 0.9 then
			MainFrame.Visible = false;
		else
			MainFrame.Visible = true;
		end;
	end)

	Compkiller:_Animation(MainFrame,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
		Size = Config.Scale
	});

	UICorner.Parent = MainFrame

	local TabFrameBaseTrans = 0.25;

	TabFrame.Active = true
	TabFrame.Name = Compkiller:_RandomString()
	TabFrame.Parent = MainFrame
	TabFrame.AnchorPoint = Vector2.new(1, 0)
	TabFrame.BackgroundColor3 = Compkiller.Colors.BGDBColor

	table.insert(Compkiller.Elements.BGDBColor,{
		Element = TabFrame,
		Property = 'BackgroundColor3'
	});

	TabFrame.BackgroundTransparency = TabFrameBaseTrans
	TabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabFrame.BorderSizePixel = 0
	TabFrame.ClipsDescendants = true
	TabFrame.Position = UDim2.new(0, 25, 0, 0)
	TabFrame.Size = UDim2.new(0, 85, 1, 0)

	UICorner_2.Parent = TabFrame

	LineFrame1.Name = Compkiller:_RandomString()
	LineFrame1.Parent = TabFrame
	LineFrame1.AnchorPoint = Vector2.new(1, 0)
	LineFrame1.BackgroundColor3 = Compkiller.Colors.BGDBColor

	table.insert(Compkiller.Elements.BGDBColor,{
		Element = LineFrame1,
		Property = 'BackgroundColor3'
	});

	LineFrame1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame1.BorderSizePixel = 0
	LineFrame1.Position = UDim2.new(1, -5, 0, 0)
	LineFrame1.Size = UDim2.new(0, 20, 1, 0)

	CompLogo.Name = Compkiller:_RandomString()
	CompLogo.Parent = TabFrame
	CompLogo.BackgroundTransparency = 1.000
	CompLogo.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CompLogo.BorderSizePixel = 0
	CompLogo.Position = UDim2.new(0, 9, 0, 7)
	CompLogo.Size = UDim2.new(0, 45, 0, 45)
	CompLogo.Image = Config.Logo
	
	if Compkiller.CustomHighlightMode then
		CompLogo.ImageColor3 = Compkiller.Colors.Highlight;
		
		table.insert(Compkiller.Elements.Highlight , {
			Element = CompLogo,
			Property = 'ImageColor3'
		});
	end;
	
	WindowLabel.Name = Compkiller:_RandomString()
	WindowLabel.Parent = TabFrame
	WindowLabel.BackgroundTransparency = 1.000
	WindowLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowLabel.BorderSizePixel = 0
	WindowLabel.Position = UDim2.new(0, 60, 0, 17)
	WindowLabel.Size = UDim2.new(0, 200, 0, 25)
	WindowLabel.Font = Enum.Font.GothamBold
	WindowLabel.Text = Config.Name
	WindowLabel.TextColor3 = Compkiller.Colors.SwitchColor
	WindowLabel.TextSize = Config.TextSize
	WindowLabel.TextXAlignment = Enum.TextXAlignment.Left

	table.insert(Compkiller.Elements.SwitchColor , {
		Element = WindowLabel,
		Property = 'TextColor3'
	});

	TabButtons.Name = Compkiller:_RandomString()
	TabButtons.Parent = TabFrame
	TabButtons.BackgroundTransparency = 1.000
	TabButtons.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabButtons.BorderSizePixel = 0
	TabButtons.Position = UDim2.new(0, 0, 0, 60)
	TabButtons.Size = UDim2.new(1, -25, 1, -125)

	SelectionFrame.Name = Compkiller:_RandomString()
	SelectionFrame.Parent = TabButtons
	SelectionFrame.AnchorPoint = Vector2.new(1, 0)
	SelectionFrame.BackgroundColor3 = Compkiller.Colors.Highlight
	SelectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SelectionFrame.BorderSizePixel = 0
	SelectionFrame.Position = UDim2.new(1, 5, 0, 28)
	SelectionFrame.Size = UDim2.new(0, 8, 0, 27)

	table.insert(Compkiller.Elements.Highlight,{
		Element = SelectionFrame,
		Property = "BackgroundColor3"
	});

	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = SelectionFrame

	TabButtonScrollingFrame.Name = Compkiller:_RandomString()
	TabButtonScrollingFrame.Parent = TabButtons
	TabButtonScrollingFrame.Active = true
	TabButtonScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	TabButtonScrollingFrame.BackgroundTransparency = 1.000
	TabButtonScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabButtonScrollingFrame.BorderSizePixel = 0
	TabButtonScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	TabButtonScrollingFrame.Size = UDim2.new(1, -5, 1, -5)
	TabButtonScrollingFrame.BottomImage = ""
	TabButtonScrollingFrame.ScrollBarThickness = 0
	TabButtonScrollingFrame.TopImage = ""

	UIListLayout.Parent = TabButtonScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 4)

	Userinfo.Name = Compkiller:_RandomString()
	Userinfo.Parent = TabFrame
	Userinfo.AnchorPoint = Vector2.new(0, 1)
	Userinfo.BackgroundTransparency = 1.000
	Userinfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Userinfo.BorderSizePixel = 0
	Userinfo.Position = UDim2.new(0, 0, 1, 0)
	Userinfo.Size = UDim2.new(1, -25, 0, 60)

	do
		local Highlight = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")

		Highlight.Name = Compkiller:_RandomString()
		Highlight.Parent = Userinfo
		Highlight.AnchorPoint = Vector2.new(0.5, 0)
		Highlight.BackgroundColor3 = Color3.fromRGB(161, 161, 161)
		Highlight.BackgroundTransparency = 1
		Highlight.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Highlight.BorderSizePixel = 0
		Highlight.Position = UDim2.new(0.5, 0, 0, 4)
		Highlight.Size = UDim2.new(1, -15, 1, -15)

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Highlight

		Userinfo.MouseEnter:Connect(function()
			Compkiller:_Animation(Highlight,TweenInfo.new(0.2),{
				BackgroundTransparency = 0.925
			});
		end);

		Userinfo.MouseLeave:Connect(function()
			Compkiller:_Animation(Highlight,TweenInfo.new(0.2),{
				BackgroundTransparency = 1
			});
		end);

		Compkiller:_Input(Userinfo,function()
			if WindowArgs.UserSettings.Root then
				WindowArgs.UserSettings:Window(true);
			end;
		end);
	end;

	UserProfile.Name = Compkiller:_RandomString()
	UserProfile.Parent = Userinfo
	UserProfile.BackgroundTransparency = 1.000
	UserProfile.BorderColor3 = Color3.fromRGB(0, 0, 0)
	UserProfile.BorderSizePixel = 0
	UserProfile.Position = UDim2.new(0, 13, 0, 9)
	UserProfile.Size = UDim2.new(0, 35, 0, 35)
	UserProfile.ZIndex = 2
	UserProfile.Image = Compkiller:CacheImage(GetAsset("18518299306"))

	UICorner_4.CornerRadius = UDim.new(1, 0)
	UICorner_4.Parent = UserProfile

	UserText.Name = Compkiller:_RandomString()
	UserText.Parent = Userinfo
	UserText.BackgroundTransparency = 1.000
	UserText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	UserText.BorderSizePixel = 0
	UserText.Position = UDim2.new(0, 55, 0, 8)
	UserText.Size = UDim2.new(0, 200, 0, 20)
	UserText.ZIndex = 2
	UserText.Font = Enum.Font.GothamMedium
	UserText.Text = "Username"
	UserText.TextColor3 = Compkiller.Colors.SwitchColor
	UserText.TextSize = 13.000
	UserText.TextXAlignment = Enum.TextXAlignment.Left

	table.insert(Compkiller.Elements.SwitchColor , {
		Element = UserText,
		Property = 'TextColor3'
	});

	ExpireText.Name = Compkiller:_RandomString()
	ExpireText.Parent = Userinfo
	ExpireText.BackgroundTransparency = 1.000
	ExpireText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ExpireText.BorderSizePixel = 0
	ExpireText.Position = UDim2.new(0, 55, 0, 25)
	ExpireText.Size = UDim2.new(0, 200, 0, 20)
	ExpireText.ZIndex = 2
	ExpireText.Font = Enum.Font.GothamMedium
	ExpireText.Text = "0/0/0"
	ExpireText.TextColor3 = Compkiller.Colors.SwitchColor
	ExpireText.TextSize = 13.000
	ExpireText.TextTransparency = 0.500
	ExpireText.TextXAlignment = Enum.TextXAlignment.Left

	table.insert(Compkiller.Elements.SwitchColor , {
		Element = ExpireText,
		Property = 'TextColor3'
	});

	TabMainFrame.Name = Compkiller:_RandomString()
	TabMainFrame.Parent = MainFrame
	TabMainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	TabMainFrame.BackgroundTransparency = 1.000
	TabMainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabMainFrame.BorderSizePixel = 0
	TabMainFrame.ClipsDescendants = true
	TabMainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	TabMainFrame.Size = UDim2.new(1, 0, 1, 0)
	TabMainFrame.ZIndex = 5

	if Compkiller:_IsMobile() then
		Compkiller:_AddDragBlacklist(TabButtons);
	end;

	WindowOpen:Connect(function(v)
		if WindowArgs.PerformanceMode then
			MainFrame.BackgroundTransparency = (v and 0) or 1;
			return;	
		end;

		if v then
			Compkiller:_Animation(MainFrame,TweenInfo.new(0.2),{
				Size = Config.Scale
			})

			Compkiller:_Animation(TabButtonScrollingFrame,TweenInfo.new(0.35),{
				Position = UDim2.new(0.5, 0, 0.5, 0)
			})

			Compkiller:_Animation(CompLogo,TweenInfo.new(0.2),{
				ImageTransparency = 0
			})

			Compkiller:_Animation(WindowLabel,TweenInfo.new(0.2),{
				TextTransparency = 0
			})

			Compkiller:_Animation(UserProfile,TweenInfo.new(0.2),{
				ImageTransparency = 0
			})

			Compkiller:_Animation(UserText,TweenInfo.new(0.2),{
				TextTransparency = 0
			})

			Compkiller:_Animation(ExpireText,TweenInfo.new(0.2),{
				TextTransparency = 0.5
			})

			Compkiller:_Animation(MainFrame,TweenInfo.new(0.2),{
				BackgroundTransparency = 0
			})

			Compkiller:_Animation(LineFrame1,TweenInfo.new(0.3),{
				BackgroundTransparency = 0,
				Size = UDim2.new(0, 20, 1, 0)
			})

			Compkiller:_Animation(TabFrame,TweenInfo.new(0.2),{
				BackgroundTransparency = TabFrameBaseTrans
			})
		else
			Compkiller:_Animation(MainFrame,TweenInfo.new(0.2),{
				Size = UDim2.new(math.max(Config.Scale.X.Scale - 0.05,0) , Config.Scale.X.Offset - 10 , math.max(Config.Scale.Y.Scale - 0.05,0) , Config.Scale.Y.Offset - 10)
			})

			Compkiller:_Animation(TabButtonScrollingFrame,TweenInfo.new(0.35),{
				Position = UDim2.new(1.5, 100, 0.5, 0)
			})

			Compkiller:_Animation(LineFrame1,TweenInfo.new(0.1),{
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 1, 1, 0)
			})

			Compkiller:_Animation(CompLogo,TweenInfo.new(0.2),{
				ImageTransparency = 1
			})

			Compkiller:_Animation(WindowLabel,TweenInfo.new(0.2),{
				TextTransparency = 1
			})

			Compkiller:_Animation(UserProfile,TweenInfo.new(0.2),{
				ImageTransparency = 1
			})

			Compkiller:_Animation(UserText,TweenInfo.new(0.2),{
				TextTransparency = 1
			})

			Compkiller:_Animation(ExpireText,TweenInfo.new(0.2),{
				TextTransparency = 1
			})

			Compkiller:_Animation(MainFrame,TweenInfo.new(0.2),{
				BackgroundTransparency = 1
			})

			Compkiller:_Animation(TabFrame,TweenInfo.new(0.1),{
				BackgroundTransparency = 1
			})
		end;
	end);

	TabHover:Connect(function(value)
		local Style = TweenInfo.new(0.45,Enum.EasingStyle.Quint);

		if value then
			Compkiller:_Animation(TabFrame , Style , {
				Size = UDim2.new(0, 185,1, 0)
			});

			Compkiller:_Animation(WindowLabel , Style , {
				Position = UDim2.new(0, 60,0, 17),
				TextTransparency = 0
			});

			Compkiller:_Animation(UserText , Style , {
				Position = UDim2.new(0, 55,0, 8),
				TextTransparency = 0.1
			});

			Compkiller:_Animation(ExpireText , Style , {
				Position = UDim2.new(0, 55,0, 25),
				TextTransparency = 0.5
			});
		else
			Compkiller:_Animation(TabFrame , Style , {
				Size = UDim2.new(0, 85,1, 0)
			});

			Compkiller:_Animation(WindowLabel , Style , {
				Position = UDim2.new(0, 60 + 25,0, 17),
				TextTransparency = 1
			});

			Compkiller:_Animation(UserText , Style , {
				Position = UDim2.new(0, 55 + 25,0, 8),
				TextTransparency = 1
			});

			Compkiller:_Animation(ExpireText , Style , {
				Position = UDim2.new(0, 55 + 25,0, 25),
				TextTransparency = 1
			});
		end;
	end);

	WindowArgs.UserSettings = {};

	do
		local Signal = Compkiller.__SIGNAL(false);

		local UserSettings = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local SectionFrame = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIListLayout = Instance.new("UIListLayout")
		local Header = Instance.new("Frame")
		local HeaderText = Instance.new("TextLabel")
		local ImageLabel = Instance.new("ImageLabel")

		UserSettings.Name = Compkiller:_RandomString()
		UserSettings.Parent = CompKiller;
		UserSettings.BackgroundColor3 = Compkiller.Colors.BGDBColor;
		UserSettings.BackgroundTransparency = 1
		UserSettings.BorderColor3 = Color3.fromRGB(0, 0, 0)
		UserSettings.BorderSizePixel = 0
		UserSettings.Position = UDim2.new(0, 50, 0, 50)
		UserSettings.Size = UDim2.new(0, 235, 0, 300)
		UserSettings.ZIndex = 65;
		UserSettings.Visible = false;

		table.insert(Compkiller.Elements.BGDBColor,{
			Element = UserSettings,
			Property = 'BackgroundColor3'
		});

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = UserSettings

		SectionFrame.Name = Compkiller:_RandomString()
		SectionFrame.Parent = UserSettings
		SectionFrame.BackgroundColor3 = Compkiller.Colors.BGDBColor;
		SectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SectionFrame.BorderSizePixel = 0
		SectionFrame.Position = UDim2.new(0, 0, 0, 45)
		SectionFrame.Size = UDim2.new(1, 0, 1, -45)
		SectionFrame.ZIndex = 66

		table.insert(Compkiller.Elements.BGDBColor,{
			Element = SectionFrame,
			Property = 'BackgroundColor3'
		});

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = SectionFrame

		UIListLayout.Parent = SectionFrame
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)

		Header.Name = Compkiller:_RandomString()
		Header.Parent = UserSettings
		Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Header.BackgroundTransparency = 1.000
		Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Header.BorderSizePixel = 0
		Header.Size = UDim2.new(1, 0, 0, 45)
		Header.ZIndex = 66

		HeaderText.Name = Compkiller:_RandomString()
		HeaderText.Parent = Header
		HeaderText.AnchorPoint = Vector2.new(0.5, 0.5)
		HeaderText.BackgroundTransparency = 1.000
		HeaderText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		HeaderText.BorderSizePixel = 0
		HeaderText.Position = UDim2.new(0.5, 0, 0.5, 0)
		HeaderText.Size = UDim2.new(0, 200, 0, 25)
		HeaderText.ZIndex = 67
		HeaderText.Font = Enum.Font.GothamMedium
		HeaderText.Text = "User Settings"
		HeaderText.TextColor3 = Color3.fromRGB(255, 255, 255)
		HeaderText.TextSize = 15.000

		table.insert(Compkiller.Elements.SwitchColor,{
			Element = HeaderText,
			Property = 'TextColor3'
		});

		ImageLabel.Parent = Header
		ImageLabel.AnchorPoint = Vector2.new(1, 0)
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(1, -5, 0, 5)
		ImageLabel.Size = UDim2.new(0, 15, 0, 15)
		ImageLabel.ZIndex = 67
		ImageLabel.Image = Compkiller:CacheImage(GetAsset("10747384394"))
		ImageLabel.ImageTransparency = 0.500

		function WindowArgs.UserSettings:Create()

			WindowArgs.UserSettings.Root = UserSettings;
			WindowArgs.UserSettings.Signal = Signal;
			WindowArgs.UserSettings.Signal = Compkiller:_Blur(UserSettings,Signal);

			Compkiller:Drag(UserSettings , UserSettings, 0.15);

			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				Compkiller:_Animation(UserSettings,TweenInfo.new(0.2),{
					Size = UDim2.new(0, 235, 0, UIListLayout.AbsoluteContentSize.Y + 50)
				})
			end);

			UserSettings:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
				if UserSettings.BackgroundTransparency < 1 then
					UserSettings.Visible = true;
				else
					UserSettings.Visible = false;
				end;
			end);

			function WindowArgs.UserSettings:Window(Value)
				if Value then
					Signal:Fire(true);

					Compkiller:_Animation(UserSettings,TweenInfo.new(0.2),{
						BackgroundTransparency = 0.250,
					});

					Compkiller:_Animation(SectionFrame,TweenInfo.new(0.2),{
						BackgroundTransparency = 0,
					});

					Compkiller:_Animation(HeaderText,TweenInfo.new(0.2),{
						TextTransparency = 0,
					});

					Compkiller:_Animation(ImageLabel,TweenInfo.new(0.2),{
						ImageTransparency = 0.5,
					});
				else
					Signal:Fire(false);

					Compkiller:_Animation(UserSettings,TweenInfo.new(0.2),{
						BackgroundTransparency = 1,
					});

					Compkiller:_Animation(SectionFrame,TweenInfo.new(0.2),{
						BackgroundTransparency = 1,
					});

					Compkiller:_Animation(HeaderText,TweenInfo.new(0.2),{
						TextTransparency = 1,
					});

					Compkiller:_Animation(ImageLabel,TweenInfo.new(0.2),{
						ImageTransparency = 1,
					});
				end;
			end;

			Compkiller:_Input(ImageLabel,function()
				WindowArgs.UserSettings:Window(false);
			end);

			WindowArgs.UserSettings:Window(false);

			return Compkiller:_LoadElement(SectionFrame , true , Signal);
		end;
	end;

	function WindowArgs:SetVisible(bool: boolean)
		CompKiller.Enabled = bool;
	end;

	function WindowArgs:DrawCategory(config : Category)
		config = config or {};
		config.Name = config.Name or "Category";

		local Category = Instance.new("Frame")
		local CategoryText = Instance.new("TextLabel")
		local Frame = Instance.new("Frame")
		local UIGradient = Instance.new("UIGradient")

		Category.Name = Compkiller:_RandomString()
		Category.Parent = TabButtonScrollingFrame
		Category.BackgroundTransparency = 1.000
		Category.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Category.BorderSizePixel = 0
		Category.ClipsDescendants = true
		Category.Size = UDim2.new(1, -10, 0, 22)

		if Compkiller:_IsMobile() then
			Compkiller:_AddDragBlacklist(Category);
		end;

		CategoryText.Name = Compkiller:_RandomString()
		CategoryText.Parent = Category
		CategoryText.BackgroundTransparency = 1.000
		CategoryText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CategoryText.BorderSizePixel = 0
		CategoryText.Position = UDim2.new(0, 5, 0, 8)
		CategoryText.Size = UDim2.new(1, 200, 0, 10)
		CategoryText.Font = Enum.Font.Gotham
		CategoryText.Text = config.Name
		CategoryText.TextColor3 = Compkiller.Colors.SwitchColor
		CategoryText.TextSize = 16.000
		CategoryText.TextTransparency = 0.500
		CategoryText.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = CategoryText,
			Property = 'TextColor3'
		});

		Frame.Parent = Category
		Frame.AnchorPoint = Vector2.new(0.5, 1)
		Frame.BackgroundColor3 = Compkiller.Colors.Highlight
		Frame.BackgroundTransparency = 0.750
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Position = UDim2.new(0.5, 0, 1, 0)
		Frame.Size = UDim2.new(1, 0, 0, 1)

		table.insert(Compkiller.Elements.Highlight,{
			Element = Frame,
			Property = "BackgroundColor3"
		});

		UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.05, 0.21), NumberSequenceKeypoint.new(0.50, 0.00), NumberSequenceKeypoint.new(0.96, 0.17), NumberSequenceKeypoint.new(1.00, 1.00)}
		UIGradient.Parent = Frame

		local Tween = TweenInfo.new(0.35,Enum.EasingStyle.Quint);

		TabHover:Connect(function(bool)
			if bool then
				Compkiller:_Animation(CategoryText,Tween,{
					TextTransparency = 0.500
				});

				Compkiller:_Animation(Frame,Tween,{
					BackgroundTransparency = 0.750
				});
			else
				Compkiller:_Animation(CategoryText,Tween,{
					TextTransparency = 1
				});

				Compkiller:_Animation(Frame,Tween,{
					BackgroundTransparency = 1
				});
			end;
		end);
	end;

	function WindowArgs:DrawContainerTab(TabConfig : ContainerTab)
		TabConfig = Compkiller.__CONFIG(TabConfig,{
			Name = "Tab",
			Icon = "eye",
		});

		local Tween = TweenInfo.new(0.35,Enum.EasingStyle.Quint);
		local TabOpenSignal = Compkiller.__SIGNAL(false);

		local TabArgs = {
			__Current = nil,
			Tabs = {}
		};

		-- Creating Button --

		local TabButton = Instance.new("Frame")
		local Icon = Instance.new("ImageLabel")
		local TabNameLabel = Instance.new("TextLabel")
		local Highlight = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")

		TabButton.Name = Compkiller:_RandomString()
		TabButton.Parent = TabButtonScrollingFrame
		TabButton.BackgroundTransparency = 1.000
		TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.BorderSizePixel = 0
		TabButton.ClipsDescendants = true
		TabButton.Size = UDim2.new(1, -10, 0, 32)
		TabButton.ZIndex = 3

		if Compkiller:_IsMobile() then
			Compkiller:_AddDragBlacklist(TabButton);
		end;

		Icon.Name = Compkiller:_RandomString()
		Icon.Parent = TabButton
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Compkiller.Colors.Highlight
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 15, 0.5, 0)
		Icon.Size = UDim2.new(0, 15, 0, 15)
		Icon.ZIndex = 3
		Icon.Image = Compkiller:_GetIcon(TabConfig.Icon);
		Icon.ImageColor3 = Compkiller.Colors.Highlight

		table.insert(Compkiller.Elements.Highlight,{
			Element = Icon,
			Property = "ImageColor3"
		});

		TabNameLabel.Name = Compkiller:_RandomString()
		TabNameLabel.Parent = TabButton
		TabNameLabel.AnchorPoint = Vector2.new(0, 0.5)
		TabNameLabel.BackgroundTransparency = 1.000
		TabNameLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabNameLabel.BorderSizePixel = 0
		TabNameLabel.Position = UDim2.new(0, 43, 0.5, 0)
		TabNameLabel.Size = UDim2.new(0, 200, 0, 25)
		TabNameLabel.ZIndex = 3
		TabNameLabel.Font = Enum.Font.GothamMedium
		TabNameLabel.Text = TabConfig.Name;
		TabNameLabel.TextColor3 = Compkiller.Colors.SwitchColor
		TabNameLabel.TextSize = 15.000
		TabNameLabel.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = TabNameLabel,
			Property = 'TextColor3'
		});

		Highlight.Name = Compkiller:_RandomString()
		Highlight.Parent = TabButton
		Highlight.AnchorPoint = Vector2.new(0.5, 0.5)
		Highlight.BackgroundColor3 = Color3.fromRGB(161, 161, 161)
		Highlight.BackgroundTransparency = 0.925
		Highlight.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Highlight.BorderSizePixel = 0
		Highlight.Position = UDim2.new(0.5, 0, 0.5, 0)
		Highlight.Size = UDim2.new(1, -17, 1, 0)
		Highlight.ZIndex = 2

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Highlight

		-- Creating Container --

		local ContainerTab = Instance.new("Frame")
		local MainFrame = Instance.new("Frame")
		local Top = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")

		ContainerTab.Name = Compkiller:_RandomString()
		ContainerTab.Parent = TabMainFrame
		ContainerTab.AnchorPoint = Vector2.new(0.5, 0.5)
		ContainerTab.BackgroundTransparency = 1.000
		ContainerTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ContainerTab.BorderSizePixel = 0
		ContainerTab.Position = UDim2.new(0.5, 0, 0.5, 0)
		ContainerTab.Size = UDim2.new(1, -15, 1, -15)
		ContainerTab.ZIndex = 6

		MainFrame.Name = Compkiller:_RandomString()
		MainFrame.Parent = ContainerTab
		MainFrame.AnchorPoint = Vector2.new(0.5, 1)
		MainFrame.BackgroundTransparency = 1.000
		MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MainFrame.BorderSizePixel = 0
		MainFrame.Position = UDim2.new(0.5, 0, 1, -5)
		MainFrame.Size = UDim2.new(1, 0, 1, -35)
		MainFrame.ZIndex = 6
		MainFrame.ClipsDescendants = true

		Top.Name = Compkiller:_RandomString()
		Top.Parent = ContainerTab
		Top.BackgroundTransparency = 1.000
		Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Top.BorderSizePixel = 0
		Top.Size = UDim2.new(1, 0, 0, 25)
		Top.ZIndex = 7

		UIListLayout.Parent = Top
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0, 10)

		-- Functions --
		Highlight:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
			if Highlight.BackgroundTransparency <= 0.99 then
				ContainerTab.Visible = true;
			else
				ContainerTab.Visible = false;
			end;

			if Compkiller.PerformanceMode then
				if ContainerTab.Visible then
					Compkiller:_SetNilP(ContainerTab , TabMainFrame);
				else
					Compkiller:_SetNilP(ContainerTab , nil);
				end;
			else
				Compkiller:_SetNilP(ContainerTab , TabMainFrame);
			end;
		end);

		local TabOpen = function(bool)
			if bool then
				WindowArgs.SelectedTab = TabButton;

				Compkiller:_Animation(Icon,Tween,{
					ImageTransparency = 0,
				});

				Compkiller:_Animation(TabNameLabel,Tween,{
					TextTransparency = 0
				});

				Compkiller:_Animation(Highlight,Tween,{
					BackgroundTransparency = 0.925
				});

				for i,v in next , TabArgs.Tabs do
					if v.Root == TabArgs.__Current.Root then
						v.Remote:Fire(true);
					end;
				end;
			else
				Compkiller:_Animation(Icon,Tween,{
					ImageTransparency = 0.5
				});

				Compkiller:_Animation(TabNameLabel,Tween,{
					TextTransparency = 0.5
				});

				Compkiller:_Animation(Highlight,Tween,{
					BackgroundTransparency = 1
				});

				for i,v in next , TabArgs.Tabs do
					v.Remote:Fire(false);
				end;
			end;
		end;

		if not WindowArgs.Tabs[1] then
			TabOpenSignal:Fire(true);
			TabOpen(true);
		else
			TabOpen(false);
		end;

		table.insert(WindowArgs.Tabs , {
			Root = TabButton,
			Remote = TabOpenSignal
		});

		Compkiller:_Hover(TabButton,function()
			if WindowArgs.SelectedTab ~= TabButton then
				Compkiller:_Animation(Icon,Tween,{
					ImageTransparency = 0.1
				});

				Compkiller:_Animation(TabNameLabel,Tween,{
					TextTransparency = 0.1
				});
			end;
		end , function()
			if WindowArgs.SelectedTab ~= TabButton then
				Compkiller:_Animation(Icon,Tween,{
					ImageTransparency = 0.5
				});

				Compkiller:_Animation(TabNameLabel,Tween,{
					TextTransparency = 0.5
				});
			end;
		end)

		TabOpenSignal:Connect(TabOpen);

		TabHover:Connect(function(bool)
			if bool then
				Compkiller:_Animation(TabButton,Tween,{
					Size = UDim2.new(1, -10, 0, 32)
				});

				Compkiller:_Animation(Icon,Tween,{
					Size = UDim2.new(0, 16, 0, 16),
				});

				Compkiller:_Animation(TabNameLabel,Tween,{
					Size = UDim2.new(0, 200, 0, 25),
					Position = UDim2.new(0, 43, 0.5, 0)
				});

				Compkiller:_Animation(UICorner,Tween,{
					CornerRadius = UDim.new(0, 4)
				});

				Compkiller:_Animation(Highlight,Tween,{
					Size = UDim2.new(1, -17, 1, 0),
					Position = UDim2.new(0.5, 0, 0.5, 0)
				});
			else
				Compkiller:_Animation(UICorner,Tween,{
					CornerRadius = UDim.new(0, 10)
				});

				Compkiller:_Animation(TabButton,Tween,{
					Size = UDim2.new(1, -10, 0, 32)
				});

				Compkiller:_Animation(Icon,Tween,{
					Size = UDim2.new(0, 16, 0, 16),
				});

				Compkiller:_Animation(TabNameLabel,Tween,{
					Size = UDim2.new(0, 200, 0, 25),
					Position = UDim2.new(0, 80, 0.5, 0)
				});

				Compkiller:_Animation(Highlight,Tween,{
					Size = UDim2.new(1, -10,1, 5),
					Position = UDim2.new(0.5, 0, 0.5, 0)
				});
			end;
		end);

		Compkiller:_Input(TabButton,function()
			for i,v in next, WindowArgs.Tabs do
				if v.Root == TabButton then
					v.Remote:Fire(true);
				else
					v.Remote:Fire(false);
				end;
			end;
		end);

		function TabArgs:DrawTab(TabConfig : TabConfig) -- Internal Tab
			TabConfig = Compkiller.__CONFIG(TabConfig,{
				Name = "Tab",
				Type = "Double",
				EnableScrolling = false,
			});

			local InternalSignal = Compkiller.__SIGNAL(false);
			local Frame = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local Highlight = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local TextLabel = Instance.new("TextLabel")

			Frame.Parent = Top
			Frame.BackgroundColor3 = Compkiller.Colors.BlockColor

			table.insert(Compkiller.Elements.BlockColor , {
				Element = Frame,
				Property = "BackgroundColor3"
			});

			Frame.BackgroundTransparency = 1.000
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.ClipsDescendants = true
			Frame.Size = UDim2.new(0, 75, 0, 26)
			Frame.ZIndex = 10

			UICorner.CornerRadius = UDim.new(0, 3)
			UICorner.Parent = Frame

			UIStroke.Transparency = 1.000
			UIStroke.Color = Compkiller.Colors.StrokeColor
			UIStroke.Parent = Frame

			table.insert(Compkiller.Elements.StrokeColor,{
				Element = UIStroke,
				Property = "Color"
			});

			Highlight.Name = Compkiller:_RandomString()
			Highlight.Parent = Frame
			Highlight.AnchorPoint = Vector2.new(1, 0.5)
			Highlight.BackgroundColor3 = Compkiller.Colors.Highlight
			Highlight.BackgroundTransparency = 1.000
			Highlight.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Highlight.BorderSizePixel = 0
			Highlight.Position = UDim2.new(0, 3, 0.5, 0)
			Highlight.Size = UDim2.new(0, 5, 0, 10)
			Highlight.ZIndex = 11

			table.insert(Compkiller.Elements.Highlight,{
				Element = Highlight,
				Property = "BackgroundColor3"
			});

			UICorner_2.CornerRadius = UDim.new(1, 0)
			UICorner_2.Parent = Highlight

			TextLabel.Parent = Frame
			TextLabel.AnchorPoint = Vector2.new(0, 0.5)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0, 10, 0.5, 0)
			TextLabel.Size = UDim2.new(0, 200, 0, 20)
			TextLabel.ZIndex = 12
			TextLabel.Font = Enum.Font.GothamMedium
			TextLabel.Text = TabConfig.Name
			TextLabel.TextColor3 = Compkiller.Colors.SwitchColor
			TextLabel.TextSize = 13.000
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			table.insert(Compkiller.Elements.SwitchColor , {
				Element = TextLabel,
				Property = 'TextColor3'
			});

			local UpdateScale = function()
				local scale = TextService:GetTextSize(TextLabel.Text,TextLabel.TextSize,TextLabel.Font,Vector2.new(math.huge,math.huge));

				Frame.Size = UDim2.new(0, scale.X + 19, 0, 26)
			end;

			UpdateScale()

			local ToggleUI = function(bool)

				UpdateScale();

				if bool then

					Compkiller:_Animation(Highlight,TweenInfo.new(0.2),{
						BackgroundTransparency = 0,
						Size = UDim2.new(0, 5, 0, 10)
					})

					Compkiller:_Animation(Frame,TweenInfo.new(0.2),{
						BackgroundTransparency = 0
					})

					Compkiller:_Animation(UIStroke,TweenInfo.new(0.2),{
						Transparency = 0
					})

					Compkiller:_Animation(TextLabel,TweenInfo.new(0.2),{
						TextTransparency = 0
					})
				else

					Compkiller:_Animation(Highlight,TweenInfo.new(0.2),{
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 5, 0, 2)
					})

					Compkiller:_Animation(Frame,TweenInfo.new(0.2),{
						BackgroundTransparency = 1
					})

					Compkiller:_Animation(UIStroke,TweenInfo.new(0.2),{
						Transparency = 1
					})

					Compkiller:_Animation(TextLabel,TweenInfo.new(0.2),{
						TextTransparency = 0.5
					})
				end;
			end;


			local Id = {
				Root = Frame,
				Remote = InternalSignal
			};

			InternalSignal:Connect(ToggleUI)


			if not TabArgs.Tabs[1] then
				TabArgs.__Current = Id;

				InternalSignal:Fire(true)
			end;

			table.insert(TabArgs.Tabs,Id)

			Compkiller:_Input(Frame,function()
				for i,v in next , TabArgs.Tabs do
					if v.Root == Frame then
						TabArgs.__Current = v;

						v.Remote:Fire(true);
					else
						v.Remote:Fire(false);
					end;
				end;
			end);

			return WindowArgs:DrawTab(TabConfig , {
				ID = Id,
				Highlight = Highlight,
				Signal = InternalSignal,
				Parent = MainFrame
			});
		end;

		return TabArgs;
	end;

	function WindowArgs:AddUnbind(UilistLayout: UIListLayout , Scrolling)

		local upd = function()
			Scrolling.ScrollingEnabled = true
			UilistLayout.VerticalFlex = Enum.UIFlexAlignment.None;
			Scrolling.CanvasSize = UDim2.fromOffset(0,UilistLayout.AbsoluteContentSize.Y + 5)
		end;

		UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(upd);

		return task.defer(function()
			while true do task.wait(1)
				upd();
			end;
		end)

		--[[local Parent: ScrollingFrame = UilistLayout.Parent;

		Parent = Parent or Scrolling;

		local Detection = function()
			local Target = (UilistLayout.AbsoluteContentSize.Y);

			for i,v in next , Parent:GetChildren() do task.wait(0.1)
				local UIList = v:FindFirstChildWhichIsA('UIListLayout');
				if v:IsA('Frame') and UIList then
					if (UIList.AbsoluteContentSize.Y >= Target) or (v.AbsoluteSize.Y >= Target) or (UilistLayout.AbsoluteContentSize.Y > Parent.AbsoluteSize.Y) then
						UilistLayout.VerticalFlex = Enum.UIFlexAlignment.None;
						Parent.ScrollingEnabled = true;
					else
						Parent.ScrollingEnabled = false;
						UilistLayout.VerticalFlex = Enum.UIFlexAlignment.None;
					end;
				end
			end;
		end;

		local Executable = function()
			while true do task.wait(0.15);
				pcall(Detection);
			end;
		end;

		table.insert(WindowArgs.THREADS,task.spawn(Executable))]]
	end;

	function WindowArgs:DrawConfig(Configuration : TabConfigManager , Internal)
		Configuration = Compkiller.__CONFIG(Configuration,{
			Name = "Config",
			Icon = "folder",
			Config = nil
		});

		local TabOpenSignal = Compkiller.__SIGNAL(false);
		local TabArgs = {};

		-- Button --
		local TabButton = Instance.new("Frame")
		local Icon = Instance.new("ImageLabel")
		local TabNameLabel = Instance.new("TextLabel")
		local Highlight = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")

		if Compkiller:_IsMobile() then
			Compkiller:_AddDragBlacklist(TabButton);
		end;

		TabButton.Name = Compkiller:_RandomString()
		TabButton.Parent = TabButtonScrollingFrame
		TabButton.BackgroundTransparency = 1.000
		TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.BorderSizePixel = 0
		TabButton.ClipsDescendants = true
		TabButton.Size = UDim2.new(1, -10, 0, 32)
		TabButton.ZIndex = 3

		Icon.Name = Compkiller:_RandomString()
		Icon.Parent = TabButton
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Compkiller.Colors.Highlight
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 15, 0.5, 0)
		Icon.Size = UDim2.new(0, 15, 0, 15)
		Icon.ZIndex = 3
		Icon.Image = Compkiller:_GetIcon(Configuration.Icon);
		Icon.ImageColor3 = Compkiller.Colors.Highlight

		table.insert(Compkiller.Elements.Highlight,{
			Element = Icon,
			Property = "ImageColor3"
		});

		TabNameLabel.Name = Compkiller:_RandomString()
		TabNameLabel.Parent = TabButton
		TabNameLabel.AnchorPoint = Vector2.new(0, 0.5)
		TabNameLabel.BackgroundTransparency = 1.000
		TabNameLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabNameLabel.BorderSizePixel = 0
		TabNameLabel.Position = UDim2.new(0, 43, 0.5, 0)
		TabNameLabel.Size = UDim2.new(0, 200, 0, 25)
		TabNameLabel.ZIndex = 3
		TabNameLabel.Font = Enum.Font.GothamMedium
		TabNameLabel.Text = Configuration.Name;
		TabNameLabel.TextColor3 = Compkiller.Colors.SwitchColor
		TabNameLabel.TextSize = 15.000
		TabNameLabel.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = TabNameLabel,
			Property = 'TextColor3'
		});

		Highlight.Name = Compkiller:_RandomString()
		Highlight.Parent = TabButton
		Highlight.AnchorPoint = Vector2.new(0.5, 0.5)
		Highlight.BackgroundColor3 = Color3.fromRGB(161, 161, 161)
		Highlight.BackgroundTransparency = 0.925
		Highlight.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Highlight.BorderSizePixel = 0
		Highlight.Position = UDim2.new(0.5, 0, 0.5, 0)
		Highlight.Size = UDim2.new(1, -17, 1, 0)
		Highlight.ZIndex = 2

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Highlight

		local TabConfig = Instance.new("Frame")
		local ConfigList = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local Header = Instance.new("Frame")
		local SectionText = Instance.new("TextLabel")
		local SectionClose = Instance.new("ImageLabel")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local Space = Instance.new("Frame")
		local AddConfig = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke_2 = Instance.new("UIStroke")
		local Header_2 = Instance.new("Frame")
		local SectionText_2 = Instance.new("TextLabel")
		local SectionClose_2 = Instance.new("ImageLabel")
		local Frame = Instance.new("Frame")
		local UIStroke_3 = Instance.new("UIStroke")
		local UICorner_3 = Instance.new("UICorner")
		local TextBox = Instance.new("TextBox")
		local Button = Instance.new("Frame")
		local BlockLine = Instance.new("Frame")
		local Frame_2 = Instance.new("Frame")
		local UIStroke_4 = Instance.new("UIStroke")
		local UICorner_4 = Instance.new("UICorner")
		local TextLabel = Instance.new("TextLabel")

		TabConfig.Name = Compkiller:_RandomString()
		TabConfig.Parent = TabMainFrame
		TabConfig.AnchorPoint = Vector2.new(0.5, 0.5)
		TabConfig.BackgroundTransparency = 1.000
		TabConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabConfig.BorderSizePixel = 0
		TabConfig.Position = UDim2.new(0.5, 0, 0.5, 0)
		TabConfig.Size = UDim2.new(1, 0, 1, 0)
		TabConfig.ZIndex = 6

		ConfigList.Name = Compkiller:_RandomString()
		ConfigList.Parent = TabConfig
		ConfigList.AnchorPoint = Vector2.new(0.5, 0)
		ConfigList.BackgroundColor3 = Compkiller.Colors.BlockColor

		table.insert(Compkiller.Elements.BlockColor , {
			Element = ConfigList,
			Property = "BackgroundColor3"
		});

		ConfigList.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ConfigList.BorderSizePixel = 0
		ConfigList.Position = UDim2.new(0.5, 0, 0, 5)
		ConfigList.Size = UDim2.new(1, -10, 1, -110)
		ConfigList.ZIndex = 9

		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = ConfigList

		UIStroke.Color = Compkiller.Colors.StrokeColor
		UIStroke.Parent = ConfigList

		table.insert(Compkiller.Elements.StrokeColor,{
			Element = UIStroke,
			Property = "Color"
		});

		Header.Name = Compkiller:_RandomString()
		Header.Parent = ConfigList
		Header.BackgroundTransparency = 1.000
		Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Header.BorderSizePixel = 0
		Header.Size = UDim2.new(1, 0, 0, 35)
		Header.ZIndex = 9

		SectionText.Name = Compkiller:_RandomString()
		SectionText.Parent = Header
		SectionText.AnchorPoint = Vector2.new(0, 0.5)
		SectionText.BackgroundTransparency = 1.000
		SectionText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SectionText.BorderSizePixel = 0
		SectionText.Position = UDim2.new(0, 12, 0.5, 0)
		SectionText.Size = UDim2.new(0, 200, 0, 25)
		SectionText.ZIndex = 10
		SectionText.Font = Enum.Font.GothamMedium
		SectionText.Text = "Config List"
		SectionText.TextColor3 = Compkiller.Colors.SwitchColor
		SectionText.TextSize = 14.000
		SectionText.TextTransparency = 0.500
		SectionText.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = SectionText,
			Property = 'TextColor3'
		});

		SectionClose.Name = Compkiller:_RandomString()
		SectionClose.Parent = Header
		SectionClose.AnchorPoint = Vector2.new(1, 0.5)
		SectionClose.BackgroundTransparency = 1.000
		SectionClose.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SectionClose.BorderSizePixel = 0
		SectionClose.Position = UDim2.new(1, -12, 0.5, 0)
		SectionClose.Size = UDim2.new(0, 17, 0, 17)
		SectionClose.ZIndex = 10
		SectionClose.Image = Compkiller:CacheImage(GetAsset("109535175596957"))
		SectionClose.ImageTransparency = 0.500


		ScrollingFrame.Parent = ConfigList
		ScrollingFrame.Active = true
		ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
		ScrollingFrame.BackgroundTransparency = 1.000
		ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.Position = UDim2.new(0.5, 0, 0, 35)
		ScrollingFrame.Size = UDim2.new(1, -10, 1, -45)
		ScrollingFrame.ZIndex = 12
		ScrollingFrame.ScrollBarThickness = 0

		UIListLayout.Parent = ScrollingFrame
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 7)

		Space.Name = Compkiller:_RandomString()
		Space.Parent = ScrollingFrame
		Space.BackgroundTransparency = 1.000
		Space.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Space.BorderSizePixel = 0

		AddConfig.Name = Compkiller:_RandomString()
		AddConfig.Parent = TabConfig
		AddConfig.AnchorPoint = Vector2.new(0.5, 1)
		AddConfig.BackgroundColor3 = Compkiller.Colors.BlockColor

		table.insert(Compkiller.Elements.BlockColor , {
			Element = AddConfig,
			Property = "BackgroundColor3"
		});

		AddConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
		AddConfig.BorderSizePixel = 0
		AddConfig.Position = UDim2.new(0.5, 0, 1, -5)
		AddConfig.Size = UDim2.new(1, -10, 0, 95)
		AddConfig.ZIndex = 9

		UICorner_2.CornerRadius = UDim.new(0, 6)
		UICorner_2.Parent = AddConfig

		UIStroke_2.Color = Compkiller.Colors.StrokeColor
		UIStroke_2.Parent = AddConfig

		table.insert(Compkiller.Elements.StrokeColor,{
			Element = UIStroke_2,
			Property = "Color"
		});

		Header_2.Name = Compkiller:_RandomString()
		Header_2.Parent = AddConfig
		Header_2.BackgroundTransparency = 1.000
		Header_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Header_2.BorderSizePixel = 0
		Header_2.Size = UDim2.new(1, 0, 0, 35)
		Header_2.ZIndex = 9

		SectionText_2.Name = Compkiller:_RandomString()
		SectionText_2.Parent = Header_2
		SectionText_2.AnchorPoint = Vector2.new(0, 0.5)
		SectionText_2.BackgroundTransparency = 1.000
		SectionText_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SectionText_2.BorderSizePixel = 0
		SectionText_2.Position = UDim2.new(0, 12, 0.5, 0)
		SectionText_2.Size = UDim2.new(0, 200, 0, 25)
		SectionText_2.ZIndex = 10
		SectionText_2.Font = Enum.Font.GothamMedium
		SectionText_2.Text = "Add Config"
		SectionText_2.TextColor3 = Compkiller.Colors.SwitchColor
		SectionText_2.TextSize = 14.000
		SectionText_2.TextTransparency = 0.500
		SectionText_2.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = SectionText_2,
			Property = 'TextColor3'
		});

		SectionClose_2.Name = Compkiller:_RandomString()
		SectionClose_2.Parent = Header_2
		SectionClose_2.AnchorPoint = Vector2.new(1, 0.5)
		SectionClose_2.BackgroundTransparency = 1.000
		SectionClose_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SectionClose_2.BorderSizePixel = 0
		SectionClose_2.Position = UDim2.new(1, -12, 0.5, 0)
		SectionClose_2.Size = UDim2.new(0, 17, 0, 17)
		SectionClose_2.ZIndex = 10
		SectionClose_2.Image = Compkiller:CacheImage(GetAsset("109535175596957"))
		SectionClose_2.ImageTransparency = 0.500

		Frame.Parent = AddConfig
		Frame.AnchorPoint = Vector2.new(0.5, 0)
		Frame.BackgroundColor3 = Compkiller.Colors.BlockColor

		table.insert(Compkiller.Elements.BlockColor , {
			Element = Frame,
			Property = "BackgroundColor3"
		});

		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Position = UDim2.new(0.5, 0, 0, 35)
		Frame.Size = UDim2.new(1, -20, 0, 20)
		Frame.ZIndex = 15

		UIStroke_3.Color = Compkiller.Colors.StrokeColor
		UIStroke_3.Parent = Frame

		table.insert(Compkiller.Elements.StrokeColor,{
			Element = UIStroke_3,
			Property = "Color"
		});

		UICorner_3.CornerRadius = UDim.new(0, 4)
		UICorner_3.Parent = Frame

		TextBox.Parent = Frame
		TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextBox.Size = UDim2.new(1, -15, 1, -2)
		TextBox.ZIndex = 15
		TextBox.ClearTextOnFocus = false
		TextBox.Font = Enum.Font.GothamMedium
		TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
		TextBox.PlaceholderText = "Config Name..."
		TextBox.Text = ""
		TextBox.TextColor3 = Compkiller.Colors.SwitchColor
		TextBox.TextSize = 12.000
		TextBox.TextXAlignment = Enum.TextXAlignment.Left

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = TextBox,
			Property = 'TextColor3'
		});

		Button.Name = Compkiller:_RandomString()
		Button.Parent = AddConfig
		Button.AnchorPoint = Vector2.new(0.5, 1)
		Button.BackgroundColor3 = Compkiller.Colors.SwitchColor
		Button.BackgroundTransparency = 1.000
		Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Button.BorderSizePixel = 0
		Button.Position = UDim2.new(0.5, 0, 1, -10)
		Button.Size = UDim2.new(1, -7, 0, 25)
		Button.ZIndex = 10

		BlockLine.Name = Compkiller:_RandomString()
		BlockLine.Parent = AddConfig
		BlockLine.AnchorPoint = Vector2.new(0.5, 1)
		BlockLine.BackgroundColor3 = Compkiller.Colors.LineColor
		BlockLine.BackgroundTransparency = 0.500
		BlockLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BlockLine.BorderSizePixel = 0
		BlockLine.Position = UDim2.new(0.5, 0, 0.5, 12)
		BlockLine.Size = UDim2.new(1, -26, 0, 1)
		BlockLine.ZIndex = 12

		table.insert(Compkiller.Elements.LineColor,{
			Element = BlockLine,
			Property = "BackgroundColor3"
		});

		Frame_2.Parent = Button
		Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame_2.BackgroundColor3 = Compkiller.Colors.Highlight
		Frame_2.BackgroundTransparency = 0.100
		Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame_2.BorderSizePixel = 0
		Frame_2.Position = UDim2.new(0.5, 0, 0.5, 0)
		Frame_2.Size = UDim2.new(1, -15, 1, -5)
		Frame_2.ZIndex = 9

		table.insert(Compkiller.Elements.Highlight,{
			Element = Frame_2,
			Property = "BackgroundColor3"
		});

		UIStroke_4.Color = Compkiller.Colors.StrokeColor
		UIStroke_4.Parent = Frame_2

		table.insert(Compkiller.Elements.StrokeColor,{
			Element = UIStroke_4,
			Property = "Color"
		});

		UICorner_4.CornerRadius = UDim.new(0, 3)
		UICorner_4.Parent = Frame_2

		TextLabel.Parent = Frame_2
		TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextLabel.Size = UDim2.new(1, 0, 1, 0)
		TextLabel.ZIndex = 10
		TextLabel.Font = Enum.Font.GothamMedium
		TextLabel.Text = "Add Config"
		TextLabel.TextColor3 = Compkiller.Colors.SwitchColor
		TextLabel.TextSize = 12.000
		TextLabel.TextStrokeTransparency = 0.900

		table.insert(Compkiller.Elements.SwitchColor , {
			Element = TextLabel,
			Property = 'TextColor3'
		});

		local Tween = TweenInfo.new(0.35,Enum.EasingStyle.Quint);

		Highlight:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
			if Highlight.BackgroundTransparency <= 0.99 then
				TabConfig.Visible = true;
			else
				TabConfig.Visible = false;
			end;

			if Compkiller.PerformanceMode then
				if TabConfig.Visible then
					Compkiller:_SetNilP(TabConfig , TabMainFrame);
				else
					Compkiller:_SetNilP(TabConfig , nil);
				end;
			else
				Compkiller:_SetNilP(TabConfig , TabMainFrame);
			end;

		end)

		local TabOpen = function(bool)
			if bool then

				WindowArgs.SelectedTab = TabButton;

				Compkiller:_Animation(Icon,Tween,{
					ImageTransparency = 0,
				});

				Compkiller:_Animation(TabNameLabel,Tween,{
					TextTransparency = 0
				});

				Compkiller:_Animation(Highlight,Tween,{
					BackgroundTransparency = 0.925
				});

				--

				Compkiller:_Animation(ConfigList,Tween,{
					BackgroundTransparency = 0,
				});

				Compkiller:_Animation(AddConfig,Tween,{
					BackgroundTransparency = 0,
				});

				Compkiller:_Animation(UIStroke_4,Tween,{
					Transparency = 0,
				});

				Compkiller:_Animation(UIStroke_3,Tween,{
					Transparency = 0,
				});

				Compkiller:_Animation(UIStroke_2,Tween,{
					Transparency = 0,
				});

				Compkiller:_Animation(UIStroke,Tween,{
					Transparency = 0,
				});

				Compkiller:_Animation(SectionText,Tween,{
					TextTransparency = 0.5
				});

				Compkiller:_Animation(TextLabel,Tween,{
					TextTransparency = 0,
					TextStrokeTransparency = 0.9
				});

				Compkiller:_Animation(Frame_2,Tween,{
					BackgroundTransparency = 0.1,
				});

				Compkiller:_Animation(BlockLine,Tween,{
					BackgroundTransparency = 0.5,
				});

				Compkiller:_Animation(Frame,Tween,{
					BackgroundTransparency = 0,
				});

				Compkiller:_Animation(SectionText_2,Tween,{
					TextTransparency = 0.5
				});

				Compkiller:_Animation(TextBox,Tween,{
					TextTransparency = 0
				});

				Compkiller:_Animation(SectionClose,Tween,{
					ImageTransparency = 0.5,
				});

				Compkiller:_Animation(SectionClose_2,Tween,{
					ImageTransparency = 0.5,
				});
			else

				Compkiller:_Animation(Icon,Tween,{
					ImageTransparency = 0.5
				});

				Compkiller:_Animation(TabNameLabel,Tween,{
					TextTransparency = 0.5
				});

				Compkiller:_Animation(Highlight,Tween,{
					BackgroundTransparency = 1
				});

				Compkiller:_Animation(ConfigList,Tween,{
					BackgroundTransparency = 1,
				});

				Compkiller:_Animation(AddConfig,Tween,{
					BackgroundTransparency = 1,
				});

				Compkiller:_Animation(UIStroke_4,Tween,{
					Transparency = 1,
				});

				Compkiller:_Animation(UIStroke_3,Tween,{
					Transparency = 1,
				});

				Compkiller:_Animation(UIStroke_2,Tween,{
					Transparency = 1,
				});

				Compkiller:_Animation(UIStroke,Tween,{
					Transparency = 1,
				});

				Compkiller:_Animation(SectionText,Tween,{
					TextTransparency = 1
				});

				Compkiller:_Animation(TextLabel,Tween,{
					TextTransparency = 1,
					TextStrokeTransparency = 1
				});

				Compkiller:_Animation(Frame_2,Tween,{
					BackgroundTransparency = 1,
				});

				Compkiller:_Animation(BlockLine,Tween,{
					BackgroundTransparency = 1,
				});

				Compkiller:_Animation(Frame,Tween,{
					BackgroundTransparency = 1,
				});

				Compkiller:_Animation(SectionText_2,Tween,{
					TextTransparency = 1
				});

				Compkiller:_Animation(TextBox,Tween,{
					TextTransparency = 1
				});

				Compkiller:_Animation(SectionClose,Tween,{
					ImageTransparency = 1,
				});

				Compkiller:_Animation(SectionClose_2,Tween,{
					ImageTransparency = 1,
				});
			end;
		end;

		if not WindowArgs.Tabs[1] then
			TabOpenSignal:Fire(true);
			TabOpen(true);
		else
			TabOpen(false);
		end;

		table.insert(WindowArgs.Tabs , {
			Root = TabButton,
			Remote = TabOpenSignal
		});

		Compkiller:_Hover(TabButton,function()
			if WindowArgs.SelectedTab ~= TabButton then
				Compkiller:_Animation(Icon,Tween,{
					ImageTransparency = 0.1
				});

				Compkiller:_Animation(TabNameLabel,Tween,{
					TextTransparency = 0.1
				});
			end;
		end , function()
			if WindowArgs.SelectedTab ~= TabButton then
				Compkiller:_Animation(Icon,Tween,{
					ImageTransparency = 0.5
				});

				Compkiller:_Animation(TabNameLabel,Tween,{
					TextTransparency = 0.5
				});
			end;
		end)

		TabOpenSignal:Connect(TabOpen);

		TabHover:Connect(function(bool)
			if bool then
				Compkiller:_Animation(TabButton,Tween,{
					Size = UDim2.new(1, -10, 0, 32)
				});

				Compkiller:_Animation(Icon,Tween,{
					Size = UDim2.new(0, 16, 0, 16),
				});

				Compkiller:_Animation(TabNameLabel,Tween,{
					Size = UDim2.new(0, 200, 0, 25),
					Position = UDim2.new(0, 43, 0.5, 0)
				});

				Compkiller:_Animation(UICorner,Tween,{
					CornerRadius = UDim.new(0, 4)
				});

				Compkiller:_Animation(Highlight,Tween,{
					Size = UDim2.new(1, -17, 1, 0),
					Position = UDim2.new(0.5, 0, 0.5, 0)
				});
			else
				Compkiller:_Animation(UICorner,Tween,{
					CornerRadius = UDim.new(0, 10)
				});

				Compkiller:_Animation(TabButton,Tween,{
					Size = UDim2.new(1, -10, 0, 32)
				});

				Compkiller:_Animation(Icon,Tween,{
					Size = UDim2.new(0, 16, 0, 16),
				});

				Compkiller:_Animation(TabNameLabel,Tween,{
					Size = UDim2.new(0, 200, 0, 25),
					Position = UDim2.new(0, 80, 0.5, 0)
				});

				Compkiller:_Animation(Highlight,Tween,{
					Size = UDim2.new(1, -10,1, 5),
					Position = UDim2.new(0.5, 0, 0.5, 0)
				});
			end;
		end);

		Compkiller:_Input(TabButton,function()
			for i,v in next, WindowArgs.Tabs do
				if v.Root == TabButton then
					v.Remote:Fire(true);
				else
					v.Remote:Fire(false);
				end;
			end;
		end);

		function TabArgs:_DrawConfig()
			local ConfigButton = {};

			local ConfigBlock = Instance.new("Frame")
			local ConfigText = Instance.new("TextLabel")
			local LinkValues = Instance.new("Frame")
			local UIListLayout = Instance.new("UIListLayout")
			local SaveButton = Instance.new("Frame")
			local Frame = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local TextLabel = Instance.new("TextLabel")
			local Icon = Instance.new("ImageLabel")
			local LoadButton = Instance.new("Frame")
			local Frame_2 = Instance.new("Frame")
			local UIStroke_2 = Instance.new("UIStroke")
			local UICorner_2 = Instance.new("UICorner")
			local TextLabel_2 = Instance.new("TextLabel")
			local Icon_2 = Instance.new("ImageLabel")
			local UIStroke_3 = Instance.new("UIStroke")
			local UICorner_3 = Instance.new("UICorner")
			local AuthorText = Instance.new("TextLabel")
			local DelButton = Instance.new("ImageButton")
			local UICorner = Instance.new("UICorner")
			local UIGradient = Instance.new("UIGradient")

			DelButton.Name = Compkiller:_RandomString()
			DelButton.Parent = LinkValues
			DelButton.BackgroundTransparency = 1.000
			DelButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DelButton.BorderSizePixel = 0
			DelButton.LayoutOrder = -9999
			DelButton.Size = UDim2.new(0, 35, 0, 15)
			DelButton.ZIndex = 14
			DelButton.Image = Compkiller:CacheImage(GetAsset("10747362393"))
			DelButton.ImageColor3 = Color3.fromRGB(255, 107, 107)
			DelButton.ImageTransparency = 0.500
			DelButton.ScaleType = Enum.ScaleType.Fit

			UICorner.CornerRadius = UDim.new(1, 0)
			UICorner.Parent = DelButton
			ConfigBlock.Name = Compkiller:_RandomString()
			ConfigBlock.Parent = ScrollingFrame
			ConfigBlock.BackgroundColor3 = Color3.fromRGB(33, 34, 40)
			ConfigBlock.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ConfigBlock.BorderSizePixel = 0
			ConfigBlock.BackgroundTransparency = 1
			ConfigBlock.Size = UDim2.new(1, -1, 0, 40)
			ConfigBlock.ZIndex = 10

			if Compkiller:_IsMobile() then
				Compkiller:_AddDragBlacklist(ConfigBlock);
			end;

			ConfigText.Name = Compkiller:_RandomString()
			ConfigText.Parent = ConfigBlock
			ConfigText.AnchorPoint = Vector2.new(0, 0.5)
			ConfigText.BackgroundTransparency = 1.000
			ConfigText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ConfigText.BorderSizePixel = 0
			ConfigText.Position = UDim2.new(0, 12, 0.5, 15)
			ConfigText.Size = UDim2.new(1, -20, 0, 25)
			ConfigText.ZIndex = 10
			ConfigText.Font = Enum.Font.GothamMedium
			ConfigText.RichText = true;
			ConfigText.Text = "Config"
			ConfigText.TextColor3 = Compkiller.Colors.SwitchColor
			ConfigText.TextSize = 13.000
			ConfigText.TextTransparency = 1
			ConfigText.TextXAlignment = Enum.TextXAlignment.Left

			table.insert(Compkiller.Elements.SwitchColor , {
				Element = ConfigText,
				Property = 'TextColor3'
			});

			UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.29, 0.00), NumberSequenceKeypoint.new(0.33, 1.00), NumberSequenceKeypoint.new(1.00, 1.00)}
			UIGradient.Parent = ConfigText

			LinkValues.Name = Compkiller:_RandomString()
			LinkValues.Parent = ConfigBlock
			LinkValues.AnchorPoint = Vector2.new(1, 0.540000021)
			LinkValues.BackgroundTransparency = 1.000
			LinkValues.BorderColor3 = Color3.fromRGB(0, 0, 0)
			LinkValues.BorderSizePixel = 0
			LinkValues.Position = UDim2.new(1, -12, 0.5, 15)
			LinkValues.Size = UDim2.new(1, 0, 0, 18)
			LinkValues.ZIndex = 11

			UIListLayout.Parent = LinkValues
			UIListLayout.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			UIListLayout.Padding = UDim.new(0, -10)

			SaveButton.Name = Compkiller:_RandomString()
			SaveButton.Parent = LinkValues
			SaveButton.BackgroundTransparency = 1.000
			SaveButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SaveButton.BorderSizePixel = 0
			SaveButton.Size = UDim2.new(0, 77, 0, 30)
			SaveButton.ZIndex = 14

			Frame.Parent = SaveButton
			Frame.AnchorPoint = Vector2.new(0.5, 0.5)
			Frame.BackgroundColor3 = Compkiller.Colors.Highlight
			Frame.BackgroundTransparency = 1
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
			Frame.Size = UDim2.new(1, -15, 1, -5)
			Frame.ZIndex = 14

			table.insert(Compkiller.Elements.Highlight,{
				Element = Frame,
				Property = "BackgroundColor3"
			});

			UIStroke.Transparency = 1
			UIStroke.Color = Compkiller.Colors.StrokeColor
			UIStroke.Parent = Frame

			table.insert(Compkiller.Elements.StrokeColor,{
				Element = UIStroke,
				Property = "Color"
			});

			UICorner.CornerRadius = UDim.new(0, 3)
			UICorner.Parent = Frame

			TextLabel.Parent = Frame
			TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.5, 27, 0.5, 0)
			TextLabel.Size = UDim2.new(1, 0, 1, 0)
			TextLabel.ZIndex = 14
			TextLabel.Font = Enum.Font.GothamMedium
			TextLabel.Text = "Save"
			TextLabel.TextColor3 = Compkiller.Colors.SwitchColor
			TextLabel.TextSize = 12.000
			TextLabel.TextStrokeTransparency = 1
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.TextTransparency = 1

			table.insert(Compkiller.Elements.SwitchColor , {
				Element = TextLabel,
				Property = 'TextColor3'
			});

			Icon.Name = Compkiller:_RandomString()
			Icon.Parent = Frame
			Icon.AnchorPoint = Vector2.new(0, 0.5)
			Icon.BackgroundTransparency = 1.000
			Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Icon.BorderSizePixel = 0
			Icon.Position = UDim2.new(0, 5, 0.5, 0)
			Icon.Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
			Icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
			Icon.ZIndex = 15
			Icon.Image = Compkiller:CacheImage(GetAsset("10734941499"))
			Icon.ImageTransparency = 1;

			LoadButton.Name = Compkiller:_RandomString()
			LoadButton.Parent = LinkValues
			LoadButton.BackgroundTransparency = 1.000
			LoadButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			LoadButton.BorderSizePixel = 0
			LoadButton.Size = UDim2.new(0, 77, 0, 30)
			LoadButton.ZIndex = 14

			Frame_2.Parent = LoadButton
			Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
			Frame_2.BackgroundColor3 = Compkiller.Colors.Highlight
			Frame_2.BackgroundTransparency = 1
			Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame_2.BorderSizePixel = 0
			Frame_2.Position = UDim2.new(0.5, 0, 0.5, 0)
			Frame_2.Size = UDim2.new(1, -15, 1, -5)
			Frame_2.ZIndex = 14

			table.insert(Compkiller.Elements.Highlight,{
				Element = Frame_2,
				Property = "BackgroundColor3"
			});

			UIStroke_2.Transparency = 1
			UIStroke_2.Color = Compkiller.Colors.StrokeColor
			UIStroke_2.Parent = Frame_2

			table.insert(Compkiller.Elements.StrokeColor,{
				Element = UIStroke_2,
				Property = "Color"
			});

			UICorner_2.CornerRadius = UDim.new(0, 3)
			UICorner_2.Parent = Frame_2

			TextLabel_2.Parent = Frame_2
			TextLabel_2.AnchorPoint = Vector2.new(0.5, 0.5)
			TextLabel_2.BackgroundTransparency = 1.000
			TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel_2.BorderSizePixel = 0
			TextLabel_2.Position = UDim2.new(0.5, 27, 0.5, 0)
			TextLabel_2.Size = UDim2.new(1, 0, 1, 0)
			TextLabel_2.ZIndex = 14
			TextLabel_2.Font = Enum.Font.GothamMedium
			TextLabel_2.Text = "Load"
			TextLabel_2.TextColor3 = Compkiller.Colors.SwitchColor
			TextLabel_2.TextSize = 12.000
			TextLabel_2.TextStrokeTransparency = 1
			TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel_2.TextTransparency = 1

			table.insert(Compkiller.Elements.SwitchColor , {
				Element = TextLabel_2,
				Property = 'TextColor3'
			});

			Icon_2.Name = Compkiller:_RandomString()
			Icon_2.Parent = Frame_2
			Icon_2.AnchorPoint = Vector2.new(0, 0.5)
			Icon_2.BackgroundTransparency = 1.000
			Icon_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Icon_2.BorderSizePixel = 0
			Icon_2.Position = UDim2.new(0, 5, 0.5, 0)
			Icon_2.Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
			Icon_2.SizeConstraint = Enum.SizeConstraint.RelativeYY
			Icon_2.ZIndex = 15
			Icon_2.Image = Compkiller:CacheImage(GetAsset("10723344270"))
			Icon_2.ImageTransparency = 1
			UIStroke_3.Transparency = 1

			UIStroke_3.Color = Compkiller.Colors.StrokeColor
			UIStroke_3.Parent = ConfigBlock

			table.insert(Compkiller.Elements.StrokeColor,{
				Element = UIStroke_3,
				Property = "Color"
			});

			UICorner_3.CornerRadius = UDim.new(0, 6)
			UICorner_3.Parent = ConfigBlock

			AuthorText.Name = Compkiller:_RandomString()
			AuthorText.Parent = ConfigBlock
			AuthorText.AnchorPoint = Vector2.new(0, 0.5)
			AuthorText.BackgroundTransparency = 1.000
			AuthorText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			AuthorText.BorderSizePixel = 0
			AuthorText.Position = UDim2.new(0.5, -65, 0.5, 15)
			AuthorText.Size = UDim2.new(1, -20, 0, 25)
			AuthorText.ZIndex = 10
			AuthorText.Font = Enum.Font.GothamMedium
			AuthorText.RichText = true;
			AuthorText.Text = "Author: <font color=\"rgb(17, 238, 253)\">NoFi</font>"
			AuthorText.TextColor3 = Compkiller.Colors.SwitchColor
			AuthorText.TextSize = 13.000
			AuthorText.TextTransparency = 1
			AuthorText.TextXAlignment = Enum.TextXAlignment.Left

			table.insert(Compkiller.Elements.SwitchColor , {
				Element = TabNameLabel,
				Property = 'TextColor3'
			});

			function ConfigButton:SetInfo(Author , ConfigName)
				local R,G,B = tostring(math.floor(Compkiller.Colors.Highlight.R * 255)) , tostring(math.floor(Compkiller.Colors.Highlight.G * 255)) , tostring(math.floor(Compkiller.Colors.Highlight.B * 255));

				AuthorText.Text = string.format("Author: <font color=\"rgb(%s, %s, %s)\">%s</font>" ,R,G,B , tostring(Author));
				ConfigText.Text = ConfigName;

				if ConfigBlock.BackgroundTransparency >= 0.7 then
					ConfigButton:Update();
				end;
			end;

			function ConfigButton:Toggle(v)
				if v then
					Compkiller:_Animation(ConfigBlock,Tween,{
						BackgroundTransparency = 0
					});

					Compkiller:_Animation(LinkValues,Tween,{
						Position = UDim2.new(1, -12, 0.5, 0)
					});

					Compkiller:_Animation(ConfigText,Tween,{
						TextTransparency = 0.3,
						Position = UDim2.new(0, 12, 0.5, 0)
					});

					Compkiller:_Animation(Frame,Tween,{
						BackgroundTransparency = 0.100
					});

					Compkiller:_Animation(UIStroke,Tween,{
						Transparency = 0
					});

					Compkiller:_Animation(AuthorText,Tween,{
						TextTransparency = 0.5,
						Position = UDim2.new(0,AuthorText:GetAttribute('SPC'), 0.5, 0)
					});

					Compkiller:_Animation(Icon_2,Tween,{
						ImageTransparency = 0
					});

					Compkiller:_Animation(Icon,Tween,{
						ImageTransparency = 0
					});

					Compkiller:_Animation(Frame_2,Tween,{
						BackgroundTransparency = 0.100
					});

					Compkiller:_Animation(UIStroke_2,Tween,{
						Transparency = 0
					});

					Compkiller:_Animation(TextLabel,Tween,{
						TextStrokeTransparency = 0.900,
						TextTransparency = 0
					});

					Compkiller:_Animation(TextLabel_2,Tween,{
						TextStrokeTransparency = 0.900,
						TextTransparency = 0
					});
				else
					Compkiller:_Animation(AuthorText,Tween,{
						TextTransparency = 1,
						Position = UDim2.new(0.5, -65, 0.5, 15)
					});

					Compkiller:_Animation(Icon_2,Tween,{
						ImageTransparency = 1
					});

					Compkiller:_Animation(Icon,Tween,{
						ImageTransparency = 1
					});

					Compkiller:_Animation(LinkValues,Tween,{
						Position = UDim2.new(1, -12, 0.5, 15)
					});

					Compkiller:_Animation(ConfigBlock,Tween,{
						BackgroundTransparency = 1
					});

					Compkiller:_Animation(ConfigText,Tween,{
						TextTransparency = 1,
						Position = UDim2.new(0, 12, 0.5, 15)
					});

					Compkiller:_Animation(Frame,Tween,{
						BackgroundTransparency = 1
					});

					Compkiller:_Animation(UIStroke,Tween,{
						Transparency = 1
					});

					Compkiller:_Animation(Frame_2,Tween,{
						BackgroundTransparency = 1
					});

					Compkiller:_Animation(UIStroke_2,Tween,{
						Transparency = 1
					});

					Compkiller:_Animation(TextLabel,Tween,{
						TextStrokeTransparency = 1,
						TextTransparency = 1
					});

					Compkiller:_Animation(TextLabel_2,Tween,{
						TextStrokeTransparency = 1,
						TextTransparency = 1
					});
				end;
			end;

			function ConfigButton:Update()
				local nameScale = TextService:GetTextSize(ConfigText.Text,ConfigText.TextSize,ConfigText.Font,Vector2.new(math.huge,math.huge));

				AuthorText:SetAttribute('SPC',math.clamp(nameScale.X + 20 , 100,150));

				AuthorText.Position = UDim2.new(0, AuthorText:GetAttribute('SPC'), 0.5, 15)
			end;

			ConfigButton:Update();

			Compkiller:_Input(LoadButton,function()
				task.spawn(ConfigButton.OnLoad);
			end);

			Compkiller:_Input(SaveButton,function()
				task.spawn(ConfigButton.OnSave);
			end);

			DelButton.MouseButton1Click:Connect(function()
				task.spawn(ConfigButton.OnDelete);
			end)

			ConfigButton.OnLoad = nil;
			ConfigButton.OnSave = nil;
			ConfigButton.OnDelete = nil;

			return ConfigButton;
		end;

		function TabArgs:Init()
			local __signals = {};
			local Init = {};

			Compkiller:_Input(Button,function()
				if TextBox.Text:byte() then
					WindowArgs.Notify.new({
						Title = "Configs",
						Icon = Compkiller:_GetIcon(Config.Logo),
						Content = "Create config \""..TextBox.Text.."\""
					})

					Configuration.Config:WriteConfig({
						Name = TextBox.Text,
						Author = WindowArgs.Username,
					});
				end;
			end);

			local Refresh = function()
				local FullConfig = Configuration.Config:GetFullConfigs();

				for i,v in next, ScrollingFrame:GetChildren() do
					if v:IsA('Frame') and v.Name ~= "Space" then
						v:Destroy();
					end;
				end;

				for i,v in next , __signals do
					v:Disconnect();
				end;

				for i,v in next , FullConfig do
					local Button = TabArgs:_DrawConfig();

					Button:SetInfo(v.Info.Author,v.Name);

					table.insert(__signals,TabOpenSignal:Connect(function(v)
						Button:Toggle(v);
					end));

					Button.OnLoad = function()
						WindowArgs.Notify.new({
							Title = "Configs",
							Icon = Compkiller:CacheImage(Config.Logo),
							Content = "Load config \""..v.Name.."\""
						})

						Configuration.Config:LoadConfig(v.Name);
					end;

					Button.OnSave = function()
						WindowArgs.Notify.new({
							Title = "Configs",
							Icon = Compkiller:CacheImage(Config.Logo),
							Content = "Save config \""..v.Name.."\""
						})

						Button:SetInfo(v.Info.Author,v.Name);

						Configuration.Config:WriteConfig({
							Name = v.Name,
							Author = v.Info.Author;
						});
					end

					Button.OnDelete = function()
						WindowArgs.Notify.new({
							Title = "Configs",
							Icon = Compkiller:CacheImage(Config.Logo),
							Content = "Delete config \""..v.Name.."\""
						})

						Configuration.Config:DeleteConfig(v.Name)
					end
				end;
			end;

			Refresh();

			Init.THREAD = task.spawn(function()
				local OldIndex = Configuration.Config:GetConfigCount();

				while true do task.wait(0.125);
					local CountInDirectory = Configuration.Config:GetConfigCount();

					if OldIndex ~= CountInDirectory then
						OldIndex = CountInDirectory;

						Refresh();
					end;
				end;
			end);

			return Init;
		end;

		return TabArgs;
	end;

	function WindowArgs:DrawTab(TabConfig : TabConfig , Internal)
		TabConfig = Compkiller.__CONFIG(TabConfig,{
			Name = "Tab",
			Icon = "eye",
			Type = "Double"
		});

		local TabOpenSignal = Compkiller.__SIGNAL(false);
		local TabArgs = {};
		local Upvalue = {};
		local BASE_PADDING = 10;

		if Internal then

			local TabContent = Instance.new("Frame")
			local Left = Instance.new("ScrollingFrame")
			local UIListLayout = Instance.new("UIListLayout")
			local Right = Instance.new("ScrollingFrame")
			local UIListLayout_2 = Instance.new("UIListLayout")

			TabContent.Name = Compkiller:_RandomString()
			TabContent.Parent = Internal.Parent;
			TabContent.AnchorPoint = Vector2.new(0.5, 0.5)
			TabContent.BackgroundTransparency = 1.000
			TabContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TabContent.BorderSizePixel = 0
			TabContent.Position = UDim2.new(0.5, 0, 0.5, 0)
			TabContent.Size = UDim2.new(1, -5,1, -5)
			TabContent.ZIndex = 6

			Left.Name = Compkiller:_RandomString()
			Left.Parent = TabContent
			Left.Active = true
			Left.AnchorPoint = Vector2.new(0.5, 0.5)
			Left.BackgroundTransparency = 1.000
			Left.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Left.BorderSizePixel = 0
			Left.ClipsDescendants = false
			Left.Position = UDim2.new(0.25, -3, 0.5, 0)
			Left.Size = UDim2.new(0.5, -3, 1, 0)
			Left.ZIndex = 8
			Left.BottomImage = ""
			Left.ScrollBarThickness = 0
			Left.TopImage = ""
			--Left.AutomaticCanvasSize = Enum.AutomaticSize.Y;
			Left.CanvasSize = UDim2.new(0, 0, 0, 0)

			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				Left.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y)
			end)

			UIListLayout.Parent = Left
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.VerticalFlex = Enum.UIFlexAlignment.None
			UIListLayout.Padding = UDim.new(0, BASE_PADDING)

			Right.Name = Compkiller:_RandomString()
			Right.Parent = TabContent
			Right.Active = true
			Right.AnchorPoint = Vector2.new(0.5, 0.5)
			Right.BackgroundTransparency = 1.000
			Right.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Right.BorderSizePixel = 0
			Right.ClipsDescendants = false
			Right.Position = UDim2.new(0.75, 3, 0.5, 0)
			Right.Size = UDim2.new(0.5, -3, 1, 0)
			Right.ZIndex = 8
			Right.BottomImage = ""
			--Right.AutomaticCanvasSize = Enum.AutomaticSize.Y;
			Right.CanvasSize = UDim2.new(0, 0, 0, 0)
			Right.ScrollBarThickness = 0
			Right.TopImage = ""

			Upvalue.Left = Left;
			Upvalue.Right = Right;
			Upvalue.LeftLayout = UIListLayout;
			Upvalue.RightLayout = UIListLayout_2;

			UIListLayout_2:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				Right.CanvasSize = UDim2.fromOffset(0,UIListLayout_2.AbsoluteContentSize.Y)
			end)

			UIListLayout_2.Parent = Right
			UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_2.Padding = UDim.new(0, BASE_PADDING)
			UIListLayout_2.VerticalFlex = Enum.UIFlexAlignment.None

			WindowArgs:AddUnbind(UIListLayout_2 , Right);
			WindowArgs:AddUnbind(UIListLayout , Left);

			if TabConfig.Type == "Single" then
				Right.Visible = false;
				Left.Position = UDim2.new(0.5, 0, 0.5, 0)
				Left.Size = UDim2.new(1,0,1,0)
			end;

			local Tween = TweenInfo.new(0.35,Enum.EasingStyle.Quint);

			Internal.Highlight:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
				if Internal.Highlight.BackgroundTransparency <= 0.99 then
					TabContent.Visible = true;
				else
					TabContent.Visible = false;
				end;

				if Compkiller.PerformanceMode then
					if TabContent.Visible then
						Compkiller:_SetNilP(TabContent , Internal.Parent);
					else
						Compkiller:_SetNilP(TabContent , nil);
					end;
				else
					Compkiller:_SetNilP(TabContent , Internal.Parent);
				end;
			end);

			Upvalue.Left = Left;
			Upvalue.Right = Right;

			if Compkiller:_IsMobile() then
				Compkiller:_AddDragBlacklist(Left);
				Compkiller:_AddDragBlacklist(Right);
			end;

			TabOpenSignal = Internal.Signal;

			if not TabOpenSignal:GetValue() then
				TabContent.Visible = false;
			else
				TabContent.Visible = true;
			end;

			if Compkiller.PerformanceMode then
				if TabContent.Visible then
					Compkiller:_SetNilP(TabContent , Internal.Parent);
				else
					Compkiller:_SetNilP(TabContent , nil);
				end;
			else
				Compkiller:_SetNilP(TabContent , Internal.Parent);
			end;
		else
			-- Button --
			local TabButton = Instance.new("Frame")
			local Icon = Instance.new("ImageLabel")
			local TabNameLabel = Instance.new("TextLabel")
			local Highlight = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")

			TabButton.Name = Compkiller:_RandomString()
			TabButton.Parent = TabButtonScrollingFrame
			TabButton.BackgroundTransparency = 1.000
			TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TabButton.BorderSizePixel = 0
			TabButton.ClipsDescendants = true
			TabButton.Size = UDim2.new(1, -10, 0, 32)
			TabButton.ZIndex = 3

			Icon.Name = Compkiller:_RandomString()
			Icon.Parent = TabButton
			Icon.AnchorPoint = Vector2.new(0, 0.5)
			Icon.BackgroundColor3 = Compkiller.Colors.Highlight
			Icon.BackgroundTransparency = 1.000
			Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Icon.BorderSizePixel = 0
			Icon.Position = UDim2.new(0, 15, 0.5, 0)
			Icon.Size = UDim2.new(0, 15, 0, 15)
			Icon.ZIndex = 3
			Icon.Image = Compkiller:_GetIcon(TabConfig.Icon);
			Icon.ImageColor3 = Compkiller.Colors.Highlight

			table.insert(Compkiller.Elements.Highlight,{
				Element = Icon,
				Property = "ImageColor3"
			});

			TabNameLabel.Name = Compkiller:_RandomString()
			TabNameLabel.Parent = TabButton
			TabNameLabel.AnchorPoint = Vector2.new(0, 0.5)
			TabNameLabel.BackgroundTransparency = 1.000
			TabNameLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TabNameLabel.BorderSizePixel = 0
			TabNameLabel.Position = UDim2.new(0, 43, 0.5, 0)
			TabNameLabel.Size = UDim2.new(0, 200, 0, 25)
			TabNameLabel.ZIndex = 3
			TabNameLabel.Font = Enum.Font.GothamMedium
			TabNameLabel.Text = TabConfig.Name;
			TabNameLabel.TextColor3 = Compkiller.Colors.SwitchColor
			TabNameLabel.TextSize = 15.000
			TabNameLabel.TextXAlignment = Enum.TextXAlignment.Left

			table.insert(Compkiller.Elements.SwitchColor , {
				Element = TabNameLabel,
				Property = 'TextColor3'
			});

			Highlight.Name = Compkiller:_RandomString()
			Highlight.Parent = TabButton
			Highlight.AnchorPoint = Vector2.new(0.5, 0.5)
			Highlight.BackgroundColor3 = Color3.fromRGB(161, 161, 161)
			Highlight.BackgroundTransparency = 0.925
			Highlight.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Highlight.BorderSizePixel = 0
			Highlight.Position = UDim2.new(0.5, 0, 0.5, 0)
			Highlight.Size = UDim2.new(1, -17, 1, 0)
			Highlight.ZIndex = 2

			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Highlight

			local TabContent = Instance.new("Frame")
			local Left = Instance.new("ScrollingFrame")
			local UIListLayout = Instance.new("UIListLayout")
			local Right = Instance.new("ScrollingFrame")
			local UIListLayout_2 = Instance.new("UIListLayout")

			TabContent.Name = Compkiller:_RandomString()
			TabContent.Parent = TabMainFrame;
			TabContent.AnchorPoint = Vector2.new(0.5, 0.5)
			TabContent.BackgroundTransparency = 1.000
			TabContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TabContent.BorderSizePixel = 0
			TabContent.Position = UDim2.new(0.5, 0, 0.5, 0)
			TabContent.Size = UDim2.new(1, -15, 1, -15)
			TabContent.ZIndex = 6

			Left.Name = Compkiller:_RandomString()
			Left.Parent = TabContent
			Left.Active = true
			Left.AnchorPoint = Vector2.new(0.5, 0.5)
			Left.BackgroundTransparency = 1.000
			Left.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Left.BorderSizePixel = 0
			Left.ClipsDescendants = false
			Left.Position = UDim2.new(0.25, -3, 0.5, 0)
			Left.Size = UDim2.new(0.5, -3, 1, 0)
			Left.ZIndex = 8
			Left.BottomImage = ""
			Left.ScrollBarThickness = 0
			Left.TopImage = ""
			--Left.AutomaticCanvasSize = Enum.AutomaticSize.Y;
			Left.CanvasSize = UDim2.new(0, 0, 0, 0)


			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				Left.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y)
			end);

			UIListLayout.Parent = Left
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.VerticalFlex = Enum.UIFlexAlignment.None
			UIListLayout.Padding = UDim.new(0, BASE_PADDING)

			Right.Name = Compkiller:_RandomString()
			Right.Parent = TabContent
			Right.Active = true
			Right.AnchorPoint = Vector2.new(0.5, 0.5)
			Right.BackgroundTransparency = 1.000
			Right.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Right.BorderSizePixel = 0
			Right.ClipsDescendants = false
			Right.Position = UDim2.new(0.75, 3, 0.5, 0)
			Right.Size = UDim2.new(0.5, -3, 1, 0)
			Right.ZIndex = 8
			Right.BottomImage = ""
			Right.ScrollBarThickness = 0
			Right.TopImage = ""
			--Right.AutomaticCanvasSize = Enum.AutomaticSize.Y;
			Right.CanvasSize = UDim2.new(0, 0, 0, 0)

			Upvalue.Left = Left;
			Upvalue.Right = Right;
			Upvalue.LeftLayout = UIListLayout;
			Upvalue.RightLayout = UIListLayout_2;

			UIListLayout_2:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				Right.CanvasSize = UDim2.fromOffset(0,UIListLayout_2.AbsoluteContentSize.Y)
			end)

			UIListLayout_2.Parent = Right
			UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_2.Padding = UDim.new(0, BASE_PADDING)
			UIListLayout_2.VerticalFlex = Enum.UIFlexAlignment.None

			WindowArgs:AddUnbind(UIListLayout_2 , Right);
			WindowArgs:AddUnbind(UIListLayout , Left);

			if Compkiller:_IsMobile() then
				Compkiller:_AddDragBlacklist(Left);
				Compkiller:_AddDragBlacklist(Right);
			end;

			if TabConfig.Type == "Single" then
				Right.Visible = false;
				Left.Position = UDim2.new(0.5, 0, 0.5, 0)
				Left.Size = UDim2.new(1, -1, 1, -1)
			end;

			local Tween = TweenInfo.new(0.35,Enum.EasingStyle.Quint);

			Highlight:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
				if Highlight.BackgroundTransparency <= 0.99 then
					TabContent.Visible = true;
				else
					TabContent.Visible = false;
				end;

				if Compkiller.PerformanceMode then
					if TabContent.Visible then
						Compkiller:_SetNilP(TabContent , TabMainFrame);
					else
						Compkiller:_SetNilP(TabContent , nil);
					end;
				else
					Compkiller:_SetNilP(TabContent , TabMainFrame);
				end;
			end)

			local TabOpen = function(bool)
				if bool then

					WindowArgs.SelectedTab = TabButton;

					Compkiller:_Animation(Icon,Tween,{
						ImageTransparency = 0,
					});

					Compkiller:_Animation(TabNameLabel,Tween,{
						TextTransparency = 0
					});

					Compkiller:_Animation(Highlight,Tween,{
						BackgroundTransparency = 0.925
					});
				else
					Compkiller:_Animation(Icon,Tween,{
						ImageTransparency = 0.5
					});

					Compkiller:_Animation(TabNameLabel,Tween,{
						TextTransparency = 0.5
					});

					Compkiller:_Animation(Highlight,Tween,{
						BackgroundTransparency = 1
					});
				end;
			end;

			if not WindowArgs.Tabs[1] then
				TabOpenSignal:Fire(true);
				TabOpen(true);
			else
				TabOpen(false);
			end;

			table.insert(WindowArgs.Tabs , {
				Root = TabButton,
				Remote = TabOpenSignal
			});

			Compkiller:_Hover(TabButton,function()
				if WindowArgs.SelectedTab ~= TabButton then
					Compkiller:_Animation(Icon,Tween,{
						ImageTransparency = 0.1
					});

					Compkiller:_Animation(TabNameLabel,Tween,{
						TextTransparency = 0.1
					});
				end;
			end , function()
				if WindowArgs.SelectedTab ~= TabButton then
					Compkiller:_Animation(Icon,Tween,{
						ImageTransparency = 0.5
					});

					Compkiller:_Animation(TabNameLabel,Tween,{
						TextTransparency = 0.5
					});
				end;
			end)

			TabOpenSignal:Connect(TabOpen);

			TabHover:Connect(function(bool)
				if bool then
					Compkiller:_Animation(TabButton,Tween,{
						Size = UDim2.new(1, -10, 0, 32)
					});

					Compkiller:_Animation(Icon,Tween,{
						Size = UDim2.new(0, 16, 0, 16),
					});

					Compkiller:_Animation(TabNameLabel,Tween,{
						Size = UDim2.new(0, 200, 0, 25),
						Position = UDim2.new(0, 43, 0.5, 0)
					});

					Compkiller:_Animation(UICorner,Tween,{
						CornerRadius = UDim.new(0, 4)
					});

					Compkiller:_Animation(Highlight,Tween,{
						Size = UDim2.new(1, -17, 1, 0),
						Position = UDim2.new(0.5, 0, 0.5, 0)
					});
				else
					Compkiller:_Animation(UICorner,Tween,{
						CornerRadius = UDim.new(0, 10)
					});

					Compkiller:_Animation(TabButton,Tween,{
						Size = UDim2.new(1, -10, 0, 32)
					});

					Compkiller:_Animation(Icon,Tween,{
						Size = UDim2.new(0, 16, 0, 16),
					});

					Compkiller:_Animation(TabNameLabel,Tween,{
						Size = UDim2.new(0, 200, 0, 25),
						Position = UDim2.new(0, 80, 0.5, 0)
					});

					Compkiller:_Animation(Highlight,Tween,{
						Size = UDim2.new(1, -10,1, 5),
						Position = UDim2.new(0.5, 0, 0.5, 0)
					});
				end;
			end);

			Compkiller:_Input(TabButton,function()
				for i,v in next, WindowArgs.Tabs do
					if v.Root == TabButton then
						v.Remote:Fire(true);
					else
						v.Remote:Fire(false);
					end;
				end;
			end);
		end;

		function TabArgs:_UpdateScrolling(Frame: ScrollingFrame , ListLayout: UIListLayout)
			local frame;

			local last = 0;
			local scale = 0;

			local Offset = ListLayout.Padding.Offset;
			local Childrens = Frame:GetChildren();

			for i,v in next ,Childrens do task.wait();
				if v:IsA('Frame') then
					if v.LayoutOrder > last then
						scale += v.AbsoluteSize.Y + Offset;

						last = v.LayoutOrder;
						frame = v;
					end;
				end;
			end;

			task.wait();

			if frame then
				local originalScale = frame:GetAttribute('OrigninalScale');

				if originalScale then
					task.wait();

					local Maximum = Frame.AbsoluteSize.Y;

					local remainingHeight = Maximum - ((scale) - (frame.AbsoluteSize.Y));

					if originalScale >= Frame.AbsoluteSize.Y then
						Frame:SetAttribute('LayoutStacks',originalScale + 5);
					else
						Frame:SetAttribute('LayoutStacks',((remainingHeight) + 5));
					end

					task.wait();

					local caller = WindowArgs.THREADS[frame];

					if caller then
						caller(true);
					end;
				end;
			end;

			task.wait();
		end;

		TabArgs.SectionInfo = {};

		TabArgs.SectionClose = {
			[Upvalue.Left] = {},
			[Upvalue.Right] = {},
		};

		TabArgs.LeftThread = coroutine.wrap(function()
			task.wait();

			while true do task.wait(0.01)
				TabArgs:_UpdateScrolling(Upvalue.Left , Upvalue.LeftLayout);
			end;
		end);

		TabArgs.RightThread = coroutine.wrap(function()
			task.wait(0.1);

			while true do task.wait(0.01)
				TabArgs:_UpdateScrolling(Upvalue.Right , Upvalue.RightLayout);
			end;
		end);

		--TabArgs.LeftThread();
		--TabArgs.RightThread();

		function TabArgs:DrawSection(config: Section)
			config = Compkiller.__CONFIG(config,{
				Name = "Section",
				Position = "left"
			});

			local Parent = (TabConfig.Type == "Double" and ((string.lower(config.Position) == "left" and Upvalue.Left) or Upvalue.Right)) or Upvalue.Left;
			local ParentLayout = (TabConfig.Type == "Double" and ((string.lower(config.Position) == "left" and Upvalue.LeftLayout) or Upvalue.RightLayout)) or Upvalue.LeftLayout;

			local IsOpen = true;

			local Section = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local UIListLayout = Instance.new("UIListLayout")
			local Header = Instance.new("Frame")
			local SectionText = Instance.new("TextLabel")
			local SectionClose = Instance.new("ImageLabel")

			Section.Name = Compkiller:_RandomString()
			Section.Parent = Parent;

			if TabConfig.Type == "Single" then
				Section.Parent = Upvalue.Left;
			end;

			Section.BackgroundColor3 = Compkiller.Colors.BlockColor

			table.insert(Compkiller.Elements.BlockColor , {
				Element = Section,
				Property = "BackgroundColor3"
			});

			if Compkiller:_IsMobile() then
				Compkiller:_AddDragBlacklist(Section);
			end;

			Section.LayoutOrder = #Parent:GetChildren() + 3;
			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section.BorderSizePixel = 0
			Section.Size = UDim2.new(1, 0, 0, 0)
			Section.ZIndex = 9
			Section.ClipsDescendants = true;

			UICorner.CornerRadius = UDim.new(0, 6)
			UICorner.Parent = Section

			UIStroke.Color = Compkiller.Colors.StrokeColor
			UIStroke.Parent = Section

			table.insert(Compkiller.Elements.StrokeColor,{
				Element = UIStroke,
				Property = "Color"
			});

			UIListLayout.Parent = Section
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)

			Header.Name = Compkiller:_RandomString()
			Header.Parent = Section
			Header.BackgroundTransparency = 1.000
			Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Header.BorderSizePixel = 0
			Header.LayoutOrder = -100
			Header.Size = UDim2.new(1, 0, 0, 35)
			Header.ZIndex = 9

			SectionText.Name = Compkiller:_RandomString()
			SectionText.Parent = Header
			SectionText.AnchorPoint = Vector2.new(0, 0.5)
			SectionText.BackgroundTransparency = 1.000
			SectionText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionText.BorderSizePixel = 0
			SectionText.Position = UDim2.new(0, 12, 0.5, 0)
			SectionText.Size = UDim2.new(0, 200, 0, 25)
			SectionText.ZIndex = 10
			SectionText.Font = Enum.Font.GothamMedium
			SectionText.Text = config.Name;
			SectionText.TextColor3 = Compkiller.Colors.SwitchColor
			SectionText.TextSize = 14.000
			SectionText.TextTransparency = 0.500
			SectionText.TextXAlignment = Enum.TextXAlignment.Left

			table.insert(Compkiller.Elements.SwitchColor , {
				Element = SectionText,
				Property = 'TextColor3'
			});

			SectionClose.Name = Compkiller:_RandomString()
			SectionClose.Parent = Header
			SectionClose.AnchorPoint = Vector2.new(1, 0.5)
			SectionClose.BackgroundTransparency = 1.000
			SectionClose.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionClose.BorderSizePixel = 0
			SectionClose.Position = UDim2.new(1, -12, 0.5, 0)
			SectionClose.Size = UDim2.new(0, 17, 0, 17)
			SectionClose.ZIndex = 10
			SectionClose.Image = Compkiller:CacheImage(GetAsset("109535175596957"))
			SectionClose.ImageTransparency = 0.500

			if not SectionText.Text:byte() then
				Header.Visible = false;
			else
				Header.Visible = true;
			end;

			TabArgs.SectionInfo[Section] = {
				UIListLayout = UIListLayout,
			};

			local refresh = function(Upvalue)
				if not SectionText.Text:byte() then
					Header.Visible = false;
				else
					Header.Visible = true;
				end;

				Section:SetAttribute('OrigninalScale',UIListLayout.AbsoluteContentSize.Y);

				if IsOpen then
					local FullScale = Section.AbsolutePosition.Y + UIListLayout.AbsoluteContentSize.Y;
					local RefPos = Parent.AbsolutePosition.Y + Parent.AbsoluteSize.Y;

					if (Section:GetAttribute('Height') and not Compkiller:_IsMobile() and FullScale <= RefPos) then
						Compkiller:_Animation(Section,TweenInfo.new(0.4,Enum.EasingStyle.Quint),{
							Size = UDim2.new(1, 0, 0, math.abs(Section:GetAttribute('Height')) + 5)
						});
					else
						Compkiller:_Animation(Section,TweenInfo.new(0.4,Enum.EasingStyle.Quint),{
							Size = UDim2.new(1, 0, 0, math.abs(UIListLayout.AbsoluteContentSize.Y) - 1)
						});

						if Section:GetAttribute('Lasth') and UIListLayout.AbsoluteContentSize.Y > Section:GetAttribute('Lasth') then
							Section:SetAttribute('Lasth',math.abs(UIListLayout.AbsoluteContentSize.Y) - 1);
						end;
					end;

					TabArgs.SectionClose[Parent][Section] = nil;
				else
					TabArgs.SectionClose[Parent][Section] = Section;

					Compkiller:_Animation(Section,TweenInfo.new(0.4,Enum.EasingStyle.Quint),{
						Size = UDim2.new(1, 0, 0, 35)
					});
				end;
			end;

			WindowArgs.THREADS[Section] = refresh;

			local refreshScale = function()
				local Childrens = Parent:GetChildren();
				local Latest = 0;
				local frameFound = 0;
				local allscale = 0;

				for i,v: Frame in next , Childrens do task.wait();
					if v:IsA('Frame') then
						if v ~= Section then
							frameFound += 1;
							allscale += v:GetAttribute('HEIGHTSCALE') or v.AbsoluteSize.Y;

							if v.LayoutOrder < Section.LayoutOrder then
								if WindowArgs.THREADS[v] then
									v:SetAttribute('Height',nil);
									WindowArgs.THREADS[v]();
								end;

								Latest += 1;
							end;
						end;
					end;
				end;

				if frameFound == 0 then
					Latest = math.huge;
				end;

				if Latest >= frameFound then
					local lscale = 25;

					if allscale >= (Parent.AbsoluteSize.Y - lscale) or UIListLayout.AbsoluteContentSize.Y >= (Parent.AbsoluteSize.Y - lscale) then
						Section:SetAttribute('Height',nil);
					else
						local parentScale = 0;

						for i,v in next , Parent:GetChildren() do
							if v:IsA('Frame') then
								parentScale += v:GetAttribute('HEIGHTSCALE') + ParentLayout.Padding.Offset;
							end;
						end;

						local remainingHeight = UIListLayout.AbsoluteContentSize.Y + (Parent.AbsoluteSize.Y - (parentScale));

						if Section:GetAttribute('Lasth') then
							remainingHeight = math.max(remainingHeight , Section:GetAttribute('Lasth'));
						end;

						Section:SetAttribute('Height',remainingHeight);
						Section:SetAttribute('Lasth',remainingHeight);
					end;
				else
					Section:SetAttribute('Height',nil);
				end;

				refresh();
			end;

			Section.ChildAdded:Connect(function()
				task.wait()
				refreshScale();
			end)

			Section:SetAttribute('HEIGHTSCALE',UIListLayout.AbsoluteContentSize.Y);

			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				Section:SetAttribute('HEIGHTSCALE',math.max(UIListLayout.AbsoluteContentSize.Y , Section:GetAttribute('HEIGHTSCALE')));

				refresh()
			end);

			TabOpenSignal:Connect(function(bool)
				if bool then
					Compkiller:_Animation(Section,TweenInfo.new(0.21),{
						BackgroundTransparency = 0
					})

					Compkiller:_Animation(SectionText,TweenInfo.new(0.21),{
						TextTransparency = 0.500
					})

					Compkiller:_Animation(SectionClose,TweenInfo.new(0.21),{
						ImageTransparency = 0.500
					})
				else
					Compkiller:_Animation(Section,TweenInfo.new(0.21),{
						BackgroundTransparency = 1
					})

					Compkiller:_Animation(SectionText,TweenInfo.new(0.21),{
						TextTransparency = 1
					})

					Compkiller:_Animation(SectionClose,TweenInfo.new(0.21),{
						ImageTransparency = 1
					})
				end;
			end);

			Compkiller:_Input(Header,function()
				IsOpen = not IsOpen;

				if IsOpen then
					Compkiller:_Animation(SectionClose,TweenInfo.new(0.35),{
						Rotation = 0
					});
				else
					Compkiller:_Animation(SectionClose,TweenInfo.new(0.35),{
						Rotation = -180
					});
				end;

				refresh();
				refreshScale();
			end);

			task.delay(2.5,function()
				refresh();
				refreshScale();
			end);

			Header.MouseEnter:Connect(function()
				Compkiller:_Animation(SectionText,TweenInfo.new(0.2),{
					TextTransparency = 0.25
				})
			end)	

			Header.MouseLeave:Connect(function()
				Compkiller:_Animation(SectionText,TweenInfo.new(0.2),{
					TextTransparency = 0.500
				})
			end)

			return Compkiller:_LoadElement(Section , true , TabOpenSignal)
		end;

		return TabArgs;
	end;

	do
		local CloseWindow = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local ImageLabel = Instance.new("ImageLabel")

		CloseWindow.Name = Compkiller:_RandomString()
		CloseWindow.Parent = CompKiller
		CloseWindow.AnchorPoint = Vector2.new(1, 0)
		CloseWindow.BackgroundColor3 = Compkiller.Colors.BGDBColor

		table.insert(Compkiller.Elements.BGDBColor,{
			Element = CloseWindow,
			Property = 'BackgroundColor3'
		});

		CloseWindow.BackgroundTransparency = 1
		CloseWindow.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CloseWindow.BorderSizePixel = 0
		CloseWindow.Position = UDim2.new(1, -10, 0, 10)
		CloseWindow.Size = UDim2.new(0, 0, 0, 23)
		CloseWindow.ZIndex = 150
		CloseWindow.ClipsDescendants = true;

		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = CloseWindow

		ImageLabel.Parent = CloseWindow
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ImageLabel.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
		ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
		ImageLabel.ZIndex = 151
		ImageLabel.Image = Config.Logo
		ImageLabel.ImageTransparency = 1
		ImageLabel.ClipsDescendants = false;

		local ToggleCloseUI = function(v)
			ImageLabel.Image = Config.Logo;

			if v then
				ImageLabel.ClipsDescendants = true;

				Compkiller:_Animation(CloseWindow,TweenInfo.new(0.2),{
					Size = UDim2.new(0, 45, 0, 23),
					BackgroundTransparency = 0.025
				})

				Compkiller:_Animation(ImageLabel,TweenInfo.new(0.2),{
					ImageTransparency = (ImageLabel:GetAttribute('Hover') and 0.1) or 0.35
				})
			else
				ImageLabel.ClipsDescendants = false;

				Compkiller:_Animation(CloseWindow,TweenInfo.new(0.2),{
					Size = UDim2.new(0, 0, 0, 23),
					BackgroundTransparency = 1
				})

				Compkiller:_Animation(ImageLabel,TweenInfo.new(0.2),{
					ImageTransparency = 1
				})
			end;
		end;

		function WindowArgs:Watermark()
			local Signal = Compkiller.__SIGNAL(true);

			local Watermark = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Logo = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local Frame = Instance.new("Frame")
			local CompLogo = Instance.new("ImageLabel")
			local WaternarkList = Instance.new("Frame")
			local UIListLayout = Instance.new("UIListLayout")

			Watermark.Name = Compkiller:_RandomString()
			Watermark.Parent = CompKiller
			Watermark.AnchorPoint = Vector2.new(1, 0)
			Watermark.BackgroundColor3 = Compkiller.Colors.BGDBColor

			Compkiller:Drag(Watermark , Watermark, 0.1);

			table.insert(Compkiller.Elements.BGDBColor,{
				Element = Watermark,
				Property = 'BackgroundColor3'
			});

			Watermark.BackgroundTransparency = 0.025
			Watermark.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Watermark.BorderSizePixel = 0
			Watermark.Position = UDim2.new(1, -10, 0, 10)
			Watermark.Size = UDim2.new(0, 45, 0, 23)
			Watermark.ZIndex = 150

			UICorner.CornerRadius = UDim.new(0, 3)
			UICorner.Parent = Watermark

			Logo.Name = Compkiller:_RandomString()
			Logo.Parent = Watermark
			Logo.AnchorPoint = Vector2.new(1, 0.5)
			Logo.BackgroundColor3 = Compkiller.Colors.BGDBColor

			table.insert(Compkiller.Elements.BGDBColor,{
				Element = Logo,
				Property = 'BackgroundColor3'
			});

			Logo.BackgroundTransparency = 0.300
			Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Logo.BorderSizePixel = 0
			Logo.Position = UDim2.new(0, 5, 0.5, 0)
			Logo.Size = UDim2.new(1, 10, 1, 0)
			Logo.SizeConstraint = Enum.SizeConstraint.RelativeYY
			Logo.ZIndex = 149

			UICorner_2.CornerRadius = UDim.new(0, 3)
			UICorner_2.Parent = Logo

			Frame.Parent = Logo
			Frame.AnchorPoint = Vector2.new(0, 0.5)
			Frame.BackgroundColor3 = Compkiller.Colors.Highlight
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Position = UDim2.new(1, -5, 0.5, 0)
			Frame.Size = UDim2.new(0, 2, 1, 0)
			Frame.ZIndex = 151

			table.insert(Compkiller.Elements.Highlight,{
				Element = Frame,
				Property = "BackgroundColor3"
			});

			CompLogo.Name = Compkiller:_RandomString()
			CompLogo.Parent = Logo
			CompLogo.AnchorPoint = Vector2.new(0.5, 0.5)
			CompLogo.BackgroundTransparency = 1.000
			CompLogo.BorderColor3 = Color3.fromRGB(0, 0, 0)
			CompLogo.BorderSizePixel = 0
			CompLogo.Position = UDim2.new(0.5, -2, 0.5, 0)
			CompLogo.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
			CompLogo.SizeConstraint = Enum.SizeConstraint.RelativeYY
			CompLogo.ZIndex = 159
			CompLogo.Image = Config.Logo
			
			if Compkiller.CustomHighlightMode then
				CompLogo.ImageColor3 = Compkiller.Colors.Highlight;

				table.insert(Compkiller.Elements.Highlight , {
					Element = CompLogo,
					Property = 'ImageColor3'
				});
			end;

			WaternarkList.Name = Compkiller:_RandomString()
			WaternarkList.Parent = Watermark
			WaternarkList.AnchorPoint = Vector2.new(0.5, 0)
			WaternarkList.BackgroundTransparency = 1.000
			WaternarkList.BorderColor3 = Color3.fromRGB(0, 0, 0)
			WaternarkList.BorderSizePixel = 0
			WaternarkList.Position = UDim2.new(0.5, 0, 0, 0)
			WaternarkList.Size = UDim2.new(1, -10, 1, 0)
			WaternarkList.ZIndex = 155
			WaternarkList.ClipsDescendants = true

			UIListLayout.Parent = WaternarkList
			UIListLayout.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			UIListLayout.Padding = UDim.new(0, 3)

			local BackFrame = Instance.new("Frame")

			BackFrame.Name = Compkiller:_RandomString()
			BackFrame.Parent = Watermark
			BackFrame.AnchorPoint = Vector2.new(1, 0.5)
			BackFrame.BackgroundTransparency = 1.000
			BackFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			BackFrame.BorderSizePixel = 0
			BackFrame.Position = UDim2.new(1, 0, 0.5, 0)
			BackFrame.Size = UDim2.new(1, 30, 1, 0)

			Compkiller:_Blur(BackFrame,Signal);

			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				Compkiller:_Animation(Watermark,TweenInfo.new(0.4),{
					Size = UDim2.new(0, UIListLayout.AbsoluteContentSize.X + 8, 0, 23)
				});
			end)

			local Args = {};

			function Args:AddText(Watermark : Watermark)
				Watermark = Compkiller.__CONFIG(Watermark, {
					Text = "Watermark",
					Icon = "info"
				});

				local Icon = Instance.new("ImageLabel")
				local TextLabel = Instance.new("TextLabel")

				Icon.Name = Compkiller:_RandomString()
				Icon.Parent = WaternarkList
				Icon.BackgroundTransparency = 1.000
				Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Icon.BorderSizePixel = 0
				Icon.Size = UDim2.fromOffset(15,15)
				Icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
				Icon.ZIndex = 156
				Icon.Image = Compkiller:_GetIcon(Watermark.Icon);

				TextLabel.Parent = WaternarkList
				TextLabel.BackgroundTransparency = 1.000
				TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextLabel.BorderSizePixel = 0
				TextLabel.Size = UDim2.new(0, 50, 0.699999988, 0)
				TextLabel.ZIndex = 156
				TextLabel.Font = Enum.Font.GothamMedium
				TextLabel.Text = Watermark.Text
				TextLabel.TextColor3 = Compkiller.Colors.SwitchColor
				TextLabel.TextSize = 10.000
				TextLabel.TextXAlignment = Enum.TextXAlignment.Left

				table.insert(Compkiller.Elements.SwitchColor , {
					Element = TextLabel,
					Property = 'TextColor3'
				});

				local Update = function()
					local scale = TextService:GetTextSize(TextLabel.Text,TextLabel.TextSize,TextLabel.Font,Vector2.new(math.huge,math.huge));

					TextLabel.Size = UDim2.new(0, scale.X + 2, 0.7, 0)
				end;

				Update()

				local Arg = {};

				function Arg:SetText(text)
					TextLabel.Text = text;
					Update();
				end;

				function Arg:Visible(v)
					Icon.Visible = v;
					TextLabel.Visible = v;

					if Compkiller.PerformanceMode then
						if v then
							Compkiller:_SetNilP(Icon , WaternarkList);
							Compkiller:_SetNilP(TextLabel , WaternarkList);
						else
							Compkiller:_SetNilP(Icon , nil);
							Compkiller:_SetNilP(TextLabel , nil);
						end;
					else
						Compkiller:_SetNilP(Icon , WaternarkList);
						Compkiller:_SetNilP(TextLabel , WaternarkList);
					end;
				end;

				return Arg;
			end;

			return Args;
		end;

		function WindowArgs:Toggle(Value: boolean)
			if WindowArgs.PerformanceMode then
				MainFrame.Visible = Value;
			end;

			WindowOpen:Fire(Value);

			if Value then
				for i,v in next , WindowArgs.Tabs do
					if v.Root == WindowArgs.SelectedTab then
						v.Remote:Fire(true);
					end;
				end;
			else
				for i,v in next , WindowArgs.Tabs do
					v.Remote:Fire(false);
				end;
			end;
		end;

		function WindowArgs:_ToggleUI()
			WindowArgs.IsOpen = not WindowArgs.IsOpen;

			WindowArgs:Toggle(WindowArgs.IsOpen)
		end;

		local Button = Compkiller:_Input(CloseWindow,function()
			WindowArgs:_ToggleUI()
		end)

		if not Compkiller:_IsMobile() then

			Compkiller:_Hover(Button,function()
				ImageLabel:SetAttribute("Hover",true);
			end , function()
				ImageLabel:SetAttribute("Hover",false);
			end);
		end;

		table.insert(WindowArgs.THREADS,task.spawn(function()
			while true do task.wait(0.15)
				if Compkiller:_IsMobile() then
					ToggleCloseUI(true);

					if WindowArgs.IsOpen then
						Compkiller:_Animation(ImageLabel,TweenInfo.new(0.2),{
							ImageTransparency = 0.35
						});

						ImageLabel:GetAttribute("Hover",false);
					else
						ImageLabel:GetAttribute("Hover",true);

						Compkiller:_Animation(ImageLabel,TweenInfo.new(0.2),{
							ImageTransparency = 0.1
						});
					end;
				else
					if not WindowArgs.IsOpen then
						ToggleCloseUI(true);
					else
						ToggleCloseUI(false);
					end
				end;
			end
		end));

		UserInputService.InputBegan:Connect(function(Input,Typing)
			if not Typing and (Input.KeyCode == Config.Keybind or Input.KeyCode.Name == Config.Keybind) then
				WindowArgs:_ToggleUI()
			end;
		end);
	end;

	function WindowArgs:SetMenuKey(new: string | Enum.KeyCode)
		Config.Keybind = new;
	end;

	function WindowArgs:Update(config: WindowUpdate)
		config = config or {};
		config.Logo = config.Logo or Config.Logo;
		config.Username = config.Username or LocalPlayer.DisplayName;
		config.ExpireDate = config.ExpireDate or "NEVER";
		config.WindowName = config.WindowName or Config.Name;
		config.UserProfile = config.UserProfile or WindowArgs.Profile or string.format("rbxthumb://type=AvatarHeadShot&id=%s&w=150&h=150",tostring(LocalPlayer.UserId));

		if Compkiller.SecureMode and string.find(config.UserProfile, "rbxassetid://",1,true) then
			config.UserProfile = Compkiller:_GetIcon("user");
		end;

		UserText.Text = config.Username;
		CompLogo.Image = config.Logo;
		ExpireText.Text = config.ExpireDate;
		WindowLabel.Text = config.WindowName;
		UserProfile.Image = config.UserProfile;
		WindowArgs.Username = config.Username;

		Config.Logo = config.Logo or Config.Logo;
		WindowArgs.Username = config.Username or WindowArgs.Username;
		WindowArgs.ExipreDate = config.ExpireDate or WindowArgs.ExipreDate;
		Config.Name = config.WindowName or Config.Name;
		WindowArgs.Profile = config.UserProfile or WindowArgs.Profile;
	end;

	WindowArgs.LOOP_THREAD = task.spawn(function()
		local TimeTic = tick();

		local BlurElement = Instance.new("Frame")

		BlurElement.Name = Compkiller:_RandomString()
		BlurElement.Parent = MainFrame
		BlurElement.AnchorPoint = Vector2.new(1, 0.5)
		BlurElement.BackgroundTransparency = 1.000
		BlurElement.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BlurElement.BorderSizePixel = 0
		BlurElement.Position = UDim2.new(1, -5, 0.5, 0)
		BlurElement.Size = UDim2.new(1, 0, 1, 0)
		BlurElement.ZIndex = -100
		BlurElement.Active = true

		Compkiller:_Blur(BlurElement , WindowOpen);

		local MovementFrame = Instance.new("Frame")

		MovementFrame.Name = Compkiller:_RandomString()
		MovementFrame.Parent = MainFrame
		MovementFrame.AnchorPoint = Vector2.new(1, 0.5)
		MovementFrame.BackgroundTransparency = 1.000
		MovementFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MovementFrame.BorderSizePixel = 0
		MovementFrame.Position = UDim2.new(1, 0, 0.5, 0)
		MovementFrame.Size = UDim2.new(1, 0, 1, 0)
		MovementFrame.ZIndex = 9

		Compkiller:Drag(MovementFrame,MainFrame,0.1)

		SelectionFrame.Position = UDim2.new(1, 5, 0, 28)
		SelectionFrame.Size = UDim2.new(0, 8, 0, 22)

		table.insert(Compkiller.Elements.Highlight,{
			Element = SelectionFrame,
			Property = "BackgroundColor3"
		});

		while true do task.wait(0.01);
			BlurElement.Size = UDim2.new(1, TabFrame.AbsoluteSize.X - 35, 1, 0);
			MovementFrame.Size = UDim2.new(1, TabFrame.AbsoluteSize.X - 35, 1, 0);

			SelectionFrame.BackgroundColor3 = Compkiller.Colors.Highlight;

			if WindowArgs.SelectedTab and WindowArgs.IsOpen then
				local vili = -(TabButtons.AbsolutePosition.Y - WindowArgs.SelectedTab.AbsolutePosition.Y) + 4;
				local distance = (SelectionFrame.Position.Y.Offset - vili);

				if vili < 0 or vili > TabButtons.AbsoluteSize.Y then
					Compkiller:_Animation(SelectionFrame , TweenInfo.new(0.1) , {
						BackgroundTransparency = 1
					});
				else
					if math.abs(distance) <= 10 then
						Compkiller:_Animation(SelectionFrame , TweenInfo.new(0.1) , {
							BackgroundTransparency = 0
						});

						SelectionFrame.Position = UDim2.new(1,5,0,math.ceil(vili));
					else
						Compkiller:_Animation(SelectionFrame , TweenInfo.new(0.15) , {
							BackgroundTransparency = 0,
							Position = UDim2.new(1,5,0,math.ceil(vili))
						});
					end;
				end;
			else
				Compkiller:_Animation(SelectionFrame , TweenInfo.new(0.15) , {
					BackgroundTransparency = 1
				});
			end;

			if WindowArgs.AlwayShowTab then
				TabHover:Fire(true);
			end;
		end;
	end);

	WindowArgs:Update();

	local OldDelayThread;
	local DurationTime = tick();

	Compkiller:_Hover(TabFrame , function()
		if OldDelayThread then
			task.cancel(OldDelayThread);
			OldDelayThread = nil;
		end;

		if WindowArgs.AlwayShowTab then
			return;
		end;

		DurationTime = tick();

		TabHover:Fire(true);
	end , function()
		if OldDelayThread then
			task.cancel(OldDelayThread);
			OldDelayThread = nil;
		end;

		if WindowArgs.AlwayShowTab then
			return;
		end;

		OldDelayThread = task.delay(math.clamp((tick() - DurationTime) , 0.01,5),function()
			if TabHover:GetValue() then
				TabHover:Fire(false);
			end
		end);
	end);

	return WindowArgs;
end;

function Compkiller:GetDate(Time)
	Time = Time or tick();

	local val = os.date('*t',Time);

	return string.format("%s/%s/%s",val.day,val.month,val.year);
end;

function Compkiller:GetTimeNow(Time)
	Time = Time or tick();

	local val = os.date('*t',Time);

	return string.format("%s:%s:%s",val.hour,val.min,val.sec);
end;

function Compkiller:GetConfig(Type: string)
	local ConfigFlags = {};

	for i,v in next , Compkiller.Flags do
		local Value = v:GetValue();
		local Suf = {};

		if typeof(Value) == "table" and Value.ColorPicker and typeof(Value.ColorPicker) == 'table' then
			Suf.Color3 = {
				R = Value.ColorPicker.Color.R,
				G = Value.ColorPicker.Color.G,
				B = Value.ColorPicker.Color.B
			};

			Suf.Transparency = Value.ColorPicker.Transparency;

			Suf.Type = "ColorPicker";
		else
			Suf.Value = Value;
			Suf.Type = "NormalElement";
		end;

		if Type == "KV" then
			ConfigFlags[v.Flag] = {
				Flag = v.Flag,
				Value = Suf,
				Functions = v,
				AutoKeybind = (v.AutoKeybind and v.AutoKeybind:GetSettings());
			}
		elseif Type == "MK" then
			ConfigFlags[v.Flag] = {
				Flag = v.Flag,
				Value = Suf,
				AutoKeybind = (v.AutoKeybind and v.AutoKeybind:GetSettings());
			}
		else
			table.insert(ConfigFlags , {
				Flag = v.Flag,
				Value = Suf,
				AutoKeybind = (v.AutoKeybind and v.AutoKeybind:GetSettings());
			})
		end;
	end;

	return ConfigFlags;
end;

function Compkiller:_Path(...)
	local args = {...};

	return table.concat(args, "/");
end;

function Compkiller:ConfigManager(ConfigManager: ConfigManager) : ConfigFunctions
	ConfigManager = Compkiller.__CONFIG(ConfigManager , {
		Directory = "Compkiller",
		Config = "Software"
	});

	if not isfolder(ConfigManager.Directory) then
		makefolder(ConfigManager.Directory);
	end;

	if not isfolder(Compkiller:_Path(ConfigManager.Directory , ConfigManager.Config)) then
		makefolder(Compkiller:_Path(ConfigManager.Directory , ConfigManager.Config));
	end;

	local Args = {
		Directory = Compkiller:_Path(ConfigManager.Directory , ConfigManager.Config);
		EnableNotify = false,
	};

	local notify = Compkiller.newNotify();

	function Args:WriteConfig(Config: WriteConfig)
		Config = Compkiller.__CONFIG(Config , {
			Name = Compkiller:_RandomString(),
			Author = LocalPlayer.Name,
		});

		local Flags = Compkiller:GetConfig("MK");

		Flags["__INFORMATION"] = {
			Type = "Information",
			Author = Config.Author,
			Name = Config.Name,
			CreatedDate = Compkiller:GetDate()
		};

		if Args.EnableNotify then
			notify.new({
				Title = "Configs",
				Icon = Compkiller:_GetIcon('settings'),
				Content = "Create config \""..Config.Name.."\""
			})
		end

		writefile(Compkiller:_Path(Args.Directory , Config.Name) , HttpService:JSONEncode(Flags));
	end;

	function Args:LoadConfigFromString(str: string)
		local decoded = HttpService:JSONDecode(str);

		local Flags = Compkiller:GetConfig("KV");

		for i,v in next , decoded do
			if v and v.Flag then

				local Value = Flags[v.Flag];

				if Value then

					if v.Value.Type == "NormalElement" then
						Value.Functions:SetValue(v.Value.Value);

					elseif v.Value.Type == "ColorPicker" then

						local Color = Color3.new(v.Value.Color3.R,v.Value.Color3.G,v.Value.Color3.B);

						local Transparency = v.Value.Transparency;

						Value.Functions:SetValue(Color , Transparency);
					end;
				end;
			end
		end;
	end;

	function Args:GetCurrentConfig()
		return Compkiller:GetConfig("MK")
	end;

	function Args:ReadInfo(ConfigName: string)
		local _path = Compkiller:_Path(Args.Directory , ConfigName);

		if isfile(_path) then
			local info = readfile(_path);

			local decoded = HttpService:JSONDecode(info);

			return decoded.__INFORMATION;
		end;

		return false;
	end;

	function Args:GetConfigs()
		local names = {};

		for i,v in next , listfiles(Args.Directory) do
			local Name = string.sub(v , #Args.Directory + 2);

			table.insert(names , Name);
		end;

		return names;
	end;

	function Args:GetFullConfigs()
		local names = {};

		for i,v in next , listfiles(Args.Directory) do
			local Name = string.sub(v , #Args.Directory + 2);
			local Info = Args:ReadInfo(Name);

			table.insert(names , {
				Name = Name,
				Info = Info,
			});
		end;

		return names;
	end;

	function Args:DeleteConfig(ConfigName)
		local _path = Compkiller:_Path(Args.Directory,ConfigName);

		if Args.EnableNotify then
			notify.new({
				Title = "Configs",
				Icon = Compkiller:_GetIcon('settings'),
				Content = "Delete config \""..ConfigName.."\""
			})
		end

		if isfile(_path) then
			delfile(_path);
		end;
	end;

	function Args:GetConfigCount()
		return #listfiles(Args.Directory);
	end;

	function Args:LoadConfig(ConfigName: string)
		local _path = Compkiller:_Path(Args.Directory,ConfigName);

		if isfile(_path) then
			local info = readfile(_path);

			local decoded = HttpService:JSONDecode(info);

			local Flags = Compkiller:GetConfig("KV");

			if Args.EnableNotify then
				notify.new({
					Title = "Configs",
					Icon = Compkiller:_GetIcon('settings'),
					Content = "Load config \""..ConfigName.."\""
				})
			end

			for i,v in next , decoded do
				if v and v.Flag then

					local Value = Flags[v.Flag];

					if Value then

						if v.Value.Type == "NormalElement" then
							Value.Functions:SetValue(v.Value.Value);

						elseif v.Value.Type == "ColorPicker" then

							local Color = Color3.new(v.Value.Color3.R,v.Value.Color3.G,v.Value.Color3.B);

							local Transparency = v.Value.Transparency;

							Value.Functions:SetValue(Color , Transparency);
						end;

						if Value.Functions.AutoKeybind then
							if v.AutoKeybind then
								Value.Functions.AutoKeybind:LoadSettings(v.AutoKeybind)
							end;
						end;
					end;
				end
			end;
		end;
	end;

	return Args;
end;

function Compkiller:Loader(IconId,Duration)
	local CompKiller = Instance.new("ScreenGui")

	CompKiller.Name = Compkiller:_RandomString()
	CompKiller.Parent = CoreGui
	CompKiller.Enabled = true
	CompKiller.ResetOnSpawn = false
	CompKiller.IgnoreGuiInset = true
	CompKiller.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local Loader = Instance.new("Frame")
	local Icon = Instance.new("ImageLabel")
	local Vignette = Instance.new("ImageLabel")

	Loader.Name = Compkiller:_RandomString()
	Loader.Parent = CompKiller
	Loader.AnchorPoint = Vector2.new(0.5, 0.5)
	Loader.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Loader.BackgroundTransparency = 1
	Loader.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Loader.BorderSizePixel = 0
	Loader.Position = UDim2.new(0.5, 0, 0.5, 0)
	Loader.Size = UDim2.new(1, 0, 1, 0)

	Icon.Name = Compkiller:_RandomString()
	Icon.Parent = Loader
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.BackgroundTransparency = 1.000
	Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Icon.BorderSizePixel = 0
	Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon.Size = UDim2.new(0, 750, 0, 750)
	Icon.ZIndex = 100
	Icon.Image = IconId or Compkiller.Logo;
	Icon.ImageTransparency = 1

	Vignette.Name = Compkiller:_RandomString()
	Vignette.Parent = Loader
	Vignette.BackgroundTransparency = 1.000
	Vignette.BorderColor3 = Color3.fromRGB(27, 42, 53)
	Vignette.BorderSizePixel = 0
	Vignette.Size = UDim2.new(1, 0, 1, 0)
	Vignette.Image = Compkiller:CacheImage(GetAsset("18720640102"))
	Vignette.ImageColor3 = Compkiller.Colors.Highlight
	Vignette.ImageTransparency = 1
	Vignette.AnchorPoint = Vector2.new(0.5,0.5)
	Vignette.Position = UDim2.fromScale(0.5,0.5)

	Compkiller:_Animation(Loader,TweenInfo.new(0.55,Enum.EasingStyle.Quint),{
		BackgroundTransparency = 0.5
	});

	local Event = Instance.new('BindableEvent');

	task.delay(0.5,function()
		Compkiller:_Animation(Icon,TweenInfo.new(0.75,Enum.EasingStyle.Quint),{
			ImageTransparency = 0.01,
			Size = UDim2.new(0, 200, 0, 200)
		});

		task.delay(0.25,function()
			Compkiller:_Animation(Vignette,TweenInfo.new(5),{
				ImageTransparency = 0.2
			});

			task.wait(Duration or 4.5)

			Compkiller:_Animation(Vignette,TweenInfo.new(3,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				Size = UDim2.new(2, 0, 2, 0)
			});

			Compkiller:_Animation(Icon,TweenInfo.new(0.75,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				ImageTransparency = 1,
			});

			Compkiller:_Animation(Loader,TweenInfo.new(1.5,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				BackgroundTransparency = 1
			});

			task.delay(0.1,function()
				Compkiller:_Animation(Vignette,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
					ImageTransparency = 1
				});

				task.wait(0.2)

				task.delay(3,function()
					CompKiller:Destroy();
				end)
			end)

			task.delay(0.6,function()
				Event:Fire();
			end)
		end)
	end);

	return {
		yield = function()
			return Event.Event:Wait();
		end	
	};
end;

function Compkiller.newNotify()
	if Compkiller.NOTIFY_CACHE then
		return Compkiller.NOTIFY_CACHE;
	end;

	local Notification = Instance.new("ScreenGui")
	local NotifyContainer = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Notification.Name = Compkiller:_RandomString()
	Notification.Parent = CoreGui;
	Notification.ResetOnSpawn = false
	Notification.ZIndexBehavior = Enum.ZIndexBehavior.Global

	NotifyContainer.Name = Compkiller:_RandomString()
	NotifyContainer.Parent = Notification
	NotifyContainer.AnchorPoint = Vector2.new(1, 0)
	NotifyContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NotifyContainer.BackgroundTransparency = 1.000
	NotifyContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NotifyContainer.BorderSizePixel = 0
	NotifyContainer.Position = UDim2.new(1, -10, 0, 1)
	NotifyContainer.Size = UDim2.new(0, 100, 0, 100)

	UIListLayout.Parent = NotifyContainer
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 3)

	local LayoutREF = 0;

	Compkiller.NOTIFY_CACHE = {
		new = function(Notify: Notify) : NotifyPayback
			Notify = Compkiller.__CONFIG(Notify, {
				Icon = Compkiller.Logo,
				Title = "Notification",
				Content = "Content",
				Duration = 3,
			});

			LayoutREF -= 5;

			local BlockFrame = Instance.new("Frame")
			local NotifyFrame = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local CompLogo = Instance.new("ImageLabel")
			local Header = Instance.new("TextLabel")
			local Body = Instance.new("TextLabel")
			local TimeLeftFrame = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local TimeLeft = Instance.new("Frame")
			local UICorner_3 = Instance.new("UICorner")

			BlockFrame.Name = Compkiller:_RandomString()
			BlockFrame.Parent = NotifyContainer
			BlockFrame.AnchorPoint = Vector2.new(1, 0)
			BlockFrame.BackgroundColor3 = Compkiller.Colors.BGDBColor
			BlockFrame.BackgroundTransparency = 1.000
			BlockFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			BlockFrame.BorderSizePixel = 0
			BlockFrame.ClipsDescendants = false
			BlockFrame.Size = UDim2.new(0, 200, 0, 0)
			BlockFrame.LayoutOrder = LayoutREF;


			NotifyFrame.Name = Compkiller:_RandomString()
			NotifyFrame.Parent = BlockFrame
			NotifyFrame.BackgroundColor3 = Compkiller.Colors.BGDBColor
			NotifyFrame.BackgroundTransparency = 0.100
			NotifyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NotifyFrame.BorderSizePixel = 0
			NotifyFrame.ClipsDescendants = false
			NotifyFrame.Size = UDim2.new(1, 0, 1, -5)
			NotifyFrame.ZIndex = 2
			NotifyFrame.Position = UDim2.new(1,200,0,0)


			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = NotifyFrame

			CompLogo.Name = Compkiller:_RandomString()
			CompLogo.Parent = NotifyFrame
			CompLogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			CompLogo.BackgroundTransparency = 1.000
			CompLogo.BorderColor3 = Color3.fromRGB(0, 0, 0)
			CompLogo.BorderSizePixel = 0
			CompLogo.Position = UDim2.new(0, 6, 0, 6)
			CompLogo.Size = UDim2.new(0, 25, 0, 25)
			CompLogo.ZIndex = 4

			if string.find(Notify.Icon,'cache-ck-',1,true) then	
				CompLogo.Image = Notify.Icon;
			else
				CompLogo.Image = Compkiller:_GetIcon(Notify.Icon);
			end;

			if Compkiller.CustomHighlightMode then
				CompLogo.ImageColor3 = Compkiller.Colors.Highlight;
			end;
			
			Header.Name = Compkiller:_RandomString()
			Header.Parent = NotifyFrame
			Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Header.BackgroundTransparency = 1.000
			Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Header.BorderSizePixel = 0
			Header.Position = UDim2.new(0, 40, 0, 10)
			Header.Size = UDim2.new(1, -50, 0, 15)
			Header.ZIndex = 3
			Header.Font = Enum.Font.GothamBold
			Header.Text = Notify.Title
			Header.TextColor3 = Compkiller.Colors.SwitchColor
			Header.TextSize = 14.000
			Header.TextXAlignment = Enum.TextXAlignment.Left

			Body.Name = Compkiller:_RandomString()
			Body.Parent = NotifyFrame
			Body.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Body.BackgroundTransparency = 1.000
			Body.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Body.BorderSizePixel = 0
			Body.Position = UDim2.new(0, 10, 0, 33)
			Body.Size = UDim2.new(1, -15, 0, 30)
			Body.ZIndex = 3
			Body.Font = Enum.Font.GothamMedium
			Body.Text = Notify.Content
			Body.TextColor3 = Compkiller.Colors.SwitchColor
			Body.TextSize = 12.000
			Body.TextTransparency = 0.500
			Body.TextXAlignment = Enum.TextXAlignment.Left
			Body.TextYAlignment = Enum.TextYAlignment.Top

			TimeLeftFrame.Name = Compkiller:_RandomString()
			TimeLeftFrame.Parent = NotifyFrame
			TimeLeftFrame.AnchorPoint = Vector2.new(0, 1)
			TimeLeftFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TimeLeftFrame.BackgroundTransparency = 1.000
			TimeLeftFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TimeLeftFrame.BorderSizePixel = 0
			TimeLeftFrame.Position = UDim2.new(0, 0, 1, 1)
			TimeLeftFrame.Size = UDim2.new(1, 0, 0, 5)
			TimeLeftFrame.ZIndex = 5

			UICorner_2.CornerRadius = UDim.new(0, 4)
			UICorner_2.Parent = TimeLeftFrame

			TimeLeft.Name = Compkiller:_RandomString()
			TimeLeft.Parent = TimeLeftFrame
			TimeLeft.BackgroundColor3 = Compkiller.Colors.Highlight
			TimeLeft.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TimeLeft.BorderSizePixel = 0
			TimeLeft.Size = UDim2.new(0, 0, 1, 0)
			TimeLeft.ZIndex = 5

			UICorner_3.CornerRadius = UDim.new(0, 1)
			UICorner_3.Parent = TimeLeft

			local UpdateText = function()
				local TitleScale = TextService:GetTextSize(Header.Text,Header.TextSize,Header.Font,Vector2.new(math.huge,math.huge));
				local BodyScale = TextService:GetTextSize(Body.Text,Body.TextSize,Body.Font,Vector2.new(math.huge,math.huge));

				local MainX = (TitleScale.X >= BodyScale.X and TitleScale.X) or BodyScale.X;
				local MainY = TitleScale.Y + ((Body.Text:byte() and BodyScale.Y) or 1);

				if BlockFrame:GetAttribute('Already') then
					Compkiller:_Animation(BlockFrame,TweenInfo.new(0.3),{
						Size = UDim2.new(0,MainX + 55,0,MainY + 35)
					});
				else
					BlockFrame:SetAttribute('Already',true)
					BlockFrame.Size = UDim2.new(0, MainX + 45, 0, 0);

					Compkiller:_Animation(BlockFrame,TweenInfo.new(0.3),{
						Size = UDim2.new(0,MainX + 55,0,MainY + 35)
					});
				end;
			end;

			UpdateText();

			local Close = function()
				Compkiller:_Animation(NotifyFrame,TweenInfo.new(0.65,Enum.EasingStyle.Quint),{
					Position = UDim2.new(1,200,0,0)
				});

				task.wait(0.3);

				Compkiller:_Animation(BlockFrame,TweenInfo.new(0.3),{
					Size = UDim2.new(1,0,0,0)
				});

				task.wait(0.35)
				BlockFrame:Destroy();

			end;

			local Show = function()
				Compkiller:_Animation(NotifyFrame,TweenInfo.new(0.5,Enum.EasingStyle.Quint),{
					Position = UDim2.new(0,0,0,0)
				});
			end;

			if typeof(Notify.Duration) == 'number' and Notify.Duration ~= math.huge then
				Compkiller:_Animation(TimeLeft,TweenInfo.new(Notify.Duration + 0.2,Enum.EasingStyle.Linear),{
					Size = UDim2.new(1, 0, 1, 0)
				});

				return task.delay(0.25,function()
					Show();

					task.delay(Notify.Duration + 0.2,Close)
				end);
			end;

			Show();

			return {
				Title = function(self , new)
					Header.Text = new;
					UpdateText(); 
				end,

				Content = function(self , new)
					Body.Text = new;
					UpdateText();
				end,

				SetProgress = function(self , new , Time)
					if Time and Time <= 0 then
						TimeLeft.Size = UDim2.new(new, 0, 1, 0);

						UpdateText();
						return;
					end;

					if new > 1 then
						new = (new / 100);	
					end;

					Compkiller:_Animation(TimeLeft,TweenInfo.new(Time or 0.85,(Time and Enum.EasingStyle.Linear) or Enum.EasingStyle.Quint),{
						Size = UDim2.new(new, 0, 1, 0)
					});

					UpdateText();
				end,

				Close = Close,
			}
		end,
	};

	return Compkiller.NOTIFY_CACHE;
end;

Compkiller.NilFolder.Name = "Nil-Instances";

return Compkiller;

end)()
end)
if success and type(Compkiller) == "table" and Compkiller.Security then
	pcall(function() Compkiller:Security("XINZ-UI-Cache") end)
end

	end
end)

local _cloneref = (typeof(cloneref) == "function" and cloneref) or function(...) return ... end
local _gethui = (typeof(gethui) == "function" and gethui) or (typeof(get_hidden_gui) == "function" and get_hidden_gui) or nil
local _protectgui = (typeof(protect_gui) == "function" and protect_gui) or (typeof(syn) == "table" and syn and syn.protect_gui) or nil

-- Clone all service references to prevent anti-cheat from tracing them
local _Services = setmetatable({}, {
	__index = function(self, name)
		local ok, svc = pcall(function() return _cloneref(game:GetService(name)) end)
		if ok and svc then
			self[name] = svc
			return svc
		end
		return game:GetService(name)
	end
})

-- Generate a randomized, innocent-looking ScreenGui name to evade FindFirstChild scans
local _randomGuiName = (function()
	local chars = "abcdefghijklmnopqrstuvwxyz"
	local prefixes = {"ScreenGui", "GuiRoot", "UIContainer", "Display", "Overlay", "Panel"}
	local prefix = prefixes[math.random(1, #prefixes)]
	local suffix = ""
	for i = 1, 8 do
		local idx = math.random(1, #chars)
		suffix = suffix .. chars:sub(idx, idx)
	end
	return prefix .. "_" .. suffix .. "_" .. tostring(math.random(100000, 999999))
end)()

-- Safe environment functions for Image Caching (Dex Style)


local _request = (typeof(request) == "function" and request) or (typeof(http_request) == "function" and http_request) or (typeof(syn) == "table" and syn and syn.request) or nil


Library = {}
SaveTheme = {}

local themes = {
	index = {'Dark', 'Light', 'Liquid Glass', 'Amethyst', 'Rose', 'Ocean', 'Neon', 'Gold'},
	Rose = {
		['Shadow'] = Color3.fromRGB(30, 15, 20),
		['Background'] = Color3.fromRGB(35, 18, 25),
		['Page'] = Color3.fromRGB(28, 14, 20),
		['Main'] = Color3.fromRGB(220, 80, 120),
		['Text & Icon'] = Color3.fromRGB(255, 220, 230),
		['Function'] = {
			['Toggle'] = {
				['Background'] = Color3.fromRGB(40, 20, 28),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(100, 30, 55),
					['Toggle Value'] = Color3.fromRGB(220, 80, 120),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(50, 25, 35),
					['Toggle Value'] = Color3.fromRGB(80, 40, 55),
				}
			},
			['Label'] = { ['Background'] = Color3.fromRGB(40, 20, 28) },
			['Dropdown'] = {
				['Background'] = Color3.fromRGB(40, 20, 28),
				['Value Background'] = Color3.fromRGB(28, 14, 20),
				['Value Stroke'] = Color3.fromRGB(220, 80, 120),
				['Dropdown Select'] = {
					['Background'] = Color3.fromRGB(28, 14, 20),
					['Search'] = Color3.fromRGB(45, 22, 32),
					['Item Background'] = Color3.fromRGB(55, 28, 40),
				}
			},
			['Slider'] = {
				['Background'] = Color3.fromRGB(40, 20, 28),
				['Value Background'] = Color3.fromRGB(28, 14, 20),
				['Value Stroke'] = Color3.fromRGB(220, 80, 120),
				['Slider Bar'] = Color3.fromRGB(100, 30, 55),
				['Slider Bar Value'] = Color3.fromRGB(220, 80, 120),
				['Circle Value'] = Color3.fromRGB(255, 220, 230),
			},
			['Code'] = {
				['Background'] = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 20, 28)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 20, 28))},
				['Background Code'] = Color3.fromRGB(60, 30, 42),
				['Background Code Value'] = Color3.fromRGB(45, 22, 32),
				['ScrollingFrame Code'] = Color3.fromRGB(220, 80, 120),
			},
			['Button'] = {
				['Background'] = Color3.fromRGB(40, 20, 28),
				['Click'] = Color3.fromRGB(255, 220, 230),
			},
			['Textbox'] = {
				['Background'] = Color3.fromRGB(40, 20, 28),
				['Value Background'] = Color3.fromRGB(28, 14, 20),
				['Value Stroke'] = Color3.fromRGB(220, 80, 120),
			},
			['Keybind'] = {
				['Background'] = Color3.fromRGB(40, 20, 28),
				['Value Background'] = Color3.fromRGB(28, 14, 20),
				['Value Stroke'] = Color3.fromRGB(220, 80, 120),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(100, 30, 55),
					['Toggle Value'] = Color3.fromRGB(220, 80, 120),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(50, 25, 35),
					['Toggle Value'] = Color3.fromRGB(80, 40, 55),
				}
			},
			['Color Picker'] = {
				['Background'] = Color3.fromRGB(40, 20, 28),
				['Color Select'] = {
					['Background'] = Color3.fromRGB(28, 14, 20),
					['UIStroke'] = Color3.fromRGB(220, 80, 120),
				}
			}
		}
	},
	Ocean = {
		['Shadow'] = Color3.fromRGB(5, 15, 30),
		['Background'] = Color3.fromRGB(8, 20, 40),
		['Page'] = Color3.fromRGB(6, 16, 32),
		['Main'] = Color3.fromRGB(0, 150, 220),
		['Text & Icon'] = Color3.fromRGB(200, 235, 255),
		['Function'] = {
			['Toggle'] = {
				['Background'] = Color3.fromRGB(10, 25, 50),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(0, 70, 120),
					['Toggle Value'] = Color3.fromRGB(0, 150, 220),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(15, 35, 65),
					['Toggle Value'] = Color3.fromRGB(20, 55, 90),
				}
			},
			['Label'] = { ['Background'] = Color3.fromRGB(10, 25, 50) },
			['Dropdown'] = {
				['Background'] = Color3.fromRGB(10, 25, 50),
				['Value Background'] = Color3.fromRGB(6, 16, 32),
				['Value Stroke'] = Color3.fromRGB(0, 150, 220),
				['Dropdown Select'] = {
					['Background'] = Color3.fromRGB(6, 16, 32),
					['Search'] = Color3.fromRGB(12, 30, 58),
					['Item Background'] = Color3.fromRGB(15, 38, 70),
				}
			},
			['Slider'] = {
				['Background'] = Color3.fromRGB(10, 25, 50),
				['Value Background'] = Color3.fromRGB(6, 16, 32),
				['Value Stroke'] = Color3.fromRGB(0, 150, 220),
				['Slider Bar'] = Color3.fromRGB(0, 70, 120),
				['Slider Bar Value'] = Color3.fromRGB(0, 150, 220),
				['Circle Value'] = Color3.fromRGB(200, 235, 255),
			},
			['Code'] = {
				['Background'] = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 25, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 25, 50))},
				['Background Code'] = Color3.fromRGB(15, 38, 70),
				['Background Code Value'] = Color3.fromRGB(10, 28, 55),
				['ScrollingFrame Code'] = Color3.fromRGB(0, 150, 220),
			},
			['Button'] = {
				['Background'] = Color3.fromRGB(10, 25, 50),
				['Click'] = Color3.fromRGB(200, 235, 255),
			},
			['Textbox'] = {
				['Background'] = Color3.fromRGB(10, 25, 50),
				['Value Background'] = Color3.fromRGB(6, 16, 32),
				['Value Stroke'] = Color3.fromRGB(0, 150, 220),
			},
			['Keybind'] = {
				['Background'] = Color3.fromRGB(10, 25, 50),
				['Value Background'] = Color3.fromRGB(6, 16, 32),
				['Value Stroke'] = Color3.fromRGB(0, 150, 220),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(0, 70, 120),
					['Toggle Value'] = Color3.fromRGB(0, 150, 220),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(15, 35, 65),
					['Toggle Value'] = Color3.fromRGB(20, 55, 90),
				}
			},
			['Color Picker'] = {
				['Background'] = Color3.fromRGB(10, 25, 50),
				['Color Select'] = {
					['Background'] = Color3.fromRGB(6, 16, 32),
					['UIStroke'] = Color3.fromRGB(0, 150, 220),
				}
			}
		}
	},
	Neon = {
		['Shadow'] = Color3.fromRGB(5, 15, 5),
		['Background'] = Color3.fromRGB(8, 20, 8),
		['Page'] = Color3.fromRGB(6, 16, 6),
		['Main'] = Color3.fromRGB(0, 255, 100),
		['Text & Icon'] = Color3.fromRGB(200, 255, 215),
		['Function'] = {
			['Toggle'] = {
				['Background'] = Color3.fromRGB(10, 28, 12),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(0, 100, 40),
					['Toggle Value'] = Color3.fromRGB(0, 255, 100),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(15, 40, 18),
					['Toggle Value'] = Color3.fromRGB(20, 65, 30),
				}
			},
			['Label'] = { ['Background'] = Color3.fromRGB(10, 28, 12) },
			['Dropdown'] = {
				['Background'] = Color3.fromRGB(10, 28, 12),
				['Value Background'] = Color3.fromRGB(6, 16, 6),
				['Value Stroke'] = Color3.fromRGB(0, 255, 100),
				['Dropdown Select'] = {
					['Background'] = Color3.fromRGB(6, 16, 6),
					['Search'] = Color3.fromRGB(12, 32, 14),
					['Item Background'] = Color3.fromRGB(15, 42, 18),
				}
			},
			['Slider'] = {
				['Background'] = Color3.fromRGB(10, 28, 12),
				['Value Background'] = Color3.fromRGB(6, 16, 6),
				['Value Stroke'] = Color3.fromRGB(0, 255, 100),
				['Slider Bar'] = Color3.fromRGB(0, 100, 40),
				['Slider Bar Value'] = Color3.fromRGB(0, 255, 100),
				['Circle Value'] = Color3.fromRGB(200, 255, 215),
			},
			['Code'] = {
				['Background'] = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 28, 12)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 28, 12))},
				['Background Code'] = Color3.fromRGB(15, 42, 18),
				['Background Code Value'] = Color3.fromRGB(10, 30, 12),
				['ScrollingFrame Code'] = Color3.fromRGB(0, 255, 100),
			},
			['Button'] = {
				['Background'] = Color3.fromRGB(10, 28, 12),
				['Click'] = Color3.fromRGB(200, 255, 215),
			},
			['Textbox'] = {
				['Background'] = Color3.fromRGB(10, 28, 12),
				['Value Background'] = Color3.fromRGB(6, 16, 6),
				['Value Stroke'] = Color3.fromRGB(0, 255, 100),
			},
			['Keybind'] = {
				['Background'] = Color3.fromRGB(10, 28, 12),
				['Value Background'] = Color3.fromRGB(6, 16, 6),
				['Value Stroke'] = Color3.fromRGB(0, 255, 100),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(0, 100, 40),
					['Toggle Value'] = Color3.fromRGB(0, 255, 100),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(15, 40, 18),
					['Toggle Value'] = Color3.fromRGB(20, 65, 30),
				}
			},
			['Color Picker'] = {
				['Background'] = Color3.fromRGB(10, 28, 12),
				['Color Select'] = {
					['Background'] = Color3.fromRGB(6, 16, 6),
					['UIStroke'] = Color3.fromRGB(0, 255, 100),
				}
			}
		}
	},
	Gold = {
		['Shadow'] = Color3.fromRGB(25, 18, 5),
		['Background'] = Color3.fromRGB(30, 22, 8),
		['Page'] = Color3.fromRGB(24, 17, 5),
		['Main'] = Color3.fromRGB(255, 185, 0),
		['Text & Icon'] = Color3.fromRGB(255, 240, 200),
		['Function'] = {
			['Toggle'] = {
				['Background'] = Color3.fromRGB(38, 27, 8),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(120, 80, 0),
					['Toggle Value'] = Color3.fromRGB(255, 185, 0),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(55, 38, 10),
					['Toggle Value'] = Color3.fromRGB(85, 60, 15),
				}
			},
			['Label'] = { ['Background'] = Color3.fromRGB(38, 27, 8) },
			['Dropdown'] = {
				['Background'] = Color3.fromRGB(38, 27, 8),
				['Value Background'] = Color3.fromRGB(24, 17, 5),
				['Value Stroke'] = Color3.fromRGB(255, 185, 0),
				['Dropdown Select'] = {
					['Background'] = Color3.fromRGB(24, 17, 5),
					['Search'] = Color3.fromRGB(42, 30, 10),
					['Item Background'] = Color3.fromRGB(52, 38, 12),
				}
			},
			['Slider'] = {
				['Background'] = Color3.fromRGB(38, 27, 8),
				['Value Background'] = Color3.fromRGB(24, 17, 5),
				['Value Stroke'] = Color3.fromRGB(255, 185, 0),
				['Slider Bar'] = Color3.fromRGB(120, 80, 0),
				['Slider Bar Value'] = Color3.fromRGB(255, 185, 0),
				['Circle Value'] = Color3.fromRGB(255, 240, 200),
			},
			['Code'] = {
				['Background'] = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 27, 8)), ColorSequenceKeypoint.new(1, Color3.fromRGB(38, 27, 8))},
				['Background Code'] = Color3.fromRGB(52, 38, 12),
				['Background Code Value'] = Color3.fromRGB(38, 28, 8),
				['ScrollingFrame Code'] = Color3.fromRGB(255, 185, 0),
			},
			['Button'] = {
				['Background'] = Color3.fromRGB(38, 27, 8),
				['Click'] = Color3.fromRGB(255, 240, 200),
			},
			['Textbox'] = {
				['Background'] = Color3.fromRGB(38, 27, 8),
				['Value Background'] = Color3.fromRGB(24, 17, 5),
				['Value Stroke'] = Color3.fromRGB(255, 185, 0),
			},
			['Keybind'] = {
				['Background'] = Color3.fromRGB(38, 27, 8),
				['Value Background'] = Color3.fromRGB(24, 17, 5),
				['Value Stroke'] = Color3.fromRGB(255, 185, 0),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(120, 80, 0),
					['Toggle Value'] = Color3.fromRGB(255, 185, 0),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(55, 38, 10),
					['Toggle Value'] = Color3.fromRGB(85, 60, 15),
				}
			},
			['Color Picker'] = {
				['Background'] = Color3.fromRGB(38, 27, 8),
				['Color Select'] = {
					['Background'] = Color3.fromRGB(24, 17, 5),
					['UIStroke'] = Color3.fromRGB(255, 185, 0),
				}
			}
		}
	},
	Amethyst = {
		['Shadow'] = Color3.fromRGB(24, 24, 31),
		['Background'] = Color3.fromRGB(29, 28, 38),
		['Page'] = Color3.fromRGB(24, 24, 31),
		['Main'] = Color3.fromRGB(91, 68, 209),
		['Text & Icon'] = Color3.fromRGB(255, 255, 255),
		['Function'] = {
			['Toggle'] = {
				['Background'] = Color3.fromRGB(29, 28, 38),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(44, 34, 103),
					['Toggle Value'] = Color3.fromRGB(91, 68, 209),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(36, 35, 48),
					['Toggle Value'] = Color3.fromRGB(44, 42, 62),
				}
			},
			['Label'] = {
				['Background'] = Color3.fromRGB(29, 28, 38),
			},
			['Dropdown'] = {
				['Background'] = Color3.fromRGB(29, 28, 38),
				['Value Background'] = Color3.fromRGB(24, 24, 31),
				['Value Stroke'] = Color3.fromRGB(255, 255, 255),
				['Dropdown Select'] = {
					['Background'] = Color3.fromRGB(24, 24, 31),
					['Search'] = Color3.fromRGB(35, 35, 42),
					['Item Background'] = Color3.fromRGB(45, 45, 52),
				}
			},
			['Slider'] = {
				['Background'] = Color3.fromRGB(29, 28, 38),
				['Value Background'] = Color3.fromRGB(24, 24, 31),
				['Value Stroke'] = Color3.fromRGB(255, 255, 255),
				['Slider Bar'] = Color3.fromRGB(44, 34, 103),
				['Slider Bar Value'] = Color3.fromRGB(91, 68, 209),
				['Circle Value'] = Color3.fromRGB(255, 255, 255)
			},
			['Code'] = {
				['Background'] = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(29, 28, 38)), ColorSequenceKeypoint.new(1, Color3.fromRGB(29, 28, 38))},
				['Background Code'] = Color3.fromRGB(51, 62, 68),
				['Background Code Value'] = Color3.fromRGB(38, 50, 56),
				['ScrollingFrame Code'] = Color3.fromRGB(216, 150, 179)
			},
			['Button'] = {
				['Background'] = Color3.fromRGB(29, 28, 38),
				['Click'] = Color3.fromRGB(255, 255, 255)
			},
			['Textbox'] = {
				['Background'] = Color3.fromRGB(29, 28, 38),
				['Value Background'] = Color3.fromRGB(24, 24, 31),
				['Value Stroke'] = Color3.fromRGB(255, 255, 255),
			},
			['Keybind'] = {
				['Background'] = Color3.fromRGB(29, 28, 38),
				['Value Background'] = Color3.fromRGB(24, 24, 31),
				['Value Stroke'] = Color3.fromRGB(255, 255, 255),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(44, 34, 103),
					['Toggle Value'] = Color3.fromRGB(91, 68, 209),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(36, 35, 48),
					['Toggle Value'] = Color3.fromRGB(44, 42, 62),
				}
			},
			['Color Picker'] = {
				['Background'] = Color3.fromRGB(29, 28, 38),
				['Color Select'] = {
					['Background'] = Color3.fromRGB(24, 24, 31),
					['UIStroke'] = Color3.fromRGB(255, 255, 255),
				}
			}
		}
	},
	Dark = {
		['Shadow'] = Color3.fromRGB(15, 15, 15),
		['Background'] = Color3.fromRGB(20, 20, 20),
		['Page'] = Color3.fromRGB(18, 18, 18),
		['Main'] = Color3.fromRGB(50, 50, 50),
		['Text'] = Color3.fromRGB(255, 255, 255),
		['Icon'] = Color3.fromRGB(255, 128, 0),
		['Text & Icon'] = Color3.fromRGB(230, 230, 230),
		['Function'] = {
			['Toggle'] = {
				['Background'] = Color3.fromRGB(25, 25, 25),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(40, 40, 40),
					['Toggle Value'] = Color3.fromRGB(255, 128, 0),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(30, 30, 30),
					['Toggle Value'] = Color3.fromRGB(40, 40, 40),
				}
			},
			['Label'] = {
				['Background'] = Color3.fromRGB(25, 25, 25),
			},
			['Dropdown'] = {
				['Background'] = Color3.fromRGB(25, 25, 25),
				['Value Background'] = Color3.fromRGB(20, 20, 20),
				['Value Stroke'] = Color3.fromRGB(230, 230, 230),
				['Dropdown Select'] = {
					['Background'] = Color3.fromRGB(20, 20, 20),
					['Search'] = Color3.fromRGB(30, 30, 30),
					['Item Background'] = Color3.fromRGB(30, 30, 30),
				}
			},
			['Slider'] = {
				['Background'] = Color3.fromRGB(25, 25, 25),
				['Value Background'] = Color3.fromRGB(20, 20, 20),
				['Value Stroke'] = Color3.fromRGB(230, 230, 230),
				['Slider Bar'] = Color3.fromRGB(40, 40, 40),
				['Slider Bar Value'] = Color3.fromRGB(255, 128, 0),
				['Circle Value'] = Color3.fromRGB(255, 255, 255)
			},
			['Code'] = {
				['Background'] = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)), ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))},
				['Background Code'] = Color3.fromRGB(35, 35, 35),
				['Background Code Value'] = Color3.fromRGB(28, 28, 28),
				['ScrollingFrame Code'] = Color3.fromRGB(150, 150, 150)
			},
			['Button'] = {
				['Background'] = Color3.fromRGB(25, 25, 25),
				['Click'] = Color3.fromRGB(230, 230, 230)
			},
			['Textbox'] = {
				['Background'] = Color3.fromRGB(25, 25, 25),
				['Value Background'] = Color3.fromRGB(20, 20, 20),
				['Value Stroke'] = Color3.fromRGB(230, 230, 230),
			},
			['Keybind'] = {
				['Background'] = Color3.fromRGB(25, 25, 25),
				['Value Background'] = Color3.fromRGB(20, 20, 20),
				['Value Stroke'] = Color3.fromRGB(230, 230, 230),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(40, 40, 40),
					['Toggle Value'] = Color3.fromRGB(255, 128, 0),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(30, 30, 30),
					['Toggle Value'] = Color3.fromRGB(40, 40, 40),
				}
			},
			['Color Picker'] = {
				['Background'] = Color3.fromRGB(25, 25, 25),
				['Color Select'] = {
					['Background'] = Color3.fromRGB(20, 20, 20),
					['UIStroke'] = Color3.fromRGB(230, 230, 230),
				}
			}
		}
	},
	Light = {
		['Shadow'] = Color3.fromRGB(180, 185, 195),
		['Background'] = Color3.fromRGB(242, 244, 248),
		['Page'] = Color3.fromRGB(255, 255, 255),
		['Main'] = Color3.fromRGB(0, 122, 255),
		['Text'] = Color3.fromRGB(28, 32, 42),
		['Icon'] = Color3.fromRGB(0, 122, 255),
		['Text & Icon'] = Color3.fromRGB(45, 52, 65),
		['Function'] = {
			['Toggle'] = {
				['Background'] = Color3.fromRGB(232, 235, 242),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(0, 122, 255),
					['Toggle Value'] = Color3.fromRGB(255, 255, 255),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(210, 215, 225),
					['Toggle Value'] = Color3.fromRGB(160, 168, 180),
				}
			},
			['Label'] = {
				['Background'] = Color3.fromRGB(232, 235, 242),
			},
			['Dropdown'] = {
				['Background'] = Color3.fromRGB(232, 235, 242),
				['Value Background'] = Color3.fromRGB(255, 255, 255),
				['Value Stroke'] = Color3.fromRGB(0, 122, 255),
				['Dropdown Select'] = {
					['Background'] = Color3.fromRGB(255, 255, 255),
					['Search'] = Color3.fromRGB(240, 242, 248),
					['Item Background'] = Color3.fromRGB(245, 247, 252),
				}
			},
			['Slider'] = {
				['Background'] = Color3.fromRGB(232, 235, 242),
				['Value Background'] = Color3.fromRGB(255, 255, 255),
				['Value Stroke'] = Color3.fromRGB(0, 122, 255),
				['Slider Bar'] = Color3.fromRGB(215, 222, 235),
				['Slider Bar Value'] = Color3.fromRGB(0, 122, 255),
				['Circle Value'] = Color3.fromRGB(255, 255, 255)
			},
			['Code'] = {
				['Background'] = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(232, 235, 242)), ColorSequenceKeypoint.new(1, Color3.fromRGB(232, 235, 242))},
				['Background Code'] = Color3.fromRGB(245, 247, 252),
				['Background Code Value'] = Color3.fromRGB(230, 235, 245),
				['ScrollingFrame Code'] = Color3.fromRGB(0, 122, 255)
			},
			['Button'] = {
				['Background'] = Color3.fromRGB(232, 235, 242),
				['Click'] = Color3.fromRGB(0, 122, 255)
			},
			['Textbox'] = {
				['Background'] = Color3.fromRGB(232, 235, 242),
				['Value Background'] = Color3.fromRGB(255, 255, 255),
				['Value Stroke'] = Color3.fromRGB(0, 122, 255),
			},
			['Keybind'] = {
				['Background'] = Color3.fromRGB(232, 235, 242),
				['Value Background'] = Color3.fromRGB(255, 255, 255),
				['Value Stroke'] = Color3.fromRGB(0, 122, 255),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(0, 122, 255),
					['Toggle Value'] = Color3.fromRGB(255, 255, 255),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(210, 215, 225),
					['Toggle Value'] = Color3.fromRGB(160, 168, 180),
				}
			},
			['Color Picker'] = {
				['Background'] = Color3.fromRGB(232, 235, 242),
				['Color Select'] = {
					['Background'] = Color3.fromRGB(255, 255, 255),
					['UIStroke'] = Color3.fromRGB(0, 122, 255),
				}
			}
		}
	},
	['Liquid Glass'] = {
		['Shadow'] = Color3.fromRGB(0, 25, 40),
		['Background'] = Color3.fromRGB(10, 22, 34),
		['Page'] = Color3.fromRGB(6, 16, 26),
		['Main'] = Color3.fromRGB(0, 225, 255),
		['Text'] = Color3.fromRGB(240, 252, 255),
		['Icon'] = Color3.fromRGB(0, 225, 255),
		['Text & Icon'] = Color3.fromRGB(200, 240, 255),
		['Function'] = {
			['Toggle'] = {
				['Background'] = Color3.fromRGB(14, 30, 46),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(0, 95, 130),
					['Toggle Value'] = Color3.fromRGB(0, 225, 255),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(18, 38, 56),
					['Toggle Value'] = Color3.fromRGB(30, 65, 90),
				}
			},
			['Label'] = {
				['Background'] = Color3.fromRGB(14, 30, 46),
			},
			['Dropdown'] = {
				['Background'] = Color3.fromRGB(14, 30, 46),
				['Value Background'] = Color3.fromRGB(8, 18, 30),
				['Value Stroke'] = Color3.fromRGB(0, 225, 255),
				['Dropdown Select'] = {
					['Background'] = Color3.fromRGB(8, 18, 30),
					['Search'] = Color3.fromRGB(15, 34, 52),
					['Item Background'] = Color3.fromRGB(20, 44, 66),
				}
			},
			['Slider'] = {
				['Background'] = Color3.fromRGB(14, 30, 46),
				['Value Background'] = Color3.fromRGB(8, 18, 30),
				['Value Stroke'] = Color3.fromRGB(0, 225, 255),
				['Slider Bar'] = Color3.fromRGB(0, 95, 130),
				['Slider Bar Value'] = Color3.fromRGB(0, 225, 255),
				['Circle Value'] = Color3.fromRGB(220, 250, 255)
			},
			['Code'] = {
				['Background'] = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 30, 46)), ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 30, 46))},
				['Background Code'] = Color3.fromRGB(20, 44, 66),
				['Background Code Value'] = Color3.fromRGB(14, 32, 50),
				['ScrollingFrame Code'] = Color3.fromRGB(0, 225, 255)
			},
			['Button'] = {
				['Background'] = Color3.fromRGB(14, 30, 46),
				['Click'] = Color3.fromRGB(200, 245, 255)
			},
			['Textbox'] = {
				['Background'] = Color3.fromRGB(14, 30, 46),
				['Value Background'] = Color3.fromRGB(8, 18, 30),
				['Value Stroke'] = Color3.fromRGB(0, 225, 255),
			},
			['Keybind'] = {
				['Background'] = Color3.fromRGB(14, 30, 46),
				['Value Background'] = Color3.fromRGB(8, 18, 30),
				['Value Stroke'] = Color3.fromRGB(0, 225, 255),
				['True'] = {
					['Toggle Background'] = Color3.fromRGB(0, 95, 130),
					['Toggle Value'] = Color3.fromRGB(0, 225, 255),
				},
				['False'] = {
					['Toggle Background'] = Color3.fromRGB(18, 38, 56),
					['Toggle Value'] = Color3.fromRGB(30, 65, 90),
				}
			},
			['Color Picker'] = {
				['Background'] = Color3.fromRGB(14, 30, 46),
				['Color Select'] = {
					['Background'] = Color3.fromRGB(8, 18, 30),
					['UIStroke'] = Color3.fromRGB(0, 225, 255),
				}
			}
		}
	},
}

themes['White'] = themes['Light']
themes['LiquidGlass'] = themes['Liquid Glass']
themes['Glass'] = themes['Liquid Glass']


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = _randomGuiName

local runService = _Services.RunService
local isStudio = runService:IsStudio()

if not isStudio then
	if _gethui then
		ScreenGui.Parent = _gethui()
	elseif _protectgui then
		_protectgui(ScreenGui)
		local success, coreGui = pcall(function() return _Services.CoreGui end)
		if success and coreGui then
			ScreenGui.Parent = coreGui
		else
			ScreenGui.Parent = _Services.Players.LocalPlayer:FindFirstChildWhichIsA("PlayerGui")
		end
	else
		local success, coreGui = pcall(function() return _Services.CoreGui end)
		if success and coreGui then
			ScreenGui.Parent = coreGui
		else
			ScreenGui.Parent = _Services.Players.LocalPlayer:FindFirstChildWhichIsA("PlayerGui")
		end
	end
else
	ScreenGui.Parent = _Services.Players.LocalPlayer.PlayerGui
end

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local U, Tw = _Services.UserInputService, _Services.TweenService

do
	function addToTheme(name, obj)
		if not SaveTheme[name] then
			SaveTheme[name] = {}
		end
		table.insert(SaveTheme[name], obj)
	end
	function getColorFromPath(tbl, path)
		local result = tbl
		for _, part in ipairs(string.split(path, ".")) do
			result = result and result[part]
		end
		return result
	end
	function Library:setTheme(st)
		for name, objs in pairs(SaveTheme) do
			for _, obj in pairs(objs) do
				local overrideName = name
				if name == 'Text & Icon' then
					if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
						overrideName = 'Icon'
					elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
						overrideName = 'Text'
					end
				end
				
				local color = getColorFromPath(st, overrideName) or getColorFromPath(st, name)
				if color then
					if obj:IsA("Frame") or obj:IsA("CanvasGroup") then
						obj.BackgroundColor3 = color
					elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
						obj.TextColor3 = color
					elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
						obj.ImageColor3 = color
					elseif obj:IsA("ScrollingFrame") then
						obj.ScrollBarImageColor3 = color
					elseif obj:IsA("UIStroke") then
						obj.Color = color
					elseif obj:IsA("UIGradient") then
						obj.Color = color
					end
				end
			end
		end
	end

	local IconList = loadstring(game:HttpGet('https://raw.githubusercontent.com/Dummyrme/Library/refs/heads/main/Icon.lua'))()
	function gl(i)
		local iconData = IconList.Icons[i]
		if iconData then
			local spriteSheet = IconList.Spritesheets[tostring(iconData.Image)]
			if spriteSheet then
				return {
					Image = spriteSheet,
					ImageRectSize = iconData.ImageRectSize,
					ImageRectPosition = iconData.ImageRectPosition,
				}
			end
		end
		if type(i) == 'string' and not i:find('rbxassetid://') then
			return {
				Image = "rbxassetid://".. i,
				ImageRectSize = Vector2.new(0, 0),
				ImageRectPosition = Vector2.new(0, 0),
			}
		elseif type(i) == 'number' then
			return {
				Image = "rbxassetid://".. i,
				ImageRectSize = Vector2.new(0, 0),
				ImageRectPosition = Vector2.new(0, 0),
			}
		else
			return i
		end
	end
	function tw(info)
		return Tw:Create(info.v,TweenInfo.new(info.t, info.s, Enum.EasingDirection[info.d]),info.g)
	end
	function changecanvas(ScrollingFrame, UIListLayout, Plus)
		UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + Plus or 5)
		end)
	end
	function gs(side, pl, pr)
		if not side then
			return pl
		end

		local sideLower = string.lower(tostring(side))
		if sideLower == "r" or sideLower == "right" or side == 2 then
			return pr
		elseif sideLower == "l" or sideLower == "left" or side == 1 then
			return pl
		else
			return pl
		end
	end
	function jc(c, p)
		local Mouse = game.Players.LocalPlayer:GetMouse()

		local relativeX = Mouse.X - c.AbsolutePosition.X
		local relativeY = Mouse.Y - c.AbsolutePosition.Y

		if relativeX < 0 or relativeY < 0 or relativeX > c.AbsoluteSize.X or relativeY > c.AbsoluteSize.Y then
			return
		end

		local ClickButtonCircle = Instance.new("Frame")
		ClickButtonCircle.Parent = p
		ClickButtonCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ClickButtonCircle.BackgroundTransparency = 0.7
		ClickButtonCircle.BorderSizePixel = 0
		ClickButtonCircle.AnchorPoint = Vector2.new(0.5, 0.5)
		ClickButtonCircle.Position = UDim2.new(0, relativeX, 0, relativeY)
		ClickButtonCircle.Size = UDim2.new(0, 0, 0, 0)
		ClickButtonCircle.ZIndex = 10

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = ClickButtonCircle

		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local goal = {
			Size = UDim2.new(0, c.AbsoluteSize.X * 1.5, 0, c.AbsoluteSize.X * 1.5),
			BackgroundTransparency = 1
		}

		local expandTween = _Services.TweenService:Create(ClickButtonCircle, tweenInfo, goal)

		expandTween.Completed:Connect(function()
			ClickButtonCircle:Destroy()
		end)

		expandTween:Play()
	end
	function jcf(p, p2)
		local ClickButtonCircle = Instance.new("Frame")
		ClickButtonCircle.Parent = p
		ClickButtonCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ClickButtonCircle.BackgroundTransparency = 0.7
		ClickButtonCircle.BorderSizePixel = 0
		ClickButtonCircle.AnchorPoint = Vector2.new(0.5, 0.5)
		ClickButtonCircle.Position = UDim2.new(0, p2.AbsolutePosition.X - p.AbsolutePosition.X + p2.AbsoluteSize.X / 2, 
			0, p2.AbsolutePosition.Y - p.AbsolutePosition.Y + p2.AbsoluteSize.Y / 2)
		ClickButtonCircle.Size = UDim2.new(0, 0, 0, 0)
		ClickButtonCircle.ZIndex = 10

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = ClickButtonCircle

		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local goal = {
			Size = UDim2.new(0, p2.AbsoluteSize.X * 5, 0, p2.AbsoluteSize.X * 5),
			BackgroundTransparency = 1
		}

		local expandTween = _Services.TweenService:Create(ClickButtonCircle, tweenInfo, goal)

		expandTween.Completed:Connect(function()
			ClickButtonCircle:Destroy()
		end)

		expandTween:Play()
	end
	function lak(t, o)
		local a, b, c, d
		local function u(i)
			if Library.IsLocked then return end
			local dt = i.Position - c
			tw({v = o, t = 0.05, s = Enum.EasingStyle.Linear, d = "InOut", g = {Position = UDim2.new(d.X.Scale, d.X.Offset + dt.X, d.Y.Scale, d.Y.Offset + dt.Y)}}):Play()
		end
		t.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then a = true c = i.Position d = o.Position; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then a = false end end) end end)
		t.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then b = i end end)
		U.InputChanged:Connect(function(i) if i == b and a then u(i) end end)
	end
	function make_resize(t, o)
		local a, b, c, d
		local function u(i)
			local dt = i.Position - c
			local newX = math.max(450, d.X.Offset + dt.X)
			local newY = math.max(300, d.Y.Offset + dt.Y)
			tw({v = o, t = 0.05, s = Enum.EasingStyle.Linear, d = "InOut", g = {Size = UDim2.new(d.X.Scale, newX, d.Y.Scale, newY)}}):Play()
		end
		t.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then a = true c = i.Position d = o.Size; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then a = false end end) end end)
		t.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then b = i end end)
		U.InputChanged:Connect(function(i) if i == b and a then u(i) end end)
	end
	function click(p)
		local Click = Instance.new("TextButton")

		Click.Name = "Click"
		Click.Parent = p
		Click.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Click.BackgroundTransparency = 1.000
		Click.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Click.BorderSizePixel = 0
		Click.Size = UDim2.new(1, 0, 1, 0)
		Click.Font = Enum.Font.SourceSans
		Click.Text = ""
		Click.TextColor3 = Color3.fromRGB(0, 0, 0)
		Click.TextSize = 14.000

		return Click
	end
	function background(pl, t, d, i, ty)
		local RealBackground = Instance.new("Frame")
		local Background = Instance.new("Frame")
		local UICorner_1 = Instance.new("UICorner")
		local T_1 = Instance.new("Frame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local UIPadding_3 = Instance.new("UIPadding")
		local TextLabel_1 = Instance.new("TextLabel")
		local TextLabel_2 = Instance.new("TextLabel")

		RealBackground.Name = "Real Background"
		RealBackground.Parent = pl
		RealBackground.BackgroundTransparency = 1
		RealBackground.BorderColor3 = Color3.fromRGB(0,0,0)
		RealBackground.BorderSizePixel = 0
		RealBackground.Size = UDim2.new(1, 0,0, 35)
		RealBackground.ClipsDescendants = true

		Background.Name = "Background"
		Background.Parent = RealBackground
		Background.BackgroundColor3 = Color3.fromRGB(29,28,38)
		Background.BorderColor3 = Color3.fromRGB(0,0,0)
		Background.BorderSizePixel = 0
		Background.Size = UDim2.new(1, 0,1, 0)
		Background.ClipsDescendants = true

		addToTheme('Function.'..ty..'.Background', Background)

		UICorner_1.Parent = Background

		T_1.Name = "T"
		T_1.Parent = Background
		T_1.AnchorPoint = Vector2.new(0, 0.5)
		T_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		T_1.BackgroundTransparency = 1
		T_1.BorderColor3 = Color3.fromRGB(0,0,0)
		T_1.BorderSizePixel = 0
		T_1.Position = UDim2.new(0, 0,0.5, 0)
		T_1.Size = UDim2.new(1, 0,1, 0)

		UIListLayout_2.Parent = T_1
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

		UIPadding_3.Parent = T_1
		UIPadding_3.PaddingLeft = UDim.new(0,13)
		UIPadding_3.PaddingRight = UDim.new(0,70)

		TextLabel_1.Parent = T_1
		TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabel_1.BackgroundTransparency = 1
		TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
		TextLabel_1.BorderSizePixel = 0
		TextLabel_1.LayoutOrder = 1
		TextLabel_1.Size = UDim2.new(1, 0,0, 14)
		TextLabel_1.Font = Enum.Font.GothamBold
		TextLabel_1.RichText = true
		TextLabel_1.Text = tostring(d)
		TextLabel_1.TextColor3 = Color3.fromRGB(255,255,255)
		TextLabel_1.TextSize = 10
		TextLabel_1.TextTransparency = 0.699999988079071
		TextLabel_1.TextWrapped = true
		TextLabel_1.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel_1.Visible = false
		TextLabel_1.AutomaticSize = Enum.AutomaticSize.Y
		TextLabel_1.Name = 'Desc'

		addToTheme('Text & Icon', TextLabel_1)

		TextLabel_2.Parent = T_1
		TextLabel_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabel_2.BackgroundTransparency = 1
		TextLabel_2.BorderColor3 = Color3.fromRGB(0,0,0)
		TextLabel_2.BorderSizePixel = 0
		TextLabel_2.Size = UDim2.new(1, 0,0, 14)
		TextLabel_2.Font = Enum.Font.GothamBold
		TextLabel_2.RichText = true
		TextLabel_2.Text = tostring(t)
		TextLabel_2.TextColor3 = Color3.fromRGB(255,255,255)
		TextLabel_2.TextSize = 12
		TextLabel_2.TextWrapped = true
		TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel_2.AutomaticSize = Enum.AutomaticSize.Y
		TextLabel_2.Name = 'Title'

		addToTheme('Text & Icon', TextLabel_2)

		if d and d ~= "" then
			TextLabel_1.Visible = true
		end

		if i and i ~= "" then
			UIPadding_3.PaddingLeft = UDim.new(0, 50)
			local Image = Instance.new("Frame")
			local Icon_1 = Instance.new("ImageLabel")
			local Frame_1 = Instance.new("Frame")

			Image.Name = "Image"
			Image.Parent = Background
			Image.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Image.BackgroundTransparency = 1
			Image.BorderColor3 = Color3.fromRGB(0,0,0)
			Image.BorderSizePixel = 0
			Image.Size = UDim2.new(0, 40,1, 0)

			Icon_1.Name = "Icon"
			Icon_1.Parent = Image
			Icon_1.AnchorPoint = Vector2.new(0.5, 0.5)
			Icon_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Icon_1.BackgroundTransparency = 1
			Icon_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Icon_1.BorderSizePixel = 0
			Icon_1.Position = UDim2.new(0.5, 0,0.5, 0)
			Icon_1.Size = UDim2.new(0, 20,0, 20)
			Icon_1.Image = gl(i).Image
			Icon_1.ImageRectSize = gl(i).ImageRectSize
			Icon_1.ImageRectOffset = gl(i).ImageRectPosition
			Icon_1.ImageTransparency = 0.7

			Frame_1.Parent = Image
			Frame_1.AnchorPoint = Vector2.new(1, 0.5)
			Frame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Frame_1.BackgroundTransparency = 0.8999999761581421
			Frame_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Frame_1.BorderSizePixel = 0
			Frame_1.Position = UDim2.new(1, 0,0.5, 0)
			Frame_1.Size = UDim2.new(0, 1,0.699999988, 0)

			addToTheme('Text & Icon', Icon_1)

			addToTheme('Text & Icon', Frame_1)
		end

		local function updateSize()
			task.defer(function()
				local newSize = UIListLayout_2.AbsoluteContentSize.Y + 21
				if RealBackground.Size.Y.Offset ~= newSize then
					RealBackground.Size = UDim2.new(1, 0, 0, newSize)
				end
			end)
		end

		delay(.1, updateSize)

		UIListLayout_2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

		local f = {}

		function f:SetTextTransparencyTitle(vs)
			tw({v = TextLabel_2, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {TextTransparency = vs}}):Play()
			if i and i ~= "" then
				local imgFrame = Background:FindFirstChild("Image")
				if imgFrame then
					local iconImg = imgFrame:FindFirstChild("Icon")
					if iconImg then
						tw({v = iconImg, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageTransparency = vs}}):Play()
					end
				end
			end
		end

		function f:SetSizeT(vs)
			UIPadding_3.PaddingRight = UDim.new(0, vs)
		end

		function f:SetTitle(vs)
			TextLabel_2.Text = tostring(vs)
		end

		function f:SetDesc(vs)
			TextLabel_1.Text = tostring(vs)
			if vs and vs ~= "" then
				TextLabel_1.Visible = true
			else
				TextLabel_1.Visible = false
			end
		end

		function f:SetVisibleDesc(vs)
			TextLabel_2.Visible = vs
		end

		return Background, f
	end
	function addDropdownSelect(p, p2, Multi, Callback, Value, List)
		local F = Instance.new("Frame")
		local UIListLayout_1 = Instance.new("UIListLayout")
		local UIPadding_1 = Instance.new("UIPadding")
		local DropdownValue = Instance.new("Frame")
		local UICorner_1 = Instance.new("UICorner")
		local UIStroke_1 = Instance.new("UIStroke")
		local TextLabelValue_1 = Instance.new("TextLabel")
		local UIPadding_2 = Instance.new("UIPadding")
		local ImageLabel_1 = Instance.new("ImageLabel")

		F.Name = "F"
		F.Parent = p
		F.AnchorPoint = Vector2.new(1, 0.5)
		F.BackgroundColor3 = Color3.fromRGB(255,255,255)
		F.BackgroundTransparency = 1
		F.BorderColor3 = Color3.fromRGB(0,0,0)
		F.BorderSizePixel = 0
		F.Position = UDim2.new(1, 0,0.5, 0)
		F.Size = UDim2.new(0, 120,0.800000012, 0)

		UIListLayout_1.Parent = F
		UIListLayout_1.Padding = UDim.new(0,15)
		UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

		UIPadding_1.Parent = F
		UIPadding_1.PaddingRight = UDim.new(0,13)

		DropdownValue.Parent = F
		DropdownValue.BackgroundColor3 = Color3.fromRGB(24,24,31)
		DropdownValue.BorderColor3 = Color3.fromRGB(0,0,0)
		DropdownValue.BorderSizePixel = 0
		DropdownValue.Size = UDim2.new(0, 100,0, 20)

		addToTheme('Function.Dropdown.Value Background', DropdownValue)

		UICorner_1.Parent = DropdownValue
		UICorner_1.CornerRadius = UDim.new(0,4)

		UIStroke_1.Parent = DropdownValue
		UIStroke_1.Color = Color3.fromRGB(255,255,255)
		UIStroke_1.Thickness = 1
		UIStroke_1.Transparency = 0.95

		addToTheme('Function.Dropdown.Value Stroke', UIStroke_1)

		TextLabelValue_1.Parent = DropdownValue
		TextLabelValue_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabelValue_1.BackgroundTransparency = 1
		TextLabelValue_1.BorderColor3 = Color3.fromRGB(0,0,0)
		TextLabelValue_1.BorderSizePixel = 0
		TextLabelValue_1.Size = UDim2.new(0.8, 0,1, 0)
		TextLabelValue_1.Font = Enum.Font.GothamBold
		TextLabelValue_1.RichText = true
		TextLabelValue_1.Text = "--"
		TextLabelValue_1.TextColor3 = Color3.fromRGB(255,255,255)
		TextLabelValue_1.TextSize = 10
		TextLabelValue_1.TextTransparency = 0.3
		TextLabelValue_1.TextXAlignment = Enum.TextXAlignment.Left
		TextLabelValue_1.TextTruncate = Enum.TextTruncate.AtEnd

		addToTheme('Text & Icon', TextLabelValue_1)

		UIPadding_2.Parent = DropdownValue
		UIPadding_2.PaddingLeft = UDim.new(0,5)
		UIPadding_2.PaddingRight = UDim.new(0,5)

		ImageLabel_1.Parent = DropdownValue
		ImageLabel_1.AnchorPoint = Vector2.new(1, 0.5)
		ImageLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		ImageLabel_1.BackgroundTransparency = 1
		ImageLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
		ImageLabel_1.BorderSizePixel = 0
		ImageLabel_1.Position = UDim2.new(1, 0,0.5, 0)
		ImageLabel_1.Size = UDim2.new(0, 20,0, 20)
		ImageLabel_1.Image = GetAsset("14937709869")
		ImageLabel_1.ImageTransparency = 0.3

		addToTheme('Text & Icon', ImageLabel_1)

		local DropdownSelect = Instance.new("Frame")
		DropdownSelect.Name = "XinzDropdown"
		local UICorner_1 = Instance.new("UICorner")
		local UIStrokeDropdown_1 = Instance.new("UIStroke")
		local UIPadding_1 = Instance.new("UIPadding")
		local Search_1 = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local TextBox_1 = Instance.new("TextBox")
		local Frame_1 = Instance.new("Frame")
		local Frame_2 = Instance.new("Frame")
		local Frame_3 = Instance.new("Frame")
		local UICorner_3 = Instance.new("UICorner")
		local ScrollingFrame_1 = Instance.new("ScrollingFrame")
		local UIListLayout_1 = Instance.new("UIListLayout")
		local UIPadding_2 = Instance.new("UIPadding")
		local UIPadding_3 = Instance.new("UIPadding")
		local UIPadding_4 = Instance.new("UIPadding")

		DropdownSelect.Parent = ScreenGui
		DropdownSelect.BackgroundColor3 = Color3.fromRGB(24,24,31)
		DropdownSelect.BorderColor3 = Color3.fromRGB(0,0,0)
		DropdownSelect.BorderSizePixel = 0
		DropdownSelect.Size = UDim2.new(0, 150,0, 0)
		DropdownSelect.ClipsDescendants = true

		addToTheme('Function.Dropdown.Dropdown Select.Background', DropdownSelect)

		DropdownSelect.Position = UDim2.new(0, DropdownValue.AbsolutePosition.X - DropdownSelect.Parent.AbsolutePosition.X + DropdownValue.Size.X.Offset - 119, 0, DropdownValue.AbsolutePosition.Y - DropdownSelect.Parent.AbsolutePosition.Y + DropdownValue.Size.Y.Offset - 25)

		UICorner_1.Parent = DropdownSelect
		UICorner_1.CornerRadius = UDim.new(0,4)

		UIStrokeDropdown_1.Parent = DropdownSelect
		UIStrokeDropdown_1.Color = Color3.fromRGB(255,255,255)
		UIStrokeDropdown_1.Thickness = 1
		UIStrokeDropdown_1.Transparency = 1

		UIPadding_1.Parent = DropdownSelect
		UIPadding_1.PaddingBottom = UDim.new(0,5)
		UIPadding_1.PaddingLeft = UDim.new(0,5)
		UIPadding_1.PaddingRight = UDim.new(0,5)
		UIPadding_1.PaddingTop = UDim.new(0,5)

		Search_1.Name = "Search"
		Search_1.Parent = DropdownSelect
		Search_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Search_1.BackgroundTransparency = 0.949999988079071
		Search_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Search_1.BorderSizePixel = 0
		Search_1.Size = UDim2.new(1, 0,0, 20)

		addToTheme('Function.Dropdown.Dropdown Select.Search', Search_1)

		UICorner_2.Parent = Search_1
		UICorner_2.CornerRadius = UDim.new(0,4)

		TextBox_1.Parent = Search_1
		TextBox_1.Active = true
		TextBox_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextBox_1.BackgroundTransparency = 1
		TextBox_1.BorderColor3 = Color3.fromRGB(0,0,0)
		TextBox_1.BorderSizePixel = 0
		TextBox_1.CursorPosition = -1
		TextBox_1.Size = UDim2.new(1, 0,1, 0)
		TextBox_1.Font = Enum.Font.Gotham
		TextBox_1.PlaceholderColor3 = Color3.fromRGB(178,178,178)
		TextBox_1.PlaceholderText = "Search . . ."
		TextBox_1.Text = ""
		TextBox_1.TextColor3 = Color3.fromRGB(255,255,255)
		TextBox_1.TextSize = 11

		addToTheme('Text & Icon', Search_1)

		addToTheme('Text & Icon', TextBox_1)

		Frame_1.Parent = Search_1
		Frame_1.AnchorPoint = Vector2.new(0, 1)
		Frame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Frame_1.BackgroundTransparency = 0.8999999761581421
		Frame_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Frame_1.BorderSizePixel = 0
		Frame_1.Position = UDim2.new(0, 0,1, 0)
		Frame_1.Size = UDim2.new(1, 0,0, 2)

		Frame_2.Parent = DropdownSelect
		Frame_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Frame_2.BackgroundTransparency = 1
		Frame_2.BorderColor3 = Color3.fromRGB(0,0,0)
		Frame_2.BorderSizePixel = 0
		Frame_2.Size = UDim2.new(1, 0,1, 0)

		Frame_3.Parent = Frame_2
		Frame_3.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Frame_3.BackgroundTransparency = 0.949999988079071
		Frame_3.BorderColor3 = Color3.fromRGB(0,0,0)
		Frame_3.BorderSizePixel = 0
		Frame_3.Size = UDim2.new(1, 0,1, 0)

		UICorner_3.Parent = Frame_3
		UICorner_3.CornerRadius = UDim.new(0,4)

		ScrollingFrame_1.Name = "ScrollingFrame"
		ScrollingFrame_1.Parent = Frame_3
		ScrollingFrame_1.Active = true
		ScrollingFrame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		ScrollingFrame_1.BackgroundTransparency = 1
		ScrollingFrame_1.BorderColor3 = Color3.fromRGB(0,0,0)
		ScrollingFrame_1.BorderSizePixel = 0
		ScrollingFrame_1.Size = UDim2.new(1, 0,1, 0)
		ScrollingFrame_1.ClipsDescendants = true
		ScrollingFrame_1.AutomaticCanvasSize = Enum.AutomaticSize.None
		ScrollingFrame_1.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
		ScrollingFrame_1.CanvasPosition = Vector2.new(0, 0)
		ScrollingFrame_1.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
		ScrollingFrame_1.HorizontalScrollBarInset = Enum.ScrollBarInset.None
		ScrollingFrame_1.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
		ScrollingFrame_1.ScrollBarImageColor3 = Color3.fromRGB(107,84,255)
		ScrollingFrame_1.ScrollBarImageTransparency = 0
		ScrollingFrame_1.ScrollBarThickness = 2
		ScrollingFrame_1.ScrollingDirection = Enum.ScrollingDirection.XY
		ScrollingFrame_1.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
		ScrollingFrame_1.VerticalScrollBarInset = Enum.ScrollBarInset.None
		ScrollingFrame_1.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

		UIListLayout_1.Parent = ScrollingFrame_1
		UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_1.Padding = UDim.new(0, 3)

		UIPadding_2.Parent = ScrollingFrame_1
		UIPadding_2.PaddingRight = UDim.new(0,5)

		UIPadding_3.Parent = Frame_3
		UIPadding_3.PaddingBottom = UDim.new(0,5)
		UIPadding_3.PaddingLeft = UDim.new(0,5)
		UIPadding_3.PaddingRight = UDim.new(0,3)
		UIPadding_3.PaddingTop = UDim.new(0,5)

		UIPadding_4.Parent = Frame_2
		UIPadding_4.PaddingTop = UDim.new(0,25)

		local Click = click(p2)

		local isopen = false

		local function updateDropdownSize()
			if not isopen then return end

			local visibleCount = 0
			for i, v in pairs(ScrollingFrame_1:GetChildren()) do
				if v:IsA("Frame") and v.Visible then
					visibleCount = visibleCount + 1
				end
			end

			local contentHeight = (UIListLayout_1.AbsoluteContentSize.Y + 54)
			if contentHeight > 200 then
				contentHeight = 200
			end

			tw({v = DropdownSelect, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(0, 150, 0, contentHeight)}}):Play()
		end

		TextBox_1.Changed:Connect(function()
			local SearchT = string.lower(TextBox_1.Text)
			for i, v in pairs(ScrollingFrame_1:GetChildren()) do
				if v:IsA("Frame") then
					if SearchT ~= "" and v:FindFirstChild("TextLabel") then
						if string.find(string.lower(v.TextLabel.Text), SearchT) then
							v.Visible = true
						else
							v.Visible = false
						end
					else
						v.Visible = true
					end
				end
			end
			updateDropdownSize()
		end)

		local function open()
			if isopen then
				return
			end
			DropdownSelect.Visible = true
			local targetX = DropdownValue.AbsolutePosition.X - DropdownSelect.Parent.AbsolutePosition.X + DropdownValue.Size.X.Offset - 119
			local targetY = DropdownValue.AbsolutePosition.Y - DropdownSelect.Parent.AbsolutePosition.Y + DropdownValue.Size.Y.Offset - 25
			local contentHeight = UIListLayout_1.AbsoluteContentSize.Y + 54
			if contentHeight <= 200 then
				tw({v = DropdownSelect, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Size = UDim2.new(0, 150, 0, contentHeight), Position = UDim2.new(0, targetX, 0, targetY)}}):Play()
			else
				tw({v = DropdownSelect, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Size = UDim2.new(0, 150, 0, 200), Position = UDim2.new(0, targetX, 0, targetY)}}):Play()
			end
			tw({v = UIStrokeDropdown_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Transparency = 0.95}}):Play()
			isopen = true
		end

		local function close()
			if not isopen then
				return
			end
			tw({v = UIStrokeDropdown_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Transparency = 1}}):Play()
			local gf = tw({v = DropdownSelect, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Size = UDim2.new(0, 150,0, 0)}})
			gf:Play()
			gf.Completed:Connect(function()
				DropdownSelect.Visible = false
				isopen = false
			end)
		end

		U.InputBegan:Connect(function(A)
			if A.UserInputType == Enum.UserInputType.MouseButton1 or A.UserInputType == Enum.UserInputType.Touch then
				local B, C = DropdownSelect.AbsolutePosition, DropdownSelect.AbsoluteSize
				if _Services.Players.LocalPlayer:GetMouse().X < B.X or _Services.Players.LocalPlayer:GetMouse().X > B.X + C.X or _Services.Players.LocalPlayer:GetMouse().Y < (B.Y - 20 - 1) or _Services.Players.LocalPlayer:GetMouse().Y > B.Y + C.Y then
					close()
				end
			end
		end)

		Click.MouseButton1Click:Connect(function()
			if not isopen then
				open()
			else
				close()
			end
		end)

		local itemslist = {}
		local selectedValues = {}
		local selectedItem

		function itemslist:Clear(a)
			local function shouldClear(v)
				if a == nil then
					return true
				elseif type(a) == "string" then
					return v:FindFirstChild("TextLabel") and v.TextLabel.Text == a
				elseif type(a) == "table" then
					for _, name in ipairs(a) do
						if v:FindFirstChild("TextLabel") and v.TextLabel.Text == name then
							return true
						end
					end
				end
				return false
			end

			if Multi then
				selectedValues = {}
				TextLabelValue_1.Text = "--"
				pcall(Callback ,selectedValues)
			end

			for _, v in ipairs(ScrollingFrame_1:GetChildren()) do
				if v:IsA("Frame") and shouldClear(v) then
					if selectedItem and v:FindFirstChild("TextLabel") and v.TextLabel.Text == selectedItem then
						selectedItem = nil
						TextLabelValue_1.Text = "--"
						pcall(Callback, TextLabelValue_1.Text)
					end
					v:Destroy()
				end
			end

			if selectedItem == a or TextLabelValue_1.Text == a then
				selectedItem = nil
				TextLabelValue_1.Text = "--"
			end

			if a == nil then
				selectedItem = nil
				TextLabelValue_1.Text = "--"
			end

			Value = nil
		end

		function itemslist:Add(text)

			local Item_1 = Instance.new("Frame")
			local TextLabel_1 = Instance.new("TextLabel")

			Item_1.Name = "Item"
			Item_1.Parent = ScrollingFrame_1
			Item_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Item_1.BackgroundTransparency = 0.95
			Item_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Item_1.BorderSizePixel = 0
			Item_1.Size = UDim2.new(1, 0,0, 18)

			TextLabel_1.Parent = Item_1
			TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextLabel_1.BackgroundTransparency = 1
			TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
			TextLabel_1.BorderSizePixel = 0
			TextLabel_1.Size = UDim2.new(1, 0,1, 0)
			TextLabel_1.Font = Enum.Font.GothamBold
			TextLabel_1.Text = text
			TextLabel_1.TextColor3 = Color3.fromRGB(255,255,255)
			TextLabel_1.TextSize = 12
			TextLabel_1.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel_1.TextTransparency = 0.8

			addToTheme('Function.Dropdown.Dropdown Select.Item Background', Item_1)
			addToTheme('Text & Icon', TextLabel_1)

			Instance.new("UICorner", Item_1).CornerRadius = UDim.new(0, 4)
			Instance.new("UIPadding", Item_1).PaddingLeft = UDim.new(0, 5)

			local ClickItem = click(Item_1)
			local function unselect()
				tw({v = TextLabel_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {TextTransparency = 0.8}}):Play()
			end
			local function hasselect()
				tw({v = TextLabel_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {TextTransparency = 0}}):Play()
			end

			ClickItem.MouseButton1Click:Connect(function()
				if Multi then
					if selectedValues[text] then
						selectedValues[text] = nil
						unselect()
					else
						selectedValues[text] = true
						hasselect()
					end
					local selectedList = {}
					for i, v in pairs(selectedValues) do
						table.insert(selectedList, i)
					end
					if #selectedList > 0 then
						TextLabelValue_1.Text = table.concat(selectedList, ", ")
					else
						TextLabelValue_1.Text = "--"
					end
					pcall(Callback, selectedList)
				else
					for i,v in pairs(ScrollingFrame_1:GetChildren()) do
						if v:IsA("Frame") then
							tw({v = v.TextLabel, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {TextTransparency = 0.8}}):Play()
						end
					end
					hasselect()
					Value = text
					TextLabelValue_1.Text = text
					pcall(Callback, TextLabelValue_1.Text)
				end
			end)

			local function isValueInTable(val, tbl)
				if type(tbl) ~= "table" then
					return false
				end

				for _, v in pairs(tbl) do
					if v == val then
						return true
					end
				end
				return false
			end

			delay(0,function()
				if Multi then
					if isValueInTable(text, Value) then
						hasselect()
						selectedValues[text] = true
						local selectedList = {}
						for i, v in pairs(selectedValues) do
							table.insert(selectedList, i)
						end
						if #selectedList > 0 then
							TextLabelValue_1.Text = table.concat(selectedList, ", ")
						else
							TextLabelValue_1.Text = "--"
						end
						pcall(Callback,selectedList)
					end
				else
					if text == Value then
						hasselect()
						Value = text
						TextLabelValue_1.Text = text
						pcall(Callback,TextLabelValue_1.Text)
					end
				end
			end)
		end

		function itemslist:SetValue(value)
			if Multi then
				selectedValues = {}
				selectedValues[value] = true
				TextLabelValue_1.Text = value
				for _, v in ipairs(ScrollingFrame_1:GetChildren()) do
					if v:IsA("Frame") and v:FindFirstChild("TextLabel") then
						if v.TextLabel.Text == value then
							tw({v = v.TextLabel, t = 0.05, s = Enum.EasingStyle.Exponential, d = "Out", g = {TextTransparency = 0}}):Play()
						else
							tw({v = v.TextLabel, t = 0.05, s = Enum.EasingStyle.Exponential, d = "Out", g = {TextTransparency = 0.8}}):Play()
						end
					end
				end
				pcall(Callback, selectedValues)
			else
				Value = value
				TextLabelValue_1.Text = value
				for _, v in ipairs(ScrollingFrame_1:GetChildren()) do
					if v:IsA("Frame") and v:FindFirstChild("TextLabel") then
						if v.TextLabel.Text == value then
							tw({v = v.TextLabel, t = 0.05, s = Enum.EasingStyle.Exponential, d = "Out", g = {TextTransparency = 0}}):Play()
						else
							tw({v = v.TextLabel, t = 0.05, s = Enum.EasingStyle.Exponential, d = "Out", g = {TextTransparency = 0.8}}):Play()
						end
					end
				end
				pcall(Callback, value)
			end
		end

		for i, v in ipairs(List) do
			itemslist:Add(v, i)
		end

		changecanvas(ScrollingFrame_1, UIListLayout_1, 5)

		function itemslist:Edit(newdata, newdefault)
			itemslist:Clear()
			if type(newdata) == "table" then
				for _, v in pairs(newdata) do
					itemslist:Add(v)
				end
			end
			if newdefault ~= nil then
				itemslist:SetValue(newdefault)
			end
		end

		return itemslist
	end
end

function Library:Window(p)

	local Title = p.Title or 'Project XINZ X'
	local Desc = p.Desc or ''
	local Version = p.Version or '1.0'
	local Icon = p.Icon or '112209635962758'
	local Theme = p.Theme or 'Dark'
	local Keybind = p.Config.Keybind or Enum.KeyCode.LeftControl
	local Size = p.Config.Size or UDim2.new(0, 530,0, 400)
	local TabWidth = p.TabWidth or 150
	local ProfileData = p.Profile
	if not ProfileData then
		local lp = _Services.Players.LocalPlayer
		if lp then
			ProfileData = {
				Username = lp.Name == "monota1412" and "[Dev] " .. lp.Name or lp.Name,
				Email = "UID: " .. tostring(lp.UserId),
				AvatarUrl = "userIds=" .. tostring(lp.UserId)
			}
		end
	end

	local R, HAA = false, false
	local CrumbOrientation = "Bottom"
	local HasChangeTheme = p.Theme
	local IsTheme = p.Theme

	local Shadow_1 = Instance.new("ImageLabel")
	local UIPadding_1 = Instance.new("UIPadding")
	local Background_1 = Instance.new("CanvasGroup")
	local UICorner_1 = Instance.new("UICorner")
	local Page_1 = Instance.new("Frame")
	local UIPadding_2 = Instance.new("UIPadding")
	
	local TooltipFrame = Instance.new("Frame")
	local TooltipLabel = Instance.new("TextLabel")
	local TooltipCorner = Instance.new("UICorner")
	local TooltipPadding = Instance.new("UIPadding")

	TooltipFrame.Name = "DockTooltip"
	TooltipFrame.Parent = ScreenGui
	TooltipFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
	TooltipFrame.Size = UDim2.new(0, 0, 0, 24)
	TooltipFrame.AnchorPoint = Vector2.new(0.5, 1)
	TooltipFrame.Visible = false
	TooltipFrame.ZIndex = 100
	TooltipFrame.BackgroundTransparency = 1

	TooltipCorner.CornerRadius = UDim.new(0, 4)
	TooltipCorner.Parent = TooltipFrame

	TooltipPadding.PaddingLeft = UDim.new(0, 8)
	TooltipPadding.PaddingRight = UDim.new(0, 8)
	TooltipPadding.Parent = TooltipFrame

	TooltipLabel.Parent = TooltipFrame
	TooltipLabel.BackgroundTransparency = 1
	TooltipLabel.Size = UDim2.new(1, 0, 1, 0)
	TooltipLabel.Font = Enum.Font.GothamMedium
	TooltipLabel.TextSize = 12
	TooltipLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	TooltipLabel.TextTransparency = 1
	TooltipLabel.Text = ""

	Shadow_1.Name = "Shadow"
	Shadow_1.Parent = ScreenGui
	Shadow_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Shadow_1.BackgroundColor3 = Color3.fromRGB(163,162,165)
	Shadow_1.BackgroundTransparency = 1
	Shadow_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Shadow_1.Size = Size
	Shadow_1.Image = GetAsset("1316045217")
	Shadow_1.ImageColor3 = Color3.fromRGB(24, 24, 31)
	Shadow_1.ImageTransparency = 0.8
	Shadow_1.ScaleType = Enum.ScaleType.Slice
	Shadow_1.SliceCenter = Rect.new(10, 10, 118, 118)
	Shadow_1.Visible = false

	addToTheme('Shadow', Shadow_1)

	UIPadding_1.Parent = Shadow_1
	UIPadding_1.PaddingBottom = UDim.new(0,8)
	UIPadding_1.PaddingLeft = UDim.new(0,8)
	UIPadding_1.PaddingRight = UDim.new(0,8)
	UIPadding_1.PaddingTop = UDim.new(0,8)

	Background_1.Name = "Background"
	Background_1.Parent = Shadow_1
	Background_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Background_1.BackgroundColor3 = Color3.fromRGB(29, 28, 38)
	Background_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Background_1.BorderSizePixel = 0
	Background_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Background_1.Size = UDim2.new(1, 0,1, 0)
	Background_1.ClipsDescendants = true
	Background_1.GroupTransparency = 1

	Shadow_1.Visible = true  
	local org = Background_1.Size
	Background_1.Size = org - UDim2.fromOffset(5, 5)
	tw({
		v = Background_1,
		t = 0.15,
		s = Enum.EasingStyle.Linear,
		d = "InOut",
		g = {
			GroupTransparency = 0,
			Size = org
		}
	}):Play()

	addToTheme('Background', Background_1)
	
	local VersionLbl = Instance.new("TextLabel")
	VersionLbl.Name = "VersionLbl"
	VersionLbl.Parent = ScreenGui
	VersionLbl.BackgroundTransparency = 1
	VersionLbl.AnchorPoint = Vector2.new(1, 1)
	VersionLbl.Position = UDim2.new(1, -5, 1, -5)
	VersionLbl.Size = UDim2.new(0, 100, 0, 15)
	VersionLbl.Font = Enum.Font.Gotham
	VersionLbl.Text = Title .. " v" .. Version
	VersionLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	VersionLbl.TextSize = 12
	VersionLbl.TextXAlignment = Enum.TextXAlignment.Right
	VersionLbl.TextTransparency = 0.6
	VersionLbl.ZIndex = 10
	addToTheme('Text & Icon', VersionLbl)

	UICorner_1.Parent = Background_1
	UICorner_1.CornerRadius = UDim.new(0,17)

	Page_1.Name = "Page"
	Page_1.Parent = Background_1
	Page_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Page_1.BackgroundTransparency = 1
	Page_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Page_1.BorderSizePixel = 0
	Page_1.Size = UDim2.new(1, 0,1, 0)

	UIPadding_2.Parent = Page_1
	UIPadding_2.PaddingBottom = UDim.new(0,5)
	UIPadding_2.PaddingLeft = UDim.new(0, TabWidth + 10)
	UIPadding_2.PaddingRight = UDim.new(0,5)
	UIPadding_2.PaddingTop = UDim.new(0,50)

	local Topbar_1 = Instance.new("Frame")
	local Frame_5 = Instance.new("Frame")
	local Ct_1 = Instance.new("Frame")
	local LockUI_1 = Instance.new("ImageButton")
	local UIPadding_11 = Instance.new("UIPadding")
	local Minisize_1 = Instance.new("ImageButton")
	local UIListLayout_6 = Instance.new("UIListLayout")
	local Close_1 = Instance.new("ImageButton")
	local DropdownValue_1 = Instance.new("Frame")
	local Td_1 = Instance.new("Frame")
	local UIPadding_13 = Instance.new("UIPadding")
	local UIListLayout_7 = Instance.new("UIListLayout")
	local Icon_1 = Instance.new("ImageLabel")
	local Title_1 = Instance.new("Frame")
	local Desc_1 = Instance.new("TextLabel")
	local UIListLayout_8 = Instance.new("UIListLayout")
	local Title_2 = Instance.new("TextLabel")
	local ChSize_1 = Instance.new("ImageButton")

	Topbar_1.Name = "Topbar"
	Topbar_1.Parent = Background_1
	Topbar_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Topbar_1.BackgroundTransparency = 1
	Topbar_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Topbar_1.BorderSizePixel = 0
	Topbar_1.Size = UDim2.new(1, 0,0, 45)

	Frame_5.Parent = Topbar_1
	Frame_5.AnchorPoint = Vector2.new(0, 1)
	Frame_5.BackgroundColor3 = Color3.fromRGB(24,24,31)
	Frame_5.BackgroundTransparency = 1
	Frame_5.BorderColor3 = Color3.fromRGB(0,0,0)
	Frame_5.BorderSizePixel = 0
	Frame_5.Position = UDim2.new(0, 0,1, 0)
	Frame_5.Size = UDim2.new(1, 0,0, 2)

	addToTheme('Page', Frame_5)

	Ct_1.Name = "Ct"
	Ct_1.Parent = Topbar_1
	Ct_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Ct_1.BackgroundTransparency = 1
	Ct_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Ct_1.BorderSizePixel = 0
	Ct_1.Size = UDim2.new(1, 0,1, 0)

	UIPadding_11.Parent = Ct_1
	UIPadding_11.PaddingBottom = UDim.new(0,5)
	UIPadding_11.PaddingLeft = UDim.new(0,5)
	UIPadding_11.PaddingRight = UDim.new(0,5)
	UIPadding_11.PaddingTop = UDim.new(0,5)

	LockUI_1.Name = "LockUI"
	LockUI_1.Parent = Ct_1
	LockUI_1.Active = true
	LockUI_1.BackgroundTransparency = 1
	LockUI_1.LayoutOrder = 0
	LockUI_1.Size = UDim2.new(0, 16, 0, 16)
	LockUI_1.Image = GetAsset("10709791475")
	LockUI_1.ImageColor3 = Color3.fromRGB(150, 150, 150)
	
	LockUI_1.MouseButton1Click:Connect(function()
		Library.IsLocked = not Library.IsLocked
		LockUI_1.Image = Library.IsLocked and GetAsset("10709791437") or GetAsset("10709791475")
		if Tabs.BreadcrumbLock then
			Tabs.BreadcrumbLock.Image = Library.IsLocked and GetAsset("10709791437") or GetAsset("10709791475")
		end
	end)

	Minisize_1.Name = "Minisize"
	Minisize_1.Parent = Ct_1
	Minisize_1.Active = true
	Minisize_1.BackgroundColor3 = Color3.fromRGB(255, 189, 46)
	Minisize_1.BackgroundTransparency = 0
	Minisize_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Minisize_1.BorderSizePixel = 0
	Minisize_1.LayoutOrder = 2
	Minisize_1.Size = UDim2.new(0, 12,0, 12)
	Minisize_1.Image = ""
	Minisize_1.ImageTransparency = 1
	local UICorner_Minisize = Instance.new("UICorner", Minisize_1)
	UICorner_Minisize.CornerRadius = UDim.new(1, 0)

	addToTheme('Text & Icon', Minisize_1)

	UIListLayout_6.Parent = Ct_1
	UIListLayout_6.Padding = UDim.new(0,6)
	UIListLayout_6.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_6.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_6.VerticalAlignment = Enum.VerticalAlignment.Center

	Close_1.Name = "Close"
	Close_1.Parent = Ct_1
	Close_1.Active = true
	Close_1.BackgroundColor3 = Color3.fromRGB(255, 95, 86)
	Close_1.BackgroundTransparency = 0
	Close_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Close_1.BorderSizePixel = 0
	Close_1.LayoutOrder = 1
	Close_1.Size = UDim2.new(0, 12,0, 12)
	Close_1.Image = ""
	local UICorner_Close = Instance.new("UICorner", Close_1)
	UICorner_Close.CornerRadius = UDim.new(1, 0)

	ChSize_1.Name = "Size"
	ChSize_1.Parent = Ct_1
	ChSize_1.Active = true
	ChSize_1.BackgroundColor3 = Color3.fromRGB(39, 201, 63)
	ChSize_1.BackgroundTransparency = 0
	ChSize_1.BorderColor3 = Color3.fromRGB(0,0,0)
	ChSize_1.BorderSizePixel = 0
	ChSize_1.LayoutOrder = 3
	ChSize_1.Size = UDim2.new(0, 12,0, 12)
	ChSize_1.Image = ""
	ChSize_1.ImageTransparency = 1
	local UICorner_ChSize = Instance.new("UICorner", ChSize_1)
	UICorner_ChSize.CornerRadius = UDim.new(1, 0)

	DropdownValue_1.Name = "DropdownValue"
	DropdownValue_1.Parent = Ct_1
	DropdownValue_1.AnchorPoint = Vector2.new(1, 0.5)
	DropdownValue_1.BackgroundColor3 = Color3.fromRGB(24,24,31)
	DropdownValue_1.BorderColor3 = Color3.fromRGB(0,0,0)
	DropdownValue_1.BorderSizePixel = 0
	DropdownValue_1.Position = UDim2.new(1, 0,0.5, 0)
	DropdownValue_1.Size = UDim2.new(0, 120,0, 20)
	DropdownValue_1.Transparency = 1

	Td_1.Name = "Td"
	Td_1.Parent = Topbar_1
	Td_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Td_1.BackgroundTransparency = 1
	Td_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Td_1.BorderSizePixel = 0
	Td_1.Size = UDim2.new(1, 0,1, 0)

	UIPadding_13.Parent = Td_1
	UIPadding_13.PaddingBottom = UDim.new(0,5)
	UIPadding_13.PaddingLeft = UDim.new(0,10)
	UIPadding_13.PaddingRight = UDim.new(0,10)
	UIPadding_13.PaddingTop = UDim.new(0,5)

	UIListLayout_7.Parent = Td_1
	UIListLayout_7.Padding = UDim.new(0,8)
	UIListLayout_7.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_7.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIListLayout_7.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_7.VerticalAlignment = Enum.VerticalAlignment.Center

	Icon_1.Name = "Icon"
	Icon_1.Parent = Td_1
	Icon_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Icon_1.BackgroundTransparency = 1
	Icon_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Icon_1.BorderSizePixel = 0
	Icon_1.Size = UDim2.new(0, 45,0, 45)
	Icon_1.Image = gl(Icon).Image
	Icon_1.ImageRectSize = gl(Icon).ImageRectSize
	Icon_1.ImageRectOffset = gl(Icon).ImageRectPosition

	addToTheme('Text', Icon_1)

	Title_1.Name = "Title"
	Title_1.Parent = Td_1
	Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Title_1.BackgroundTransparency = 4
	Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Title_1.BorderSizePixel = 0
	Title_1.LayoutOrder = 1
	Title_1.Size = UDim2.new(0, 180,1, 0)

	Desc_1.Name = "Desc"
	Desc_1.Parent = Title_1
	Desc_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Desc_1.BackgroundTransparency = 1
	Desc_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Desc_1.BorderSizePixel = 0
	Desc_1.LayoutOrder = 1
	Desc_1.Size = UDim2.new(1, 0,0, 16)
	Desc_1.Font = Enum.Font.GothamBold
	Desc_1.Text = Desc
	Desc_1.TextColor3 = Color3.fromRGB(255,255,255)
	Desc_1.TextSize = 12
	Desc_1.TextTransparency = 0.5
	Desc_1.TextXAlignment = Enum.TextXAlignment.Left
	Desc_1.Visible = false

	addToTheme('Text & Icon', Desc_1)

	if Desc and Desc ~= '' then
		Desc_1.Visible = true
	end

	UIListLayout_8.Parent = Title_1
	UIListLayout_8.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_8.VerticalAlignment = Enum.VerticalAlignment.Center

	Title_2.Name = "Title"
	Title_2.Parent = Title_1
	Title_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Title_2.BackgroundTransparency = 1
	Title_2.BorderColor3 = Color3.fromRGB(0,0,0)
	Title_2.BorderSizePixel = 0
	Title_2.Size = UDim2.new(1, 0,0, 18)
	Title_2.Font = Enum.Font.GothamBold
	Title_2.Text = Title
	Title_2.TextColor3 = Color3.fromRGB(255,255,255)
	Title_2.TextSize = 18
	Title_2.TextXAlignment = Enum.TextXAlignment.Left

	addToTheme('Text & Icon', Title_2)

	local TabP_1 = Instance.new("Frame")
	local Frame_6 = Instance.new("Frame")
	local ScrollingFrame_2 = Instance.new("ScrollingFrame")
	local TabList_1 = Instance.new("Frame")
	local Select_1 = Instance.new("Frame")
	local UICorner_10 = Instance.new("UICorner")
	local UIStroke_3 = Instance.new("UIStroke")
	local UIPadding_16 = Instance.new("UIPadding")
	local UIPadding_17 = Instance.new("UIPadding")
	local UIListLayout_10 = Instance.new("UIListLayout")

	TabP_1.Name = "TabP"
	TabP_1.Parent = Background_1
	TabP_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	TabP_1.BackgroundTransparency = 1
	TabP_1.BorderColor3 = Color3.fromRGB(0,0,0)
	TabP_1.BorderSizePixel = 0
	TabP_1.Size = UDim2.new(1, 0,1, 0)

	Frame_6.Parent = TabP_1
	Frame_6.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Frame_6.BackgroundTransparency = 1
	Frame_6.BorderColor3 = Color3.fromRGB(0,0,0)
	Frame_6.BorderSizePixel = 0
	Frame_6.Size = UDim2.new(0, TabWidth, 1, 0)

	ScrollingFrame_2.Name = "ScrollingFrame"
	ScrollingFrame_2.Parent = Frame_6
	ScrollingFrame_2.Active = true
	ScrollingFrame_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
	ScrollingFrame_2.BackgroundTransparency = 1
	ScrollingFrame_2.BorderColor3 = Color3.fromRGB(0,0,0)
	ScrollingFrame_2.BorderSizePixel = 0
	ScrollingFrame_2.Size = UDim2.new(1, 0,1, 0)
	ScrollingFrame_2.ClipsDescendants = true
	ScrollingFrame_2.AutomaticCanvasSize = Enum.AutomaticSize.None
	ScrollingFrame_2.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
	ScrollingFrame_2.CanvasPosition = Vector2.new(0, 0)
	ScrollingFrame_2.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
	ScrollingFrame_2.HorizontalScrollBarInset = Enum.ScrollBarInset.None
	ScrollingFrame_2.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	ScrollingFrame_2.ScrollBarImageColor3 = Color3.fromRGB(91,68,209)
	ScrollingFrame_2.ScrollBarImageTransparency = 0
	ScrollingFrame_2.ScrollBarThickness = 2
	ScrollingFrame_2.ScrollingDirection = Enum.ScrollingDirection.XY
	ScrollingFrame_2.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
	ScrollingFrame_2.VerticalScrollBarInset = Enum.ScrollBarInset.None
	ScrollingFrame_2.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

	addToTheme('Main', ScrollingFrame_2)

	TabList_1.Name = "TabList"
	TabList_1.Parent = ScrollingFrame_2
	TabList_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	TabList_1.BackgroundTransparency = 1
	TabList_1.BorderColor3 = Color3.fromRGB(0,0,0)
	TabList_1.BorderSizePixel = 0
	TabList_1.Size = UDim2.new(1, 0,1, 0)

	UIListLayout_10.Parent = TabList_1
	UIListLayout_10.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_10.HorizontalAlignment = Enum.HorizontalAlignment.Center

	Select_1.Name = "Select"
	Select_1.Parent = ScrollingFrame_2
	Select_1.BackgroundColor3 = Color3.fromRGB(91,68,209)
	Select_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Select_1.BorderSizePixel = 0
	Select_1.Position = UDim2.new(0, 0,0, 5)
	Select_1.Size = UDim2.new(0, 3,0, 18)

	addToTheme('Main', Select_1)

	UICorner_10.Parent = Select_1
	UICorner_10.CornerRadius = UDim.new(1,0)

	UIStroke_3.Parent = Select_1
	UIStroke_3.Color = Color3.fromRGB(24,24,31)
	UIStroke_3.Thickness = 1
	UIStroke_3.Transparency = 0.9

	UIPadding_16.Parent = ScrollingFrame_2
	UIPadding_16.PaddingBottom = UDim.new(0,1)
	UIPadding_16.PaddingLeft = UDim.new(0,1)
	UIPadding_16.PaddingRight = UDim.new(0,1)
	UIPadding_16.PaddingTop = UDim.new(0,1)

	UIPadding_17.Parent = TabP_1
	UIPadding_17.PaddingBottom = UDim.new(0,5)
	UIPadding_17.PaddingLeft = UDim.new(0,3)
	UIPadding_17.PaddingTop = UDim.new(0,55)

	changecanvas(ScrollingFrame_2, UIListLayout_10, 5)

	if ProfileData and type(ProfileData) == "table" then
		ScrollingFrame_2.Size = UDim2.new(1, 0, 1, -55)
		
		local Profile_Container = Instance.new("Frame")
		Profile_Container.Name = "Profile_Container"
		Profile_Container.Parent = Frame_6
		Profile_Container.AnchorPoint = Vector2.new(0, 1)
		Profile_Container.Position = UDim2.new(0, 5, 1, -5)
		Profile_Container.Size = UDim2.new(1, -10, 0, 45)
		Profile_Container.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
		Profile_Container.BackgroundTransparency = 0
		
		local Profile_Corner = Instance.new("UICorner", Profile_Container)
		Profile_Corner.CornerRadius = UDim.new(0, 100)
		
		local Profile_Avatar = Instance.new("ImageLabel")
		Profile_Avatar.Name = "Avatar"
		Profile_Avatar.Parent = Profile_Container
		Profile_Avatar.AnchorPoint = Vector2.new(0, 0.5)
		Profile_Avatar.Position = UDim2.new(0, 5, 0.5, 0)
		Profile_Avatar.Size = UDim2.new(0, 35, 0, 35)
		Profile_Avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		Profile_Avatar.Image = GetAsset("10901594247") -- Default user icon
		Profile_Avatar.ScaleType = Enum.ScaleType.Crop
		
		-- Avatar Loading:   executor
		local avatarUrl = ProfileData.AvatarUrl
		if avatarUrl and avatarUrl ~= "" then
			task.spawn(function()
				-- 1:  Roblox thumbnail API  userId  GetUserThumbnailAsync
				local uid = avatarUrl:match("userIds=(%d+)")
				if uid then
					local s, imgUrl = pcall(function()
						return _Services.Players:GetUserThumbnailAsync(
							tonumber(uid),
							Enum.ThumbnailType.HeadShot,
							Enum.ThumbnailSize.Size100x100
						)
					end)
					if s and imgUrl then
						Profile_Avatar.Image = GetAsset(imgUrl)
						return
					end
				end
				
				-- 2:  CacheImage  (Dex-style)
				if avatarUrl:match("^https?://") then
					pcall(function()
						Profile_Avatar.Image = CacheImage(avatarUrl)
					end)
				end
			end)
		end
		
		local Avatar_Corner = Instance.new("UICorner", Profile_Avatar)
		Avatar_Corner.CornerRadius = UDim.new(1, 0)
		
		local Profile_Name = Instance.new("TextLabel")
		Profile_Name.Name = "Username"
		Profile_Name.Parent = Profile_Container
		Profile_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Profile_Name.BackgroundTransparency = 1
		Profile_Name.Position = UDim2.new(0, 48, 0, 8)
		Profile_Name.Size = UDim2.new(1, -50, 0, 16)
		Profile_Name.Font = Enum.Font.GothamBold
		Profile_Name.Text = ProfileData.Username or "User"
		Profile_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
		Profile_Name.TextSize = 11
		Profile_Name.TextXAlignment = Enum.TextXAlignment.Left
		
		local Profile_Email = Instance.new("TextLabel")
		Profile_Email.Name = "Email"
		Profile_Email.Parent = Profile_Container
		Profile_Email.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Profile_Email.BackgroundTransparency = 1
		Profile_Email.Position = UDim2.new(0, 48, 0, 24)
		Profile_Email.Size = UDim2.new(1, -50, 0, 12)
		Profile_Email.Font = Enum.Font.Gotham
		Profile_Email.Text = ProfileData.Email or "unknown@email.com"
		Profile_Email.TextColor3 = Color3.fromRGB(200, 200, 200)
		Profile_Email.TextSize = 9
		Profile_Email.TextXAlignment = Enum.TextXAlignment.Left
		
		addToTheme('Text & Icon', Profile_Name)
		addToTheme('Main', Profile_Container)
		
		-- Override container color to look nicer for profile
		Profile_Container.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
		Profile_Container.BackgroundTransparency = 0.5
	end

	local Tabs = {
		Value = false,
		List = {},
		DefaultIndex = 1,
		IsCollapsed = false,
		TabTitles = {}
	}
	
	local CollapseBtn = Instance.new("TextButton")
	CollapseBtn.Name = "CollapseBtn"
	CollapseBtn.Parent = Icon_1
	CollapseBtn.Size = UDim2.new(1, 0, 1, 0)
	CollapseBtn.BackgroundTransparency = 1
	CollapseBtn.Text = ""
	
	local function ToggleSidebar()
		Tabs.IsCollapsed = not Tabs.IsCollapsed
		local targetWidth = Tabs.IsCollapsed and 50 or TabWidth
		local targetPadding = Tabs.IsCollapsed and 60 or (TabWidth + 10)
		
		tw({v = Frame_6, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(0, targetWidth, 1, 0)}}):Play()
		tw({v = UIPadding_2, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {PaddingLeft = UDim.new(0, targetPadding)}}):Play()
		
		tw({v = Title_2, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {TextTransparency = Tabs.IsCollapsed and 1 or 0}}):Play()
		tw({v = Desc_1, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {TextTransparency = Tabs.IsCollapsed and 1 or 0.5}}):Play()
		
		for _, lbl in ipairs(Tabs.TabTitles) do
			tw({v = lbl, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {TextTransparency = Tabs.IsCollapsed and 1 or 0.7}}):Play()
			local funcFrame = lbl.Parent
			if funcFrame then
				local padding = funcFrame:FindFirstChildOfClass("UIPadding")
				if padding then
					tw({v = padding, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {PaddingLeft = UDim.new(0, Tabs.IsCollapsed and 16 or 8)}}):Play()
				end
			end
		end
		
		if ProfileData and type(ProfileData) == "table" then
			local Profile_Container = Frame_6:FindFirstChild("Profile_Container")
			if Profile_Container then
				local NameLbl = Profile_Container:FindFirstChild("Username")
				local RoleLbl = Profile_Container:FindFirstChild("Email")
				local Avatar = Profile_Container:FindFirstChild("Avatar")
				
				if NameLbl then
					tw({v = NameLbl, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {TextTransparency = Tabs.IsCollapsed and 1 or 0}}):Play()
				end
				if RoleLbl then
					tw({v = RoleLbl, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {TextTransparency = Tabs.IsCollapsed and 1 or 0.5}}):Play()
				end
				if Avatar then
					local targetSize = Tabs.IsCollapsed and UDim2.new(0, 30, 0, 30) or UDim2.new(0, 35, 0, 35)
					local targetPos = Tabs.IsCollapsed and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0, 5, 0.5, 0)
					local targetAnchor = Tabs.IsCollapsed and Vector2.new(0.5, 0.5) or Vector2.new(0, 0.5)
					tw({v = Avatar, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = targetSize, Position = targetPos, AnchorPoint = targetAnchor}}):Play()
				end
				tw({v = Profile_Container, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {BackgroundTransparency = Tabs.IsCollapsed and 1 or 0.5}}):Play()
			end
		end
	end
	
	CollapseBtn.MouseButton1Click:Connect(ToggleSidebar)

	function Tabs:SelectTab(p)
		Tabs.DefaultIndex = p or 1
	end

	function Tabs:Line()
		local Frame = Instance.new("Frame")
		local Line = Instance.new("Frame")

		Frame.Parent = TabList_1
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BackgroundTransparency = 1.000
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new(1, 0, 0, 5)
		Frame.Name = 'Line'

		Line.Name = "Line"
		Line.Parent = Frame
		Line.AnchorPoint = Vector2.new(0.5, 0.5)
		Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Line.BackgroundTransparency = 0.900
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0.5, 0, 0.5, 0)
		Line.Size = UDim2.new(0.85, 0, 0, 1)
	end

	function Tabs:Tab(p)
		local Title = p.Title or 'null'
		local Icon = p.Icon or 10828062164
		local Tab_1 = Instance.new("Frame")
		local Title_3 = Instance.new("TextLabel")
		local UIListLayout_9 = Instance.new("UIListLayout")
		local ImageLabel_2 = Instance.new("ImageLabel")
		local UIPadding_14 = Instance.new("UIPadding")
		local UIStroke_2 = Instance.new("UIStroke")
		local Func = Instance.new("Frame")

		Tab_1.Name = "Tab"
		Tab_1.Parent = TabList_1
		Tab_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Tab_1.BackgroundTransparency = 1
		Tab_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Tab_1.BorderSizePixel = 0
		Tab_1.Size = UDim2.new(1, 0,0, 30)
		Tab_1.LayoutOrder = p.LayoutOrder or 0

		Func.Name = "Func"
		Func.Parent = Tab_1
		Func.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Func.BackgroundTransparency = 1.000
		Func.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Func.BorderSizePixel = 0
		Func.Size = UDim2.new(1, 0, 1, 0)

		Title_3.Name = "Title"
		Title_3.Parent = Func
		Title_3.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Title_3.BackgroundTransparency = 1
		Title_3.BorderColor3 = Color3.fromRGB(0,0,0)
		Title_3.BorderSizePixel = 0
		Title_3.LayoutOrder = 1
		Title_3.Size = UDim2.new(1, 0,1, 0)
		Title_3.Font = Enum.Font.GothamBold
		Title_3.Text = tostring(Title)
		Title_3.TextColor3 = Color3.fromRGB(255,255,255)
		Title_3.TextSize = 11
		Title_3.TextTransparency = Tabs.IsCollapsed and 1 or 0.7
		Title_3.TextWrapped = true
		Title_3.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(Tabs.TabTitles, Title_3)

		addToTheme('Text & Icon', Title_3)

		UIListLayout_9.Parent = Func
		UIListLayout_9.Padding = UDim.new(0,8)
		UIListLayout_9.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_9.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_9.VerticalAlignment = Enum.VerticalAlignment.Center

		ImageLabel_2.Parent = Func
		ImageLabel_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
		ImageLabel_2.BackgroundTransparency = 1
		ImageLabel_2.BorderColor3 = Color3.fromRGB(0,0,0)
		ImageLabel_2.BorderSizePixel = 0
		ImageLabel_2.Size = UDim2.new(0, 18,0, 18)
		ImageLabel_2.Image = gl(Icon).Image
		ImageLabel_2.ImageTransparency = 0.7
		ImageLabel_2.ImageRectSize = gl(Icon).ImageRectSize
		ImageLabel_2.ImageRectOffset = gl(Icon).ImageRectPosition

		addToTheme('Text & Icon', ImageLabel_2)

		UIPadding_14.Parent = Func
		UIPadding_14.PaddingLeft = UDim.new(0, Tabs.IsCollapsed and 16 or 8)

		UIStroke_2.Parent = Title_3
		UIStroke_2.Color = Color3.fromRGB(24,24,31)
		UIStroke_2.Thickness = 1
		UIStroke_2.Transparency = 0.95

		local InPage_1 = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local ScrollingFrame_1 = Instance.new("ScrollingFrame")
		local UIListLayout_1 = Instance.new("UIListLayout")
		local UIPadding_10 = Instance.new("UIPadding")

		InPage_1.Name = "InPage"
		InPage_1.Parent = Page_1
		InPage_1.AnchorPoint = Vector2.new(0.5 ,0.5)
		InPage_1.BackgroundColor3 = Color3.fromRGB(24,24,31)
		InPage_1.BorderColor3 = Color3.fromRGB(0,0,0)
		InPage_1.BorderSizePixel = 0
		InPage_1.Size = UDim2.new(1, 0,1, 0)
		InPage_1.Position = UDim2.new(0.5, 0, 0.5, 0)
		InPage_1.Visible = false

		addToTheme('Page', InPage_1)

		UICorner_2.Parent = InPage_1
		UICorner_2.CornerRadius = UDim.new(0,17)

		ScrollingFrame_1.Name = "ScrollingFrame"
		ScrollingFrame_1.Parent = InPage_1
		ScrollingFrame_1.Active = true
		ScrollingFrame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		ScrollingFrame_1.BackgroundTransparency = 1
		ScrollingFrame_1.BorderColor3 = Color3.fromRGB(0,0,0)
		ScrollingFrame_1.BorderSizePixel = 0
		ScrollingFrame_1.Size = UDim2.new(1, 0,1, 0)
		ScrollingFrame_1.ClipsDescendants = true
		ScrollingFrame_1.AutomaticCanvasSize = Enum.AutomaticSize.None
		ScrollingFrame_1.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
		ScrollingFrame_1.CanvasPosition = Vector2.new(0, 0)
		ScrollingFrame_1.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
		ScrollingFrame_1.HorizontalScrollBarInset = Enum.ScrollBarInset.None
		ScrollingFrame_1.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
		ScrollingFrame_1.ScrollBarImageTransparency = 0
		ScrollingFrame_1.ScrollBarThickness = 0
		ScrollingFrame_1.ScrollingDirection = Enum.ScrollingDirection.XY
		ScrollingFrame_1.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
		ScrollingFrame_1.VerticalScrollBarInset = Enum.ScrollBarInset.None
		ScrollingFrame_1.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

		UIListLayout_1.Parent = ScrollingFrame_1
		UIListLayout_1.Padding = UDim.new(0,5)
		UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder

		UIPadding_10.Parent = InPage_1
		UIPadding_10.PaddingBottom = UDim.new(0,10)
		UIPadding_10.PaddingLeft = UDim.new(0,10)
		UIPadding_10.PaddingRight = UDim.new(0,10)
		UIPadding_10.PaddingTop = UDim.new(0,10)

		local Click = click(Tab_1)

		local DockBtn = nil
		if Tabs.ReopenBreadcrumb then
			local Crumb = Tabs.ReopenBreadcrumb:FindFirstChild("BackgroundCloseUI")
			if Crumb then Crumb = Crumb:FindFirstChild("Crumb") end
			if Crumb then
				DockBtn = Instance.new("ImageButton")
				DockBtn.Name = "DockBtn_" .. Title
				DockBtn.Parent = Crumb
				DockBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				DockBtn.BackgroundTransparency = 1
				DockBtn.Size = UDim2.new(0, 24, 0, 24)
				DockBtn.LayoutOrder = p.LayoutOrder or (10 + #self.List)
				DockBtn.Image = ImageLabel_2.Image
				DockBtn.ImageRectSize = ImageLabel_2.ImageRectSize
				DockBtn.ImageRectOffset = ImageLabel_2.ImageRectOffset
				DockBtn.ImageColor3 = themes[IsTheme]['Text & Icon']
				DockBtn.ZIndex = 50
				addToTheme('Text & Icon', DockBtn)
				
				DockBtn.MouseEnter:Connect(function()
					TooltipLabel.Text = Title
					local ts = _Services.TextService
					local textBounds = ts:GetTextSize(Title, 12, Enum.Font.GothamMedium, Vector2.new(1000, 24))
					TooltipFrame.Size = UDim2.new(0, textBounds.X + 16, 0, 24)
					
					local absPos = DockBtn.AbsolutePosition
					local absSize = DockBtn.AbsoluteSize
					if CrumbOrientation == "Bottom" then
						TooltipFrame.Position = UDim2.new(0, absPos.X + absSize.X/2, 0, absPos.Y - 5)
						TooltipFrame.AnchorPoint = Vector2.new(0.5, 1)
					elseif CrumbOrientation == "Top" then
						TooltipFrame.Position = UDim2.new(0, absPos.X + absSize.X/2, 0, absPos.Y + absSize.Y + 5)
						TooltipFrame.AnchorPoint = Vector2.new(0.5, 0)
					elseif CrumbOrientation == "Left" then
						TooltipFrame.Position = UDim2.new(0, absPos.X + absSize.X + 5, 0, absPos.Y + absSize.Y/2)
						TooltipFrame.AnchorPoint = Vector2.new(0, 0.5)
					elseif CrumbOrientation == "Right" then
						TooltipFrame.Position = UDim2.new(0, absPos.X - 5, 0, absPos.Y + absSize.Y/2)
						TooltipFrame.AnchorPoint = Vector2.new(1, 0.5)
					end
					
					TooltipFrame.Visible = true
					tw({v = TooltipFrame, t = 0.2, s = Enum.EasingStyle.Exponential, d = "Out", g = {BackgroundTransparency = 0}}):Play()
					tw({v = TooltipLabel, t = 0.2, s = Enum.EasingStyle.Exponential, d = "Out", g = {TextTransparency = 0}}):Play()
				end)
				
				DockBtn.MouseLeave:Connect(function()
					tw({v = TooltipFrame, t = 0.2, s = Enum.EasingStyle.Exponential, d = "Out", g = {BackgroundTransparency = 1}}):Play()
					tw({v = TooltipLabel, t = 0.2, s = Enum.EasingStyle.Exponential, d = "Out", g = {TextTransparency = 1}}):Play()
				end)
			end
		end

		table.insert(self.List, {
			Page = InPage_1,
			Button = Tab_1,
			DockBtn = DockBtn
		})
		local MyIndex = #self.List

		local function twSelect()
			local scrollingFrame = Select_1.Parent
			local tabScrollingFrame = Tab_1.Parent

			local tabCenterY = Tab_1.AbsolutePosition.Y + (Tab_1.AbsoluteSize.Y / 2)
			local selectOffset = Select_1.AbsoluteSize.Y / 2
			local relativeY = tabCenterY - tabScrollingFrame.AbsolutePosition.Y
			local offset = scrollingFrame.AbsolutePosition.Y - Select_1.Parent.AbsolutePosition.Y

			local targetY = relativeY + offset - selectOffset

			local pos = UDim2.new(0, Select_1.Position.X.Offset, 0, targetY)

			tw({
				v = Select_1,
				t = 0.5,
				s = Enum.EasingStyle.Exponential,
				d = "Out",
				g = {
					Position = pos
				}
			}):Play()
		end

		local function chg()
			for i, v in pairs(self.List) do
				v.Page.Visible = false
				for i, v in pairs(ScrollingFrame_1:GetChildren()) do
					if v:IsA('Frame') and v:FindFirstChild('Background') then
						v.Background.Position = UDim2.new(0, 0, 0,0)
						v.Background.AnchorPoint = Vector2.new(1 ,0)
					end
				end
				task.spawn(function()
					for i, v in next, ScrollingFrame_1:GetChildren() do
						if v:IsA('Frame') and v:FindFirstChild('Background') then
							tw({
								v = v.Background,
								t = 0.3,
								s = Enum.EasingStyle.Exponential,
								d = "InOut",
								g = {AnchorPoint = Vector2.new(0 ,0)}
							}):Play()
							task.wait(.05)
						end
					end
				end)
				InPage_1.Visible = true
			end
			for i, v in pairs(TabList_1:GetChildren()) do
				if v:IsA('Frame') and v.Name ~= 'Line' then
					tw({
						v = v.Func.Title,
						t = 0.15,
						s = Enum.EasingStyle.Linear,
						d = "InOut",
						g = {TextTransparency = Tabs.IsCollapsed and 1 or 0.7, TextColor3 = themes[IsTheme]['Text & Icon']}
					}):Play()
					tw({
						v = v.Func.ImageLabel,
						t = 0.15,
						s = Enum.EasingStyle.Linear,
						d = "InOut",
						g = {ImageTransparency = 0.7, ImageColor3 = themes[IsTheme]['Text & Icon']}
					}):Play()
				end
			end
			for i, v in pairs(self.List) do
				if v.DockBtn then
					tw({
						v = v.DockBtn,
						t = 0.15,
						s = Enum.EasingStyle.Linear,
						d = "InOut",
						g = {ImageTransparency = 0.7, ImageColor3 = themes[IsTheme]['Text & Icon']}
					}):Play()
				end
			end
			Tabs.ActiveTabTitle = Title_3
			Tabs.ActiveTabIcon = ImageLabel_2
			Tabs.ActiveDockBtn = DockBtn
			tw({
				v = Title_3,
				t = 0.15,
				s = Enum.EasingStyle.Linear,
				d = "InOut",
				g = {TextTransparency = Tabs.IsCollapsed and 1 or 0, TextColor3 = Color3.fromRGB(255, 255, 255)}
			}):Play()
			tw({
				v = ImageLabel_2,
				t = 0.15,
				s = Enum.EasingStyle.Linear,
				d = "InOut",
				g = {ImageTransparency = 0, ImageColor3 = themes[IsTheme].Main}
			}):Play()
			if DockBtn then
				tw({
					v = DockBtn,
					t = 0.15,
					s = Enum.EasingStyle.Linear,
					d = "InOut",
					g = {ImageTransparency = 0, ImageColor3 = themes[IsTheme].Main}
				}):Play()
			end
			Page_1.Visible = true
			twSelect()
		end

		Click.MouseButton1Click:Connect(chg)

		if DockBtn then
			DockBtn.MouseButton1Down:Connect(function()
				-- Flash red to confirm click registered
				local prevColor = DockBtn.ImageColor3
				DockBtn.ImageColor3 = Color3.fromRGB(255, 0, 0)
				delay(0.2, function()
					DockBtn.ImageColor3 = prevColor
				end)

				task.spawn(function()
					if Tabs.closeui then pcall(Tabs.closeui) end
					pcall(chg)
				end)
			end)
		end
		changecanvas(ScrollingFrame_1, UIListLayout_1, 5)

		delay(.1, function()
			if not self.Value then
				local total = #self.List
				local index = self.DefaultIndex

				if type(index) ~= "number" or index < 1 or index > total then
					index = 1
				end

				if MyIndex == index then
					chg()
					self.Value = true
				end
			end
		end)

		local Func = {}

		function Func:Section(p)
			local Title = p.Title or 'null'
			local RealBackground = Instance.new("Frame")
			local Section = Instance.new("Frame")
			local Section_1 = Instance.new("TextLabel")
			local UIPadding_1 = Instance.new("UIPadding")

			RealBackground.Name = "Real Background"
			RealBackground.Parent = ScrollingFrame_1
			RealBackground.BackgroundTransparency = 1
			RealBackground.BorderColor3 = Color3.fromRGB(0,0,0)
			RealBackground.BorderSizePixel = 0
			RealBackground.Size = UDim2.new(1, 0,0, 20)
			RealBackground.ClipsDescendants = true

			Section.Name = "Background"
			Section.Parent = RealBackground
			Section.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Section.BackgroundTransparency = 1
			Section.BorderColor3 = Color3.fromRGB(0,0,0)
			Section.BorderSizePixel = 0
			Section.Size = UDim2.new(1, 0,0, 20)

			Section_1.Name = "Section"
			Section_1.Parent = Section
			Section_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Section_1.BackgroundTransparency = 1
			Section_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Section_1.BorderSizePixel = 0
			Section_1.Size = UDim2.new(1, 0,0, 20)
			Section_1.Font = Enum.Font.GothamBold
			Section_1.Text = Title
			Section_1.TextColor3 = Color3.fromRGB(255,255,255)
			Section_1.TextSize = 12
			Section_1.TextXAlignment = Enum.TextXAlignment.Left

			addToTheme('Text & Icon', Section_1)

			UIPadding_1.Parent = Section
			UIPadding_1.PaddingLeft = UDim.new(0,5)
			UIPadding_1.PaddingRight = UDim.new(0,5)

			local New = {}

			function New:SetTitle(t)
				Section_1.Text = t
			end

			return New
		end

		function Func:Toggle(p)
			local Value = p.Value or false
			local Image = p.Image or ''
			local Callback = p.Callback or function() end
			local Title = p.Title or 'null'
			local Desc = p.Desc or ''

			local Toggle, Config = background(ScrollingFrame_1, Title, Desc, Image, 'Toggle')

			local F_1 = Instance.new("Frame")
			local UIListLayout_1 = Instance.new("UIListLayout")
			local UIPadding_1 = Instance.new("UIPadding")
			local Frame_1 = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local Frame_2 = Instance.new("Frame")
			local UICorner_3 = Instance.new("UICorner")
			local UIPadding_2 = Instance.new("UIPadding")

			F_1.Name = "F"
			F_1.Parent = Toggle
			F_1.AnchorPoint = Vector2.new(1, 0.5)
			F_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			F_1.BackgroundTransparency = 1
			F_1.BorderColor3 = Color3.fromRGB(0,0,0)
			F_1.BorderSizePixel = 0
			F_1.Position = UDim2.new(1, 0,0.5, 0)
			F_1.Size = UDim2.new(0, 100,0.800000012, 0)

			UIListLayout_1.Parent = F_1
			UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Right
			UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

			UIPadding_1.Parent = F_1
			UIPadding_1.PaddingRight = UDim.new(0,13)

			Frame_1.Parent = F_1
			Frame_1.BackgroundColor3 = Color3.fromRGB(36, 35, 48)
			Frame_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Frame_1.BorderSizePixel = 0
			Frame_1.Size = UDim2.new(0, 34,0, 17)

			UICorner_2.Parent = Frame_1
			UICorner_2.CornerRadius = UDim.new(1,0)

			Frame_2.Parent = Frame_1
			Frame_2.AnchorPoint = Vector2.new(0, 0.5)
			Frame_2.BackgroundColor3 = Color3.fromRGB(44, 42, 62)
			Frame_2.BorderColor3 = Color3.fromRGB(0,0,0)
			Frame_2.BorderSizePixel = 0
			Frame_2.Position = UDim2.new(0, 0,0.5, 0)
			Frame_2.Size = UDim2.new(0, 13,0, 13)

			if Value then
				Frame_1.BackgroundColor3 = themes[IsTheme].Function.Toggle.True['Toggle Background']
				Frame_2.BackgroundColor3 = themes[IsTheme].Function.Toggle.True['Toggle Value']
			else
				Frame_1.BackgroundColor3 = themes[IsTheme].Function.Toggle.False['Toggle Background']
				Frame_2.BackgroundColor3 = themes[IsTheme].Function.Toggle.False['Toggle Value']
			end

			UICorner_3.Parent = Frame_2
			UICorner_3.CornerRadius = UDim.new(1,0)

			UIPadding_2.Parent = Frame_1
			UIPadding_2.PaddingLeft = UDim.new(0,2)
			UIPadding_2.PaddingRight = UDim.new(0,2)

			local Click = click(Toggle)

			Value = not Value

			local function change()
				Value = not Value
				if Value then
					Config:SetTextTransparencyTitle(0)
					tw({v = Frame_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {BackgroundColor3 = themes[IsTheme].Function.Toggle.True['Toggle Background']}}):Play()
					tw({v = Frame_2, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out",
						g = {
							BackgroundColor3 = themes[IsTheme].Function.Toggle.True['Toggle Value'],
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, 0,0.5, 0)
						}}):Play()
				else
					Config:SetTextTransparencyTitle(0.7)
					tw({v = Frame_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {BackgroundColor3 = themes[IsTheme].Function.Toggle.False['Toggle Background']}}):Play()
					tw({v = Frame_2, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out",
						g = {
							BackgroundColor3 = themes[IsTheme].Function.Toggle.False['Toggle Value'],
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(0, 0,0.5, 0)
						}}):Play()
				end
				pcall(Callback, Value)
			end

			Toggle:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
				if Value then
					Frame_1.BackgroundColor3 = themes[IsTheme].Function.Toggle.True['Toggle Background']
					Frame_2.BackgroundColor3 = themes[IsTheme].Function.Toggle.True['Toggle Value']
				else
					Frame_1.BackgroundColor3 = themes[IsTheme].Function.Toggle.False['Toggle Background']
					Frame_2.BackgroundColor3 = themes[IsTheme].Function.Toggle.False['Toggle Value']
				end
			end)

			Click.MouseButton1Click:Connect(change)

			delay(0.1, change)

			local New = {}

			function New:SetTitle(t)
				Config:SetTitle(t)
			end

			function New:SetDesc(t)
				Config:SetDesc(t)
			end

			function New:SetVisible(t)
				Toggle.Visible = t
			end

			function New:SetValue(t)
				Value = not t
				change()
			end

			return New
		end

		function Func:Label(p)
			local Title = p.Title or 'null'
			local Desc = p.Desc or ''
			local Image = p.Image or ''

			local Label, Config = background(ScrollingFrame_1, Title, Desc, Image, 'Label')

			Config:SetTextTransparencyTitle(0)
			Config:SetSizeT(0)

			local New = {}

			function New:SetTitle(t)
				Config:SetTitle(t)
			end

			function New:SetDesc(t)
				Config:SetDesc(t)
			end

			function New:SetVisible(t)
				Label.Visible = t
			end

			return New
		end

		function Func:Paragraph(p)
			local Title = p.Title or 'null'
			local Desc = p.Content or p.Desc or ''
			local Image = p.Image or ''

			local Label, Config = background(ScrollingFrame_1, Title, Desc, Image, 'Label')

			Config:SetTextTransparencyTitle(0)
			Config:SetSizeT(0)

			local New = {}

			function New:SetTitle(t)
				Config:SetTitle(t)
			end

			function New:SetDesc(t)
				Config:SetDesc(t)
			end
			
			function New:SetContent(t)
				Config:SetDesc(t)
			end

			function New:SetVisible(t)
				Label.Visible = t
			end

			return New
		end

		function Func:Button(p)
			local Title = p.Title or 'null'
			local Desc = p.Desc or ''
			local Image = p.Image or ''
			local Callback = p.Callback or function() end

			local Button, Config = background(ScrollingFrame_1, Title, Desc, Image, 'Button')

			Config:SetTextTransparencyTitle(0)
			Config:SetSizeT(50)

			Button.ClipsDescendants = true

			local F = Instance.new("Frame")
			local UIListLayout_1 = Instance.new("UIListLayout")
			local UIPadding_1 = Instance.new("UIPadding")
			local Image_1 = Instance.new("ImageLabel")

			F.Name = "F"
			F.Parent = Button
			F.AnchorPoint = Vector2.new(1, 0.5)
			F.BackgroundColor3 = Color3.fromRGB(255,255,255)
			F.BackgroundTransparency = 1
			F.BorderColor3 = Color3.fromRGB(0,0,0)
			F.BorderSizePixel = 0
			F.Position = UDim2.new(1, 0,0.5, 0)
			F.Size = UDim2.new(0, 50,0.800000012, 0)

			UIListLayout_1.Parent = F
			UIListLayout_1.Padding = UDim.new(0,8)
			UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Right
			UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

			UIPadding_1.Parent = F
			UIPadding_1.PaddingRight = UDim.new(0,13)

			Image_1.Name = "Image"
			Image_1.Parent = F
			Image_1.AnchorPoint = Vector2.new(1, 0.5)
			Image_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Image_1.BackgroundTransparency = 1
			Image_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Image_1.BorderSizePixel = 0
			Image_1.Position = UDim2.new(1, 0,0.5, 0)
			Image_1.Size = UDim2.new(0, 20,0, 20)
			Image_1.Image = GetAsset("14923748517")
			Image_1.ImageTransparency = 0.3

			local Click = click(Button)
			Click.MouseButton1Click:Connect(function()
				Button.AnchorPoint = Vector2.new(0.5, 0.5)
				Button.Position = UDim2.new(0.5, 0, 0.5,0)
				jc(Click, Button)
				tw({v = Button, t = 0.15, s = Enum.EasingStyle.Back, d = "Out", g = {Size = UDim2.new(.9, 0,.9, 0)}}):Play()
				delay(.06, function()
					tw({v = Button, t = 0.15, s = Enum.EasingStyle.Back, d = "Out", g = {Size = UDim2.new(1, 0,1, 0)}}):Play()
				end)
				pcall(Callback)
			end)

			local New = {}

			function New:SetTitle(t)
				Config:SetTitle(t)
			end

			function New:SetDesc(t)
				Config:SetDesc(t)
			end

			function New:SetVisible(t)
				Button.Visible = t
			end

			function New:SetEnabled(t)
				Click.Active = not not t
			end

			function New:SetCallback(fn)
				Callback = fn or function() end
			end

			return New
		end

		function Func:Slider(p)
			local Title = p.Title or 'null'
			local Desc = p.Desc or ''
			local Image = p.Image or ''
			local Min = p.Min or 0
			local Max = p.Max or 100
			local Value = p.Value or Min + 1
			local Rounding = p.Rounding or 0
			local Callback = p.Callback or function() end

			local Slider, Config = background(ScrollingFrame_1, Title, Desc, Image, 'Slider')

			Config:SetTextTransparencyTitle(0)
			Config:SetSizeT(200)

			local F = Instance.new("Frame")
			local UIListLayout_1 = Instance.new("UIListLayout")
			local UIPadding_1 = Instance.new("UIPadding")
			local FrameValueTextBox = Instance.new('Frame')
			local TextBox_1 = Instance.new("TextBox")
			local UICorner_1 = Instance.new("UICorner")
			local UIStroke_1 = Instance.new("UIStroke")
			local Frame_1 = Instance.new("Frame")
			local Frame_2 = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local Frame_3 = Instance.new("Frame")
			local UICorner_3 = Instance.new("UICorner")
			local Frame_4 = Instance.new("Frame")
			local UICorner_4 = Instance.new("UICorner")
			local UIPadding_2 = Instance.new("UIPadding")

			F.Name = "F"
			F.Parent = Slider
			F.AnchorPoint = Vector2.new(1, 0.5)
			F.BackgroundColor3 = Color3.fromRGB(255,255,255)
			F.BackgroundTransparency = 1
			F.BorderColor3 = Color3.fromRGB(0,0,0)
			F.BorderSizePixel = 0
			F.Position = UDim2.new(1, 0,0.5, 0)
			F.Size = UDim2.new(0, 195,0.8, 0)

			UIListLayout_1.Parent = F
			UIListLayout_1.Padding = UDim.new(0,8)
			UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Right
			UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

			UIPadding_1.Parent = F
			UIPadding_1.PaddingRight = UDim.new(0,13)

			FrameValueTextBox.Parent = F
			FrameValueTextBox.Active = true
			FrameValueTextBox.BackgroundColor3 = Color3.fromRGB(24,24,31)
			FrameValueTextBox.BorderColor3 = Color3.fromRGB(0,0,0)
			FrameValueTextBox.BorderSizePixel = 0
			FrameValueTextBox.Size = UDim2.new(0, 50,0, 20)
			FrameValueTextBox.LayoutOrder = 1

			addToTheme('Function.Slider.Value Background', FrameValueTextBox)

			TextBox_1.Parent = FrameValueTextBox
			TextBox_1.Active = true
			TextBox_1.BackgroundTransparency = 1
			TextBox_1.BorderColor3 = Color3.fromRGB(0,0,0)
			TextBox_1.BorderSizePixel = 0
			TextBox_1.Size = UDim2.new(1, 0,1, 0)
			TextBox_1.Font = Enum.Font.Cartoon
			TextBox_1.PlaceholderColor3 = Color3.fromRGB(178,178,178)
			TextBox_1.PlaceholderText = ""
			TextBox_1.Text = tonumber(Value)
			TextBox_1.TextColor3 = Color3.fromRGB(255,255,255)
			TextBox_1.TextSize = 12

			addToTheme('Text & Icon', TextBox_1)

			UICorner_1.Parent = FrameValueTextBox
			UICorner_1.CornerRadius = UDim.new(0,4)

			UIStroke_1.Parent = FrameValueTextBox
			UIStroke_1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			UIStroke_1.Color = Color3.fromRGB(255,255,255)
			UIStroke_1.Thickness = 1
			UIStroke_1.Transparency = 0.95

			addToTheme('Function.Slider.Value Stroke', UIStroke_1)

			Frame_1.Parent = F
			Frame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Frame_1.BackgroundTransparency = 1
			Frame_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Frame_1.BorderSizePixel = 0
			Frame_1.Size = UDim2.new(0, 120,0, 20)

			Frame_2.Parent = Frame_1
			Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
			Frame_2.BackgroundColor3 = Color3.fromRGB(44,34,103)
			Frame_2.BorderColor3 = Color3.fromRGB(0,0,0)
			Frame_2.BorderSizePixel = 0
			Frame_2.Position = UDim2.new(0.5, 0,0.5, 0)
			Frame_2.Size = UDim2.new(1, 0,0, 10)

			addToTheme('Function.Slider.Slider Bar', Frame_2)

			UICorner_2.Parent = Frame_2
			UICorner_2.CornerRadius = UDim.new(1,0)

			Frame_3.Parent = Frame_2
			Frame_3.AnchorPoint = Vector2.new(0, 0.5)
			Frame_3.BackgroundColor3 = Color3.fromRGB(91,68,209)
			Frame_3.BorderColor3 = Color3.fromRGB(0,0,0)
			Frame_3.BorderSizePixel = 0
			Frame_3.Position = UDim2.new(0, 0,0.5, 0)
			Frame_3.Size = UDim2.new(0, 0,1, 0)

			addToTheme('Function.Slider.Slider Bar Value', Frame_3)

			UICorner_3.Parent = Frame_3
			UICorner_3.CornerRadius = UDim.new(1,0)

			Frame_4.Parent = Frame_3
			Frame_4.AnchorPoint = Vector2.new(1, 0.5)
			Frame_4.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Frame_4.BorderColor3 = Color3.fromRGB(0,0,0)
			Frame_4.BorderSizePixel = 0
			Frame_4.Position = UDim2.new(1, 0,0.5, 0)
			Frame_4.Size = UDim2.new(0, 13,0, 13)

			addToTheme('Function.Slider.Circle Value', Frame_4)

			UICorner_4.Parent = Frame_4
			UICorner_4.CornerRadius = UDim.new(1,0)

			UIPadding_2.Parent = Frame_2
			UIPadding_2.PaddingBottom = UDim.new(0,2)
			UIPadding_2.PaddingLeft = UDim.new(0,2)
			UIPadding_2.PaddingRight = UDim.new(0,2)
			UIPadding_2.PaddingTop = UDim.new(0,2)

			local Click = click(Frame_1)

			local function roundToDecimal(value, decimals)
				local factor = 10 ^ decimals
				return math.floor(value * factor + 0.5) / factor
			end

			local function updateSlider(value)
				value = math.clamp(value, Min, Max)
				value = roundToDecimal(value, Rounding)
				Value = value
				local va = (value - Min) / (Max - Min)
				tw({v = Frame_3, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(math.clamp(va, 0.12, 1), 0, 1, 0)}}):Play()
				TextBox_1.Text = tostring(roundToDecimal(value, Rounding))
				pcall(Callback ,value)
			end

			updateSlider(Value or 0)

			TextBox_1.FocusLost:Connect(function()
				local value = tonumber(TextBox_1.Text) or Min
				updateSlider(value)
			end)

			local function move(input)
				local sliderBar = Frame_2
				local relativeX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
				local value = relativeX * (Max - Min) + Min
				updateSlider(value)
			end

			local dragging = false

			Click.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					move(input)
				end
			end)

			Click.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)

			U.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					move(input)
				end
			end)

			local New = {}

			function New:SetTitle(t)
				Config:SetTitle(t)
			end

			function New:SetDesc(t)
				Config:SetDesc(t)
			end

			function New:SetVisible(t)
				Slider.Visible = t
			end

			function New:SetValue(t)
				updateSlider(t)
			end

			function New:SetMin(t)
				Min = t
				if Value < t then
					updateSlider(t)
				end
			end

			function New:SetMax(t)
				Max = t
				if Value > t then
					updateSlider(t)
				end
			end

			return New
		end

		function Func:Code(p)
			local Title = p.Title or 'null'
			local CodeText = p.Code or '-- print("Hello World")'

			local RealBackground = Instance.new("Frame")
			local Code = Instance.new("Frame")
			local UICorner_1 = Instance.new("UICorner")
			local FF_1 = Instance.new("Frame")
			local UIPadding_1 = Instance.new("UIPadding")
			local F_1 = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local Frame_1 = Instance.new("Frame")
			local UIPadding_2 = Instance.new("UIPadding")
			local Frame_2 = Instance.new("Frame")
			local UIPadding_3 = Instance.new("UIPadding")
			local TextBox_2 = Instance.new("TextLabel")
			local Top_1 = Instance.new("Frame")
			local Left_1 = Instance.new("Frame")
			local Whatisthis_1 = Instance.new("ImageLabel")
			local UIListLayout_1 = Instance.new("UIListLayout")
			local Frame_3 = Instance.new("Frame")
			local Frame_4 = Instance.new("Frame")
			local UICorner_3 = Instance.new("UICorner")
			local UIListLayout_2 = Instance.new("UIListLayout")
			local UIPadding_4 = Instance.new("UIPadding")
			local TextLabel_1 = Instance.new("TextLabel")
			local Right_1 = Instance.new("Frame")
			local UIListLayout_3 = Instance.new("UIListLayout")
			local Frame_5 = Instance.new("Frame")
			local TextButton_1 = Instance.new("TextButton")
			local UIPadding_5 = Instance.new("UIPadding")
			local ImageLabel_1 = Instance.new("ImageLabel")
			local UIGradient_1 = Instance.new("UIGradient")

			RealBackground.Name = "Real Background"
			RealBackground.Parent = ScrollingFrame_1
			RealBackground.BackgroundTransparency = 1
			RealBackground.BorderColor3 = Color3.fromRGB(0,0,0)
			RealBackground.BorderSizePixel = 0
			RealBackground.Size = UDim2.new(1, 0,0, 120)
			RealBackground.ClipsDescendants = true

			Code.Name = "Background"
			Code.Parent = RealBackground
			Code.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Code.BorderColor3 = Color3.fromRGB(0,0,0)
			Code.BorderSizePixel = 0
			Code.Size = UDim2.new(1, 0,1, 0)
			Code.ClipsDescendants = true

			UICorner_1.Parent = Code

			FF_1.Name = "FF"
			FF_1.Parent = Code
			FF_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			FF_1.BackgroundTransparency = 1
			FF_1.BorderColor3 = Color3.fromRGB(0,0,0)
			FF_1.BorderSizePixel = 0
			FF_1.Size = UDim2.new(1, 0,1, 0)

			UIPadding_1.Parent = FF_1
			UIPadding_1.PaddingBottom = UDim.new(0,8)
			UIPadding_1.PaddingLeft = UDim.new(0,8)
			UIPadding_1.PaddingRight = UDim.new(0,8)
			UIPadding_1.PaddingTop = UDim.new(0,8)

			F_1.Name = "F"
			F_1.Parent = FF_1
			F_1.AnchorPoint = Vector2.new(0, 0.5)
			F_1.BackgroundColor3 = Color3.fromRGB(51,62,68)
			F_1.BorderColor3 = Color3.fromRGB(0,0,0)
			F_1.BorderSizePixel = 0
			F_1.Position = UDim2.new(0, 0,0.5, 0)
			F_1.Size = UDim2.new(1, 0,1, 0)
			F_1.ClipsDescendants = true

			addToTheme('Function.Code.Background Code', F_1)

			UICorner_2.Parent = F_1

			Frame_1.Parent = F_1
			Frame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Frame_1.BackgroundTransparency = 1
			Frame_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Frame_1.BorderSizePixel = 0
			Frame_1.Size = UDim2.new(1, 0,1, 0)

			UIPadding_2.Parent = Frame_1
			UIPadding_2.PaddingTop = UDim.new(0,30)

			Frame_2.Parent = Frame_1
			Frame_2.BackgroundColor3 = Color3.fromRGB(38, 50, 56)
			Frame_2.BorderColor3 = Color3.fromRGB(0,0,0)
			Frame_2.BorderSizePixel = 0
			Frame_2.Size = UDim2.new(1, 0,1, 0)

			addToTheme('Function.Code.Background Code Value', Frame_2)

			Instance.new('UICorner', Frame_2)

			UIPadding_3.Parent = Frame_2
			UIPadding_3.PaddingBottom = UDim.new(0,5)
			UIPadding_3.PaddingLeft = UDim.new(0,8)
			UIPadding_3.PaddingRight = UDim.new(0,8)
			UIPadding_3.PaddingTop = UDim.new(0,8)

			local ScrollingFrame = Instance.new("ScrollingFrame")

			ScrollingFrame.Parent = Frame_2
			ScrollingFrame.Active = true
			ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ScrollingFrame.BackgroundTransparency = 1.000
			ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
			ScrollingFrame.CanvasSize = UDim2.new(2, 0, 0, 0)
			ScrollingFrame.ScrollBarThickness = 4
			ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(216, 150, 179)

			addToTheme('Function.Code.ScrollingFrame Code', ScrollingFrame)

			local Code_1 = Instance.new("Frame")
			local UIPaddingCode_1 = Instance.new("UIPadding")

			Code_1.Name = "Code"
			Code_1.Parent = ScrollingFrame
			Code_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Code_1.BackgroundTransparency = 1
			Code_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Code_1.BorderSizePixel = 0
			Code_1.Size = UDim2.new(1, 0,1, 0)

			UIPaddingCode_1.Name = "UIPaddingCode"
			UIPaddingCode_1.Parent = Code_1
			UIPaddingCode_1.PaddingLeft = UDim.new(0,20)

			TextBox_2.Name = "TextBox"
			TextBox_2.Parent = Code_1
			TextBox_2.Active = true
			TextBox_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextBox_2.BackgroundTransparency = 1
			TextBox_2.BorderColor3 = Color3.fromRGB(0,0,0)
			TextBox_2.BorderSizePixel = 0
			TextBox_2.Size = UDim2.new(0, 0,0, 0)
			TextBox_2.Font = Enum.Font.Code
			TextBox_2.RichText = true
			TextBox_2.TextColor3 = Color3.fromRGB(255,255,255)
			TextBox_2.TextSize = 12
			TextBox_2.TextXAlignment = Enum.TextXAlignment.Left
			TextBox_2.TextYAlignment = Enum.TextYAlignment.Top
			TextBox_2.Text = CodeText
			TextBox_2.AutomaticSize = Enum.AutomaticSize.XY

			addToTheme('Text & Icon', TextBox_2)

			Top_1.Name = "Top"
			Top_1.Parent = F_1
			Top_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Top_1.BackgroundTransparency = 1
			Top_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Top_1.BorderSizePixel = 0
			Top_1.Size = UDim2.new(1, 0,0, 30)

			Left_1.Name = "Left"
			Left_1.Parent = Top_1
			Left_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Left_1.BackgroundTransparency = 1
			Left_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Left_1.BorderSizePixel = 0
			Left_1.Size = UDim2.new(1, 0,1, 0)

			Whatisthis_1.Name = "Whatisthis"
			Whatisthis_1.Parent = Left_1
			Whatisthis_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Whatisthis_1.BackgroundTransparency = 1
			Whatisthis_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Whatisthis_1.BorderSizePixel = 0
			Whatisthis_1.Size = UDim2.new(0, 50,0, 13)
			Whatisthis_1.Image = GetAsset("81518443444327")
			Whatisthis_1.ScaleType = Enum.ScaleType.Fit

			UIListLayout_1.Parent = Left_1
			UIListLayout_1.Padding = UDim.new(0,5)
			UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

			Frame_3.Parent = Left_1
			Frame_3.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Frame_3.BackgroundTransparency = 1
			Frame_3.BorderColor3 = Color3.fromRGB(0,0,0)
			Frame_3.BorderSizePixel = 0
			Frame_3.Size = UDim2.new(0, 100,0, 30)

			Frame_4.Parent = Frame_3
			Frame_4.BackgroundColor3 = Color3.fromRGB(37, 49, 55)
			Frame_4.BorderColor3 = Color3.fromRGB(0,0,0)
			Frame_4.BorderSizePixel = 0
			Frame_4.Position = UDim2.new(0, 0,0.15, 0)
			Frame_4.Size = UDim2.new(1, 0,0, 30)

			addToTheme('Function.Code.Background Code Value', Frame_4)

			addToTheme('Function.Code.Background Value', Frame_4)

			UICorner_3.Parent = Frame_4

			UIListLayout_2.Parent = Frame_4
			UIListLayout_2.Padding = UDim.new(0,5)
			UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

			UIPadding_4.Parent = Frame_4
			UIPadding_4.PaddingLeft = UDim.new(0,8)
			UIPadding_4.PaddingRight = UDim.new(0,8)

			TextLabel_1.Parent = Frame_4
			TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextLabel_1.BackgroundTransparency = 1
			TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
			TextLabel_1.BorderSizePixel = 0
			TextLabel_1.Size = UDim2.new(1, 0,0, 25)
			TextLabel_1.Font = Enum.Font.GothamBold
			TextLabel_1.Text = tostring(Title)
			TextLabel_1.TextColor3 = Color3.fromRGB(255,255,255)
			TextLabel_1.TextSize = 11

			addToTheme('Text & Icon', TextLabel_1)

			Right_1.Name = "Right"
			Right_1.Parent = Top_1
			Right_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Right_1.BackgroundTransparency = 1
			Right_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Right_1.BorderSizePixel = 0
			Right_1.Size = UDim2.new(1, 0,1, 0)

			UIListLayout_3.Parent = Right_1
			UIListLayout_3.Padding = UDim.new(0,5)
			UIListLayout_3.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Right
			UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_3.VerticalAlignment = Enum.VerticalAlignment.Center

			Frame_5.Parent = Right_1
			Frame_5.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Frame_5.BackgroundTransparency = 1
			Frame_5.BorderColor3 = Color3.fromRGB(0,0,0)
			Frame_5.BorderSizePixel = 0
			Frame_5.Size = UDim2.new(0, 60,0, 30)

			TextButton_1.Parent = Frame_5
			TextButton_1.Active = true
			TextButton_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextButton_1.BackgroundTransparency = 1
			TextButton_1.BorderColor3 = Color3.fromRGB(0,0,0)
			TextButton_1.BorderSizePixel = 0
			TextButton_1.Size = UDim2.new(1, 0,1, 0)
			TextButton_1.Font = Enum.Font.GothamBold
			TextButton_1.Text = "Copy"
			TextButton_1.TextColor3 = Color3.fromRGB(255,255,255)
			TextButton_1.TextSize = 11
			TextButton_1.TextTransparency = 0.5
			TextButton_1.TextXAlignment = Enum.TextXAlignment.Right

			UIPadding_5.Parent = Frame_5
			UIPadding_5.PaddingRight = UDim.new(0,10)

			ImageLabel_1.Parent = Frame_5
			ImageLabel_1.AnchorPoint = Vector2.new(0, 0.5)
			ImageLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ImageLabel_1.BackgroundTransparency = 1
			ImageLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ImageLabel_1.BorderSizePixel = 0
			ImageLabel_1.Position = UDim2.new(0, 0,0.5, 0)
			ImageLabel_1.Size = UDim2.new(0, 16,0, 16)
			ImageLabel_1.Image = GetAsset("13847222481")
			ImageLabel_1.ImageTransparency = 0.5

			UIGradient_1.Parent = Code
			--UIGradient_1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(216, 150, 179)), ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 81, 164))}
			UIGradient_1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(29, 28, 38)), ColorSequenceKeypoint.new(1, Color3.fromRGB(29, 28, 38))}
			UIGradient_1.Rotation = 45

			addToTheme('Function.Code.Background', UIGradient_1)

			local Line = Instance.new("Frame")
			local LineText_1 = Instance.new("TextLabel")

			Line.Name = "Line"
			Line.Parent = ScrollingFrame
			Line.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Line.BackgroundTransparency = 1
			Line.BorderColor3 = Color3.fromRGB(0,0,0)
			Line.BorderSizePixel = 0
			Line.Size = UDim2.new(1, 0,1, 0)

			LineText_1.Name = "LineText"
			LineText_1.Parent = Line
			LineText_1.Active = true
			LineText_1.AutomaticSize = Enum.AutomaticSize.XY
			LineText_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			LineText_1.BackgroundTransparency = 1
			LineText_1.BorderColor3 = Color3.fromRGB(0,0,0)
			LineText_1.BorderSizePixel = 0
			LineText_1.Size = UDim2.new(0, 0,0, 0)
			LineText_1.Font = Enum.Font.RobotoMono
			LineText_1.RichText = true
			LineText_1.Text = ''
			LineText_1.TextColor3 = Color3.fromRGB(255,255,255)
			LineText_1.TextSize = 12
			LineText_1.TextXAlignment = Enum.TextXAlignment.Left
			LineText_1.TextYAlignment = Enum.TextYAlignment.Top
			LineText_1.TextWrapped = true

			local highlighter = {}

			do
				local keywords = {
					lua = {
						"and", "break", "or", "else", "elseif", "if", "then", "until", "repeat", "while", "do", "for", "in", "end",
						"local", "return", "function", "export"
					},
					rbx = {
						"game", "workspace", "script", "math", "string", "table", "task", "wait", "select", "next", "Enum",
						"error", "warn", "tick", "assert", "shared", "loadstring", "tonumber", "tostring", "type",
						"typeof", "unpack", "print", "Instance", "CFrame", "Vector3", "Vector2", "Color3", "UDim", "UDim2", "Ray", "BrickColor",
						"OverlapParams", "RaycastParams", "Axes", "Random", "Region3", "Rect", "TweenInfo",
						"collectgarbage", "not", "utf8", "pcall", "xpcall", "_G", "setmetatable", "getmetatable", "os", "pairs", "ipairs"
					},
					operators = {
						"#", "+", "-", "*", "%", "/", "^", "=", "~", "=", "<", ">",
					}
				}

				local colors = {
					numbers = Color3.fromHex("#79c0ff"),
					boolean = Color3.fromHex("#79c0ff"),
					operator = Color3.fromHex("#ff7b72"),
					lua = Color3.fromHex("#ff7b72"),
					rbx = Color3.fromHex("#7fcfef"), -- def
					str = Color3.fromHex("#a5d6ff"),
					comment = Color3.fromHex("#8b949e"),
					null = Color3.fromHex("#79c0ff"),
					call = Color3.fromHex("#d2a8ff"),    
					self_call = Color3.fromHex("#d2a8ff"),
					local_property = Color3.fromHex("#ff7b72"),
				}

				local function createKeywordSet(keywords)
					local keywordSet = {}
					for _, keyword in ipairs(keywords) do
						keywordSet[keyword] = true
					end
					return keywordSet
				end

				local luaSet = createKeywordSet(keywords.lua)
				local rbxSet = createKeywordSet(keywords.rbx)
				local operatorsSet = createKeywordSet(keywords.operators)

				local function getHighlight(tokens, index)
					local token = tokens[index]

					if colors[token .. "_color"] then
						return colors[token .. "_color"]
					end

					if tonumber(token) then
						return colors.numbers
					elseif token == "nil" then
						return colors.null
					elseif token:sub(1, 2) == "--" then
						return colors.comment
					elseif operatorsSet[token] then
						return colors.operator
					elseif luaSet[token] then
						return colors.lua
					elseif rbxSet[token] then
						return colors.rbx
					elseif token:sub(1, 1) == "\"" or token:sub(1, 1) == "\'" then
						return colors.str
					elseif token == "true" or token == "false" then
						return colors.boolean
					else
					end

					if tokens[index + 1] == "(" then
						if tokens[index - 1] == ":" then
							return colors.self_call
						end

						return colors.call
					end

					if tokens[index - 1] == "." then
						if tokens[index - 2] == "Enum" then
							return colors.rbx
						end

						return colors.local_property
					end
				end

				function highlighter.run(source)
					local tokens = {}
					local multiStrings = {}
					local currentToken = ""

					local index = 1
					source = source:gsub("%[%[.-%]%]", function(str)
						local placeholder = "" .. index .. "__"
						multiStrings[placeholder] = str
						index = index + 1
						return placeholder
					end)

					local inString = false
					local inComment = false
					local commentPersist = false

					for i = 1, #source do
						local character = source:sub(i, i)

						if inComment then
							if character == "\n" and not commentPersist then
								table.insert(tokens, currentToken)
								table.insert(tokens, character)
								currentToken = ""
								inComment = false
							elseif source:sub(i - 1, i) == "]]" and commentPersist then
								currentToken = currentToken .. "]"
								table.insert(tokens, currentToken)
								currentToken = ""
								inComment = false
								commentPersist = false
							else
								currentToken = currentToken .. character
							end
						elseif inString then
							if character == inString and source:sub(i - 1, i - 1) ~= "\\" or character == "\n" then
								currentToken = currentToken .. character
								inString = false
							else
								currentToken = currentToken .. character
							end
						else
							local foundPlaceholder = source:sub(i):match("^__MULTISTR_%d+__")
							if foundPlaceholder then
								table.insert(tokens, foundPlaceholder)
								i = i + #foundPlaceholder - 1
							elseif source:sub(i, i + 1) == "--" then
								table.insert(tokens, currentToken)
								currentToken = "-"
								inComment = true
								commentPersist = source:sub(i + 2, i + 3) == "[["
							elseif character == "\"" or character == "\'" then
								table.insert(tokens, currentToken)
								currentToken = character
								inString = character
							elseif operatorsSet[character] then
								table.insert(tokens, currentToken)
								table.insert(tokens, character)
								currentToken = ""
							elseif character:match("[%w_]") then
								currentToken = currentToken .. character
							else
								table.insert(tokens, currentToken)
								table.insert(tokens, character)
								currentToken = ""
							end
						end
					end

					table.insert(tokens, currentToken)

					local highlighted = {}

					for i, token in ipairs(tokens) do
						if multiStrings[token] then
							local syntax = string.format(
								'<font color = "#%s">%s</font>',
								colors.str:ToHex(),
								multiStrings[token]:gsub("<", "&lt;"):gsub(">", "&gt;")
							)
							table.insert(highlighted, syntax)
						else
							local highlight = getHighlight(tokens, i)

							if highlight then
								local syntax = string.format(
									'<font color = "#%s">%s</font>',
									highlight:ToHex(),
									token:gsub("<", "&lt;"):gsub(">", "&gt;")
								)
								table.insert(highlighted, syntax)
							else
								table.insert(highlighted, token)
							end
						end
					end

					return table.concat(highlighted)
				end
			end

			local iscop = false

			TextButton_1.MouseButton1Click:Connect(function()
				if not iscop then
					setclipboard(CodeText)
					TextButton_1.Text = "Copied"
					ImageLabel_1.Image = GetAsset("14939475472")
					Frame_5.Size = UDim2.new(0, 65,0, 30)
					iscop = true
					delay(1, function()
						TextButton_1.Text = "Copy"
						ImageLabel_1.Image = GetAsset("13847222481")
						Frame_5.Size = UDim2.new(0, 58,0, 30)
						iscop = false
					end)
				end
			end)

			TextBox_2.Text = highlighter.run(TextBox_2.Text)

			TextBox_2:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				ScrollingFrame.CanvasSize = UDim2.new(0, TextBox_2.AbsoluteSize.X + 20, 0, 0)
			end)

			local function updateLineNumbers()
				tw({v = RealBackground, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(1, 0,0, TextBox_2.TextBounds.Y + 65)}}):Play()
				tw({v = Frame_3, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(0, TextLabel_1.TextBounds.X + 30,0, 30)}}):Play()

				local count = #TextBox_2.Text:split("\n")

				local str = ""
				for i = 1, count do
					str = str .. i .. "\n"
				end
				LineText_1.Text = str
			end

			updateLineNumbers()
			TextBox_2:GetPropertyChangedSignal("Text"):Connect(updateLineNumbers)

			local New = {}

			function New:SetTitle(t)
				TextLabel_1.Text = tostring(t)
			end

			function New:SetCode(t)
				TextBox_2.Text = highlighter.run(t)
				CodeText = t
			end

			return New
		end

		function Func:Dropdown(p)
			local Title = p.Title or 'null'
			local Desc = p.Desc or ''
			local Image = p.Image or ''
			local List = p.List or {}
			local Value = p.Value or List[1]
			local Multi = p.Multi or false
			local Callback = p.Callback or function() end

			local Dropdown, Config = background(ScrollingFrame_1, Title, Desc, Image, 'Dropdown')

			Config:SetTextTransparencyTitle(0)
			Config:SetSizeT(125)

			local DropdownSelect = addDropdownSelect(Dropdown, Dropdown, Multi, Callback, Value, List)

			local New = {}

			function New:SetTitle(t)
				Config:SetTitle(t)
			end

			function New:SetDesc(t)
				Config:SetDesc(t)
			end

			function New:SetVisible(t)
				Dropdown.Visible = t
			end

			function New:SetValue(t)
				DropdownSelect:SetValue(t)
			end

			function New:Add(t)
				DropdownSelect:Add(t)
			end

			function New:Clear(t)
				local n = t or nil
				DropdownSelect:Clear(n)
			end

			return New
		end

		function Func:Keybind(p)
			local Title = p.Title or 'null'
			local Desc = p.Desc or ''
			local Image = p.Image or ''
			local Value = p.Value or false
			local Key = p.Key or Enum.KeyCode.E
			local Callback = p.Callback or function() end
			local KeyChangedCallback = p.KeyChangedCallback or function() end

			local Keybind, Config = background(ScrollingFrame_1, Title, Desc, Image, 'Keybind')

			Config:SetSizeT(100)

			local F = Instance.new("TextButton")
			local UIListLayout_1 = Instance.new("UIListLayout")
			local UIPadding_1 = Instance.new("UIPadding")
			local ToggleValue_1 = Instance.new("Frame")
			local UICorner_1 = Instance.new("UICorner")
			local Frame_1 = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local UIPadding_2 = Instance.new("UIPadding")
			local KeybindValue_1 = Instance.new("Frame")
			local UICorner_3 = Instance.new("UICorner")
			local UIStroke_1 = Instance.new("UIStroke")
			local TextLabel_1 = Instance.new("TextLabel")
			local UIPadding_3 = Instance.new("UIPadding")

			F.Name = "F"
			F.Parent = Keybind
			F.AnchorPoint = Vector2.new(1, 0.5)
			F.BackgroundColor3 = Color3.fromRGB(255,255,255)
			F.BackgroundTransparency = 1
			F.BorderColor3 = Color3.fromRGB(0,0,0)
			F.BorderSizePixel = 0
			F.Position = UDim2.new(1, 0,0.5, 0)
			F.Size = UDim2.new(0, 100,0.800000012, 0)
			F.Text = ''

			UIListLayout_1.Parent = F
			UIListLayout_1.Padding = UDim.new(0,8)
			UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Right
			UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

			UIPadding_1.Parent = F
			UIPadding_1.PaddingRight = UDim.new(0,13)

			ToggleValue_1.Name = "ToggleValue"
			ToggleValue_1.Parent = F
			ToggleValue_1.BackgroundColor3 = Color3.fromRGB(44,34,103)
			ToggleValue_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ToggleValue_1.BorderSizePixel = 0
			ToggleValue_1.LayoutOrder = 1
			ToggleValue_1.Size = UDim2.new(0, 0, 0, 0)   -- :  layout
			ToggleValue_1.Visible = false

			UICorner_1.Parent = ToggleValue_1
			UICorner_1.CornerRadius = UDim.new(1,0)

			Frame_1.Parent = ToggleValue_1
			Frame_1.AnchorPoint = Vector2.new(1, 0.5)
			Frame_1.BackgroundColor3 = Color3.fromRGB(91,68,209)
			Frame_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Frame_1.BorderSizePixel = 0
			Frame_1.Position = UDim2.new(1, 0,0.5, 0)
			Frame_1.Size = UDim2.new(0, 13,0, 13)

			addToTheme('Main', Frame_1)

			UICorner_2.Parent = Frame_1
			UICorner_2.CornerRadius = UDim.new(1,0)

			UIPadding_2.Parent = ToggleValue_1
			UIPadding_2.PaddingLeft = UDim.new(0,2)
			UIPadding_2.PaddingRight = UDim.new(0,2)

			KeybindValue_1.Name = "KeybindValue"
			KeybindValue_1.Parent = F
			KeybindValue_1.BackgroundColor3 = Color3.fromRGB(24,24,31)
			KeybindValue_1.BorderColor3 = Color3.fromRGB(0,0,0)
			KeybindValue_1.BorderSizePixel = 0
			KeybindValue_1.Size = UDim2.new(0, 30,0, 20)

			addToTheme('Function.Keybind.Value Background', KeybindValue_1)

			UICorner_3.Parent = KeybindValue_1
			UICorner_3.CornerRadius = UDim.new(0,4)

			UIStroke_1.Parent = KeybindValue_1
			UIStroke_1.Color = Color3.fromRGB(255,255,255)
			UIStroke_1.Thickness = 1
			UIStroke_1.Transparency = 0.95

			addToTheme('Function.Keybind.Value Stroke', UIStroke_1)

			TextLabel_1.Parent = KeybindValue_1
			TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextLabel_1.BackgroundTransparency = 1
			TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
			TextLabel_1.BorderSizePixel = 0
			TextLabel_1.Size = UDim2.new(1, 0,1, 0)
			TextLabel_1.Font = Enum.Font.GothamBold
			TextLabel_1.RichText = true
			TextLabel_1.Text = tostring(Key):gsub("Enum.KeyCode.", "")
			TextLabel_1.TextColor3 = Color3.fromRGB(255,255,255)
			TextLabel_1.TextSize = 10
			TextLabel_1.TextTransparency = 0.30000001192092896
			TextLabel_1.TextWrapped = true

			addToTheme('Text & Icon', TextLabel_1)

			UIPadding_3.Parent = KeybindValue_1
			UIPadding_3.PaddingLeft = UDim.new(0,5)
			UIPadding_3.PaddingRight = UDim.new(0,5)

			local Click = click(Keybind)
			KeybindValue_1.ZIndex = 2
			F.ZIndex = 2

			Value = not Value

			local function change()
				Value = not Value
				if Value then
					Config:SetTextTransparencyTitle(0)
					tw({v = ToggleValue_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {BackgroundColor3 = themes[IsTheme].Function.Keybind.True['Toggle Background']}}):Play()
					tw({v = Frame_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out",
						g = {
							BackgroundColor3 = themes[IsTheme].Function.Keybind.True['Toggle Value'],
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, 0,0.5, 0)
						}}):Play()
				else
					Config:SetTextTransparencyTitle(0.7)
					tw({v = ToggleValue_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {BackgroundColor3 = themes[IsTheme].Function.Keybind.False['Toggle Background']}}):Play()
					tw({v = Frame_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out",
						g = {
							BackgroundColor3 = themes[IsTheme].Function.Keybind.False['Toggle Value'],
							AnchorPoint = Vector2.new(0, 0.5),
							Position = UDim2.new(0, 0,0.5, 0)
						}}):Play()
				end
			end

			Click.MouseButton1Click:Connect(change)

			delay(0.1, change)

			local changeing = false

			local function adjustBoxBindSize()
				local textSize = _Services.TextService:GetTextSize(TextLabel_1.Text, TextLabel_1.TextSize, TextLabel_1.Font, Vector2.new(1000, 1000))
				tw({v = KeybindValue_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Size = UDim2.new(0, textSize.X + 20, 0, 20)}}):Play()
			end

			adjustBoxBindSize()

			local function changeKey()
				changeing = true
				TextLabel_1.Text = "..."
				local inputConnection
				inputConnection = U.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Keyboard then
						Key = input.KeyCode
						TextLabel_1.Text = tostring(Key):gsub("Enum.KeyCode.", "")
						adjustBoxBindSize()
						-- key   trigger callback
						KeyChangedCallback(Key)
						inputConnection:Disconnect()
						task.wait(.1)
						changeing = false
					end
				end)
			end

			U.InputBegan:Connect(function(input, gameProcessed)
				if gameProcessed then return end
				if input.KeyCode == Key and not changeing then
					change()
					pcall(Callback, Value, Key)
				end
			end)

			-- Callback  init  toggle
			-- delay(0, function()
			-- 	pcall(Callback, Key, Value)
			-- end)

			Keybind:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
				if Value then
					ToggleValue_1.BackgroundColor3 = themes[IsTheme].Function.Keybind.True['Toggle Background']
					Frame_1.BackgroundColor3 = themes[IsTheme].Function.Keybind.True['Toggle Value']
				else
					ToggleValue_1.BackgroundColor3 = themes[IsTheme].Function.Keybind.False['Toggle Background']
					Frame_1.BackgroundColor3 = themes[IsTheme].Function.Keybind.False['Toggle Value']
				end
			end)

			F.MouseButton1Click:Connect(changeKey)

			local New = {}

			function New:SetTitle(t)
				Config:SetTitle(t)
			end

			function New:SetDesc(t)
				Config:SetDesc(t)
			end

			function New:SetVisible(t)
				Keybind.Visible = t
			end

			function New:SetValue(t)
				Value = not t
				change()
			end

			function New:SetKey(t)
				Key = t
				TextLabel_1.Text = tostring(Key):gsub("Enum.KeyCode.", "")
				adjustBoxBindSize()
				-- callback  SetKey
			end

			return New
		end

		-- ===== K2NTA Console Component =====
		function Func:Console(p)
			local Title = p.Title or 'Console'
			local MaxLines = p.MaxLines or 100

			-- === Container background ===
			local RealBG = Instance.new("Frame")
			local ConsoleBG = Instance.new("Frame")
			local UICornerCon = Instance.new("UICorner")
			local UIStrokeCon = Instance.new("UIStroke")

			RealBG.Name = "Real Background"
			RealBG.Parent = ScrollingFrame_1
			RealBG.BackgroundTransparency = 1
			RealBG.BorderSizePixel = 0
			RealBG.Size = UDim2.new(1, 0, 0, 220)
			RealBG.ClipsDescendants = false

			ConsoleBG.Name = "Background"
			ConsoleBG.Parent = RealBG
			ConsoleBG.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
			ConsoleBG.BorderSizePixel = 0
			ConsoleBG.Size = UDim2.new(1, 0, 1, 0)

			UICornerCon.Parent = ConsoleBG
			UICornerCon.CornerRadius = UDim.new(0, 8)

			UIStrokeCon.Parent = ConsoleBG
			UIStrokeCon.Color = Color3.fromRGB(60, 60, 80)
			UIStrokeCon.Thickness = 1

			-- === Topbar: title + clear button ===
			local TopBar = Instance.new("Frame")
			local TopLabel = Instance.new("TextLabel")
			local ClearBtn = Instance.new("TextButton")
			local UICornerClear = Instance.new("UICorner")

			TopBar.Parent = ConsoleBG
			TopBar.BackgroundTransparency = 1
			TopBar.BorderSizePixel = 0
			TopBar.Size = UDim2.new(1, 0, 0, 24)
			TopBar.Position = UDim2.new(0, 0, 0, 0)

			TopLabel.Parent = TopBar
			TopLabel.BackgroundTransparency = 1
			TopLabel.BorderSizePixel = 0
			TopLabel.Size = UDim2.new(1, -60, 1, 0)
			TopLabel.Position = UDim2.new(0, 8, 0, 0)
			TopLabel.Font = Enum.Font.GothamBold
			TopLabel.Text = "[CLIPBOARD] " .. Title
			TopLabel.TextColor3 = Color3.fromRGB(160, 160, 200)
			TopLabel.TextSize = 10
			TopLabel.TextXAlignment = Enum.TextXAlignment.Left

			ClearBtn.Parent = TopBar
			ClearBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 20)
			ClearBtn.BorderSizePixel = 0
			ClearBtn.AnchorPoint = Vector2.new(1, 0.5)
			ClearBtn.Position = UDim2.new(1, -6, 0.5, 0)
			ClearBtn.Size = UDim2.new(0, 48, 0, 16)
			ClearBtn.Font = Enum.Font.GothamBold
			ClearBtn.Text = "CLEAR"
			ClearBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
			ClearBtn.TextSize = 9

			UICornerClear.Parent = ClearBtn
			UICornerClear.CornerRadius = UDim.new(0, 4)

			-- Divider line
			local Divider = Instance.new("Frame")
			Divider.Parent = ConsoleBG
			Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
			Divider.BorderSizePixel = 0
			Divider.Position = UDim2.new(0, 0, 0, 24)
			Divider.Size = UDim2.new(1, 0, 0, 1)

			-- === Scrolling log area ===
			local LogFrame = Instance.new("ScrollingFrame")
			local LogLayout = Instance.new("UIListLayout")
			local LogPadding = Instance.new("UIPadding")

			LogFrame.Parent = ConsoleBG
			LogFrame.BackgroundTransparency = 1
			LogFrame.BorderSizePixel = 0
			LogFrame.Position = UDim2.new(0, 0, 0, 25)
			LogFrame.Size = UDim2.new(1, 0, 1, -25)
			LogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			LogFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
			LogFrame.ScrollBarThickness = 3
			LogFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 160)
			LogFrame.ScrollingDirection = Enum.ScrollingDirection.Y
			LogFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
			LogFrame.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
			LogFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
			LogFrame.ClipsDescendants = true

			LogLayout.Parent = LogFrame
			LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
			LogLayout.Padding = UDim.new(0, 4)

			LogPadding.Parent = LogFrame
			LogPadding.PaddingLeft = UDim.new(0, 8)
			LogPadding.PaddingRight = UDim.new(0, 8)
			LogPadding.PaddingTop = UDim.new(0, 8)
			LogPadding.PaddingBottom = UDim.new(0, 8)

			-- === Log colors by level ===
			local levelColors = {
				info    = Color3.fromRGB(140, 200, 255),
				success = Color3.fromRGB(100, 230, 130),
				warn    = Color3.fromRGB(255, 210, 80),
				error   = Color3.fromRGB(255, 90, 90),
				system  = Color3.fromRGB(180, 140, 255),
			}
			local levelIcons = {
				info    = "",
				success = "",
				warn    = "",
				error   = "",
				system  = "",
			}

			local logCount = 0
			local logLines = {}

			-- === Internal: add line ===
			local function addLine(text, level)
				level = level or "info"
				logCount = logCount + 1

				-- remove oldest if over max
				if #logLines >= MaxLines then
					local oldest = table.remove(logLines, 1)
					if oldest and oldest.Parent then oldest:Destroy() end
				end

				local timeStr = os.date and os.date("%H:%M:%S") or ""
				local icon = levelIcons[level] or ""
				local color = levelColors[level] or Color3.fromRGB(200, 200, 200)

				-- Card Container
				local RowFrame = Instance.new("Frame")
				local RowCorner = Instance.new("UICorner")
				local AccentBar = Instance.new("Frame")
				local AccentCorner = Instance.new("UICorner")
				local RowLabel = Instance.new("TextLabel")
				local RowPadding = Instance.new("UIPadding")

				RowFrame.Parent = LogFrame
				RowFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
				RowFrame.BackgroundTransparency = 1 -- animation
				RowFrame.BorderSizePixel = 0
				RowFrame.Size = UDim2.new(1, 0, 0, 0)
				RowFrame.AutomaticSize = Enum.AutomaticSize.Y
				RowFrame.LayoutOrder = logCount

				RowCorner.Parent = RowFrame
				RowCorner.CornerRadius = UDim.new(0, 6)

				AccentBar.Parent = RowFrame
				AccentBar.BackgroundColor3 = color
				AccentBar.BorderSizePixel = 0
				AccentBar.Size = UDim2.new(0, 3, 1, 0)
				AccentBar.Position = UDim2.new(0, 0, 0, 0)
				AccentBar.BackgroundTransparency = 1

				AccentCorner.Parent = AccentBar
				AccentCorner.CornerRadius = UDim.new(0, 3)

				RowLabel.Parent = RowFrame
				RowLabel.BackgroundTransparency = 1
				RowLabel.BorderSizePixel = 0
				RowLabel.Size = UDim2.new(1, -6, 1, 0)
				RowLabel.Position = UDim2.new(0, 8, 0, 0)
				RowLabel.AutomaticSize = Enum.AutomaticSize.Y
				RowLabel.Font = Enum.Font.GothamMedium
				RowLabel.RichText = true
				RowLabel.TextXAlignment = Enum.TextXAlignment.Left
				RowLabel.TextSize = 11
				RowLabel.TextWrapped = true
				RowLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
				RowLabel.TextTransparency = 1
				RowLabel.Text = string.format(
					'<font color="#%02x%02x%02x" size="12"><b>%s</b></font>  <font color="#787896" size="9">%s</font>  %s',
					math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255), icon,
					timeStr,
					text
				)

				RowPadding.Parent = RowFrame
				RowPadding.PaddingTop = UDim.new(0, 6)
				RowPadding.PaddingBottom = UDim.new(0, 6)

				table.insert(logLines, RowFrame)

				-- Fade in animation
				local TweenService = _Services.TweenService
				local ti = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
				TweenService:Create(RowFrame, ti, {BackgroundTransparency = 0.4}):Play()
				TweenService:Create(AccentBar, ti, {BackgroundTransparency = 0}):Play()
				TweenService:Create(RowLabel, ti, {TextTransparency = 0}):Play()

				-- auto-scroll to bottom
				task.defer(function()
					LogFrame.CanvasPosition = Vector2.new(0, math.huge)
				end)

				-- print to real console too
				print(string.format("[K2NTA][%s] %s %s", level:upper(), icon, text))
			end

			-- === Clear ===
			ClearBtn.MouseButton1Click:Connect(function()
				for _, v in ipairs(logLines) do
					if v and v.Parent then v:Destroy() end
				end
				logLines = {}
				logCount = 0
			end)

			-- hover effect on clear button
			ClearBtn.MouseEnter:Connect(function()
				ClearBtn.BackgroundColor3 = Color3.fromRGB(80, 25, 25)
			end)
			ClearBtn.MouseLeave:Connect(function()
				ClearBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 20)
			end)

			-- === Public API ===
			local New = {}

			function New:Log(text, level)
				addLine(text, level or "info")
			end

			function New:Info(text)    addLine(text, "info")    end
			function New:Success(text) addLine(text, "success") end
			function New:Warn(text)    addLine(text, "warn")    end
			function New:Error(text)   addLine(text, "error")   end
			function New:System(text)  addLine(text, "system")  end

			function New:Clear()
				for _, v in ipairs(logLines) do
					if v and v.Parent then v:Destroy() end
				end
				logLines = {}
				logCount = 0
			end

			function New:SetVisible(t)
				RealBG.Visible = t
			end

			return New
		end

		function Func:ColorPicker(p)
			local Title = p.Title
			local Desc = p.Desc or ''
			local Image = p.Image or ''
			local Value = p.Value or Color3.fromRGB(255, 255, 255)
			local Callback = p.Callback or function() end

			local ColorPicker, Config = background(ScrollingFrame_1, Title, Desc, Image, 'Color Picker')

			Config:SetTextTransparencyTitle(0)
			Config:SetSizeT(50)

			local ListFunctionColorPicker = Instance.new("Frame")
			local Picker_1 = Instance.new("Frame")
			local UICorner_1 = Instance.new("UICorner")
			local GlowDot_1 = Instance.new("ImageLabel")
			local Picker_2 = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local UIPadding_1 = Instance.new("UIPadding")

			ListFunctionColorPicker.Name = "ListFunctionColorPicker"
			ListFunctionColorPicker.Parent = ColorPicker
			ListFunctionColorPicker.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ListFunctionColorPicker.BackgroundTransparency = 1
			ListFunctionColorPicker.BorderColor3 = Color3.fromRGB(0,0,0)
			ListFunctionColorPicker.BorderSizePixel = 0
			ListFunctionColorPicker.Size = UDim2.new(1, 0,1, 0)

			Picker_1.Name = "Picker"
			Picker_1.Parent = ListFunctionColorPicker
			Picker_1.AnchorPoint = Vector2.new(1, 0.5)
			Picker_1.BackgroundColor3 = Value
			Picker_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Picker_1.BorderSizePixel = 0
			Picker_1.Position = UDim2.new(1, 0,0.5, 0)
			Picker_1.Size = UDim2.new(0, 20,0, 20)

			UICorner_1.Parent = Picker_1
			UICorner_1.CornerRadius = UDim.new(1,0)

			GlowDot_1.Name = "GlowDot"
			GlowDot_1.Parent = Picker_1
			GlowDot_1.AnchorPoint = Vector2.new(0.5, 0.5)
			GlowDot_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			GlowDot_1.BackgroundTransparency = 1
			GlowDot_1.BorderColor3 = Color3.fromRGB(0,0,0)
			GlowDot_1.BorderSizePixel = 0
			GlowDot_1.Position = UDim2.new(0.5, 0,0.5, 0)
			GlowDot_1.Size = UDim2.new(1.5, 0,1.5, 0)
			GlowDot_1.Image = GetAsset("105506802034513")
			GlowDot_1.ImageColor3 = Value
			GlowDot_1.ImageTransparency = 0.2

			Picker_2.Name = "Picker"
			Picker_2.Parent = GlowDot_1
			Picker_2.AnchorPoint = Vector2.new(0.5, 0.5)
			Picker_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Picker_2.BorderColor3 = Color3.fromRGB(0,0,0)
			Picker_2.BorderSizePixel = 0
			Picker_2.Position = UDim2.new(0.5, 0,0.5, 0)
			Picker_2.Size = UDim2.new(0, 12,0, 12)

			UICorner_2.Parent = Picker_2
			UICorner_2.CornerRadius = UDim.new(1,0)

			UIPadding_1.Parent = ListFunctionColorPicker
			UIPadding_1.PaddingRight = UDim.new(0,10)

			local ColorpickBar = Instance.new("Frame")
			local UICorner_1 = Instance.new("UICorner")
			local UIStroke_1 = Instance.new("UIStroke")
			local UIPadding_1 = Instance.new("UIPadding")
			local Color_1 = Instance.new("ImageLabel")
			local ColorCorner_1 = Instance.new("UICorner")
			local ColorSelection_1 = Instance.new("ImageLabel")
			local Hue_1 = Instance.new("ImageLabel")
			local HueCorner_1 = Instance.new("UICorner")
			local HueGradient_1 = Instance.new("UIGradient")
			local HueSelection_1 = Instance.new("ImageLabel")

			lak(ColorpickBar)

			ColorpickBar.Name = "ColorpickBar"
			ColorpickBar.Parent = ScreenGui
			ColorpickBar.BackgroundColor3 = Color3.fromRGB(24, 24, 31)
			ColorpickBar.BorderColor3 = Color3.fromRGB(0,0,0)
			ColorpickBar.BorderSizePixel = 0
			ColorpickBar.Size = UDim2.new(0, 120,0, 0)
			ColorpickBar.ClipsDescendants = true
			local targetX = Picker_1.AbsolutePosition.X - ColorpickBar.Parent.AbsolutePosition.X + Picker_1.Size.X.Offset - 100
			local targetY = Picker_1.AbsolutePosition.Y - ColorpickBar.Parent.AbsolutePosition.Y + Picker_1.Size.Y.Offset - 20
			ColorpickBar.Position = UDim2.new(0, targetX, 0, targetY)

			addToTheme('Function.Color Picker.Color Select.Background', ColorpickBar)

			UICorner_1.Parent = ColorpickBar
			UICorner_1.CornerRadius = UDim.new(0, 6)

			UIStroke_1.Parent = ColorpickBar
			UIStroke_1.Thickness = 1
			UIStroke_1.Transparency = 1
			UIStroke_1.Color = Color3.fromRGB(255, 255, 255)
			UIStroke_1.Transparency = 0.95

			addToTheme('Function.Color Picker.Color Select.UIStroke', UIStroke_1)

			UIPadding_1.Parent = ColorpickBar
			UIPadding_1.PaddingBottom = UDim.new(0,5)
			UIPadding_1.PaddingLeft = UDim.new(0,10)
			UIPadding_1.PaddingRight = UDim.new(0,10)
			UIPadding_1.PaddingTop = UDim.new(0,5)

			Color_1.Name = "Color"
			Color_1.Parent = ColorpickBar
			Color_1.AnchorPoint = Vector2.new(0, 0)
			Color_1.BackgroundColor3 = Color3.fromRGB(39,39,39)
			Color_1.Position = UDim2.new(0, 0,0, 25)
			Color_1.Size = UDim2.new(0, 80,0, 80)
			Color_1.ZIndex = 10
			Color_1.Image = GetAsset("4155801252")

			ColorCorner_1.Name = "ColorCorner"
			ColorCorner_1.Parent = Color_1
			ColorCorner_1.CornerRadius = UDim.new(0,3)

			ColorSelection_1.Name = "ColorSelection"
			ColorSelection_1.Parent = Color_1
			ColorSelection_1.AnchorPoint = Vector2.new(0.5, 0.5)
			ColorSelection_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ColorSelection_1.BackgroundTransparency = 1
			ColorSelection_1.Size = UDim2.new(0, 12,0, 12)
			ColorSelection_1.Image = GetAsset("http://www.roblox.com/asset/?id=4805639000")
			ColorSelection_1.ScaleType = Enum.ScaleType.Fit

			Hue_1.Name = "Hue"
			Hue_1.Parent = ColorpickBar
			Hue_1.AnchorPoint = Vector2.new(0, 0)
			Hue_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Hue_1.Position = UDim2.new(0.47, 0,0, 25)
			Hue_1.Size = UDim2.new(0, 10,0, 80)

			HueCorner_1.Name = "HueCorner"
			HueCorner_1.Parent = Hue_1
			HueCorner_1.CornerRadius = UDim.new(1,0)

			HueGradient_1.Name = "HueGradient"
			HueGradient_1.Parent = Hue_1
			HueGradient_1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.2, Color3.fromRGB(234, 255, 0)), ColorSequenceKeypoint.new(0.4, Color3.fromRGB(21, 255, 0)), ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 17, 255)), ColorSequenceKeypoint.new(0.9, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 4))}
			HueGradient_1.Rotation = 270

			HueSelection_1.Name = "HueSelection"
			HueSelection_1.Parent = Hue_1
			HueSelection_1.AnchorPoint = Vector2.new(0.5, 0.5)
			HueSelection_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			HueSelection_1.BackgroundTransparency = 1
			HueSelection_1.Position = UDim2.new(0.5, 0,1, 0)
			HueSelection_1.Size = UDim2.new(0, 12,0, 12)
			HueSelection_1.Image = GetAsset("http://www.roblox.com/asset/?id=4805639000")

			local TitleColorPicker = Instance.new("TextLabel")

			TitleColorPicker.Name = "TitleColorPicker"
			TitleColorPicker.Parent = ColorpickBar
			TitleColorPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TitleColorPicker.BackgroundTransparency = 1.000
			TitleColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TitleColorPicker.BorderSizePixel = 0
			TitleColorPicker.Size = UDim2.new(1, 0, 0, 27)
			TitleColorPicker.Font = Enum.Font.GothamBold
			TitleColorPicker.Text = Title
			TitleColorPicker.TextColor3 = Color3.fromRGB(0, 0, 0)
			TitleColorPicker.TextSize = 12.000
			TitleColorPicker.TextXAlignment = Enum.TextXAlignment.Left
			TitleColorPicker.TextColor3 = Color3.fromRGB(255, 255, 255)

			addToTheme('Text & Icon', TitleColorPicker)

			local BoxColor = Instance.new("Frame")
			local Hax_1 = Instance.new("Frame")
			local BarValueHax_1 = Instance.new("Frame")
			local UICorner_1 = Instance.new("UICorner")
			local UIStroke_11 = Instance.new("UIStroke")
			local TextLabel_1 = Instance.new("TextBox")
			local TextLabel_2 = Instance.new("TextLabel")
			local UIListLayoutBoxColor_1 = Instance.new("UIListLayout")
			local Red_1 = Instance.new("Frame")
			local BarValueRed_1 = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local UIStroke_2 = Instance.new("UIStroke")
			local TextLabel_3 = Instance.new("TextBox")
			local TextLabel_4 = Instance.new("TextLabel")
			local Green_1 = Instance.new("Frame")
			local BarValueGreen_1 = Instance.new("Frame")
			local UICorner_3 = Instance.new("UICorner")
			local UIStroke_3 = Instance.new("UIStroke")
			local TextLabel_5 = Instance.new("TextBox")
			local TextLabel_6 = Instance.new("TextLabel")
			local Blue_1 = Instance.new("Frame")
			local BarValueBlue_1 = Instance.new("Frame")
			local UICorner_4 = Instance.new("UICorner")
			local UIStroke_4 = Instance.new("UIStroke")
			local TextLabel_7 = Instance.new("TextBox")
			local TextLabel_8 = Instance.new("TextLabel")

			BoxColor.Name = "BoxColor"
			BoxColor.Parent = ColorpickBar
			BoxColor.AnchorPoint = Vector2.new(1, 0)
			BoxColor.BackgroundColor3 = Color3.fromRGB(255,255,255)
			BoxColor.BackgroundTransparency = 1
			BoxColor.BorderColor3 = Color3.fromRGB(0,0,0)
			BoxColor.BorderSizePixel = 0
			BoxColor.Position = UDim2.new(1, 0,0, 25)
			BoxColor.Size = UDim2.new(0, 80,0, 80)

			Hax_1.Name = "Hax"
			Hax_1.Parent = BoxColor
			Hax_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Hax_1.BackgroundTransparency = 1
			Hax_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Hax_1.BorderSizePixel = 0
			Hax_1.Size = UDim2.new(1, 0,0, 21)

			BarValueHax_1.Name = "BarValueHax"
			BarValueHax_1.Parent = Hax_1
			BarValueHax_1.AnchorPoint = Vector2.new(0, 0.5)
			BarValueHax_1.BackgroundColor3 = Color3.fromRGB(217,217,217)
			BarValueHax_1.BackgroundTransparency = 1
			BarValueHax_1.BorderColor3 = Color3.fromRGB(0,0,0)
			BarValueHax_1.BorderSizePixel = 0
			BarValueHax_1.Position = UDim2.new(0, 0,0.5, 0)
			BarValueHax_1.Size = UDim2.new(0.6, 0,0, 15)

			UICorner_1.Parent = BarValueHax_1
			UICorner_1.CornerRadius = UDim.new(1,0)

			UIStroke_11.Parent = BarValueHax_1
			UIStroke_11.Thickness = 1
			UIStroke_11.Color = Color3.fromRGB(255, 255, 255)
			UIStroke_11.Transparency = 0.95

			addToTheme('Function.Color Picker.Color Select.UIStroke', UIStroke_11)

			TextLabel_1.Name = "TextLabel"
			TextLabel_1.Parent = BarValueHax_1
			TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextLabel_1.BackgroundTransparency = 1
			TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
			TextLabel_1.BorderSizePixel = 0
			TextLabel_1.Size = UDim2.new(1, 0,1, 0)
			TextLabel_1.Font = Enum.Font.Gotham
			TextLabel_1.PlaceholderColor3 = Color3.fromRGB(178,178,178)
			TextLabel_1.PlaceholderText = "#FFFFFF"
			TextLabel_1.Text = "#FFFFFF"
			TextLabel_1.TextSize = 9
			TextLabel_1.TextTruncate = Enum.TextTruncate.AtEnd
			TextLabel_1.TextColor3 = Color3.fromRGB(255, 255, 255)

			addToTheme('Text & Icon', TextLabel_1)

			TextLabel_2.Parent = Hax_1
			TextLabel_2.AnchorPoint = Vector2.new(1, 0.5)
			TextLabel_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextLabel_2.BackgroundTransparency = 1
			TextLabel_2.BorderColor3 = Color3.fromRGB(0,0,0)
			TextLabel_2.BorderSizePixel = 0
			TextLabel_2.Position = UDim2.new(0.980000019, 0,0.5, 0)
			TextLabel_2.Size = UDim2.new(0, 20,0, 20)
			TextLabel_2.Font = Enum.Font.Gotham
			TextLabel_2.Text = "Hax"
			TextLabel_2.TextSize = 9
			TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)

			addToTheme('Text & Icon', TextLabel_2)

			UIListLayoutBoxColor_1.Name = "UIListLayoutBoxColor"
			UIListLayoutBoxColor_1.Parent = BoxColor
			UIListLayoutBoxColor_1.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayoutBoxColor_1.VerticalAlignment = Enum.VerticalAlignment.Center

			Red_1.Name = "Red"
			Red_1.Parent = BoxColor
			Red_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Red_1.BackgroundTransparency = 1
			Red_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Red_1.BorderSizePixel = 0
			Red_1.LayoutOrder = 1
			Red_1.Size = UDim2.new(1, 0,0, 21)

			BarValueRed_1.Name = "BarValueRed"
			BarValueRed_1.Parent = Red_1
			BarValueRed_1.AnchorPoint = Vector2.new(0, 0.5)
			BarValueRed_1.BackgroundColor3 = Color3.fromRGB(217,217,217)
			BarValueRed_1.BackgroundTransparency = 1
			BarValueRed_1.BorderColor3 = Color3.fromRGB(0,0,0)
			BarValueRed_1.BorderSizePixel = 0
			BarValueRed_1.Position = UDim2.new(0, 0,0.5, 0)
			BarValueRed_1.Size = UDim2.new(0.600000024, 0,0, 15)

			UICorner_2.Parent = BarValueRed_1
			UICorner_2.CornerRadius = UDim.new(1,0)

			UIStroke_2.Parent = BarValueRed_1
			UIStroke_2.Thickness = 1
			UIStroke_2.Color = Color3.fromRGB(255, 255, 255)
			UIStroke_2.Transparency = 0.95

			addToTheme('Function.Color Picker.Color Select.UIStroke', UIStroke_2)

			TextLabel_3.Name = "TextLabel"
			TextLabel_3.Parent = BarValueRed_1
			TextLabel_3.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextLabel_3.BackgroundTransparency = 1
			TextLabel_3.BorderColor3 = Color3.fromRGB(0,0,0)
			TextLabel_3.BorderSizePixel = 0
			TextLabel_3.Size = UDim2.new(1, 0,1, 0)
			TextLabel_3.Font = Enum.Font.Gotham
			TextLabel_3.PlaceholderColor3 = Color3.fromRGB(178,178,178)
			TextLabel_3.PlaceholderText = "255"
			TextLabel_3.Text = "255"
			TextLabel_3.TextSize = 9
			TextLabel_3.TextTruncate = Enum.TextTruncate.AtEnd
			TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)

			addToTheme('Text & Icon', TextLabel_3)

			TextLabel_4.Parent = Red_1
			TextLabel_4.AnchorPoint = Vector2.new(1, 0.5)
			TextLabel_4.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextLabel_4.BackgroundTransparency = 1
			TextLabel_4.BorderColor3 = Color3.fromRGB(0,0,0)
			TextLabel_4.BorderSizePixel = 0
			TextLabel_4.Position = UDim2.new(0.980000019, 0,0.5, 0)
			TextLabel_4.Size = UDim2.new(0, 20,0, 20)
			TextLabel_4.Font = Enum.Font.Gotham
			TextLabel_4.Text = "Red"
			TextLabel_4.TextSize = 9
			TextLabel_4.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel_4.TextColor3 = Color3.fromRGB(255, 255, 255)

			addToTheme('Text & Icon', TextLabel_4)

			Green_1.Name = "Green"
			Green_1.Parent = BoxColor
			Green_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Green_1.BackgroundTransparency = 1
			Green_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Green_1.BorderSizePixel = 0
			Green_1.LayoutOrder = 2
			Green_1.Size = UDim2.new(1, 0,0, 21)

			BarValueGreen_1.Name = "BarValueGreen"
			BarValueGreen_1.Parent = Green_1
			BarValueGreen_1.AnchorPoint = Vector2.new(0, 0.5)
			BarValueGreen_1.BackgroundColor3 = Color3.fromRGB(217,217,217)
			BarValueGreen_1.BackgroundTransparency = 1
			BarValueGreen_1.BorderColor3 = Color3.fromRGB(0,0,0)
			BarValueGreen_1.BorderSizePixel = 0
			BarValueGreen_1.Position = UDim2.new(0, 0,0.5, 0)
			BarValueGreen_1.Size = UDim2.new(0.600000024, 0,0, 15)

			UICorner_3.Parent = BarValueGreen_1
			UICorner_3.CornerRadius = UDim.new(1,0)

			UIStroke_3.Parent = BarValueGreen_1
			UIStroke_3.Thickness = 1
			UIStroke_3.Color = Color3.fromRGB(255, 255, 255)
			UIStroke_3.Transparency = 0.95

			addToTheme('Function.Color Picker.Color Select.UIStroke', UIStroke_3)

			TextLabel_5.Name = "TextLabel"
			TextLabel_5.Parent = BarValueGreen_1
			TextLabel_5.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextLabel_5.BackgroundTransparency = 1
			TextLabel_5.BorderColor3 = Color3.fromRGB(0,0,0)
			TextLabel_5.BorderSizePixel = 0
			TextLabel_5.Size = UDim2.new(1, 0,1, 0)
			TextLabel_5.Font = Enum.Font.Gotham
			TextLabel_5.PlaceholderColor3 = Color3.fromRGB(178,178,178)
			TextLabel_5.PlaceholderText = "255"
			TextLabel_5.Text = "255"
			TextLabel_5.TextSize = 9
			TextLabel_5.TextTruncate = Enum.TextTruncate.AtEnd
			TextLabel_5.TextColor3 = Color3.fromRGB(255, 255, 255)

			addToTheme('Text & Icon', TextLabel_5)

			TextLabel_6.Parent = Green_1
			TextLabel_6.AnchorPoint = Vector2.new(1, 0.5)
			TextLabel_6.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextLabel_6.BackgroundTransparency = 1
			TextLabel_6.BorderColor3 = Color3.fromRGB(0,0,0)
			TextLabel_6.BorderSizePixel = 0
			TextLabel_6.Position = UDim2.new(0.980000019, 0,0.5, 0)
			TextLabel_6.Size = UDim2.new(0, 20,0, 20)
			TextLabel_6.Font = Enum.Font.Gotham
			TextLabel_6.Text = "Green"
			TextLabel_6.TextSize = 9
			TextLabel_6.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel_6.TextColor3 = Color3.fromRGB(255, 255, 255)

			addToTheme('Text & Icon', TextLabel_6)

			Blue_1.Name = "Blue"
			Blue_1.Parent = BoxColor
			Blue_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Blue_1.BackgroundTransparency = 1
			Blue_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Blue_1.BorderSizePixel = 0
			Blue_1.LayoutOrder = 3
			Blue_1.Size = UDim2.new(1, 0,0, 21)

			BarValueBlue_1.Name = "BarValueBlue"
			BarValueBlue_1.Parent = Blue_1
			BarValueBlue_1.AnchorPoint = Vector2.new(0, 0.5)
			BarValueBlue_1.BackgroundColor3 = Color3.fromRGB(217,217,217)
			BarValueBlue_1.BackgroundTransparency = 1
			BarValueBlue_1.BorderColor3 = Color3.fromRGB(0,0,0)
			BarValueBlue_1.BorderSizePixel = 0
			BarValueBlue_1.Position = UDim2.new(0, 0,0.5, 0)
			BarValueBlue_1.Size = UDim2.new(0.600000024, 0,0, 15)

			UICorner_4.Parent = BarValueBlue_1
			UICorner_4.CornerRadius = UDim.new(1,0)

			UIStroke_4.Parent = BarValueBlue_1
			UIStroke_4.Thickness = 1
			UIStroke_4.Color = Color3.fromRGB(255, 255, 255)
			UIStroke_4.Transparency = 0.95

			addToTheme('Function.Color Picker.Color Select.UIStroke', UIStroke_4)

			TextLabel_7.Name = "TextLabel"
			TextLabel_7.Parent = BarValueBlue_1
			TextLabel_7.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextLabel_7.BackgroundTransparency = 1
			TextLabel_7.BorderColor3 = Color3.fromRGB(0,0,0)
			TextLabel_7.BorderSizePixel = 0
			TextLabel_7.Size = UDim2.new(1, 0,1, 0)
			TextLabel_7.Font = Enum.Font.Gotham
			TextLabel_7.PlaceholderColor3 = Color3.fromRGB(178,178,178)
			TextLabel_7.PlaceholderText = "255"
			TextLabel_7.Text = "255"
			TextLabel_7.TextSize = 9
			TextLabel_7.TextTruncate = Enum.TextTruncate.AtEnd
			TextLabel_7.TextColor3 = Color3.fromRGB(255, 255, 255)

			addToTheme('Text & Icon', TextLabel_7)

			TextLabel_8.Parent = Blue_1
			TextLabel_8.AnchorPoint = Vector2.new(1, 0.5)
			TextLabel_8.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextLabel_8.BackgroundTransparency = 1
			TextLabel_8.BorderColor3 = Color3.fromRGB(0,0,0)
			TextLabel_8.BorderSizePixel = 0
			TextLabel_8.Position = UDim2.new(0.980000019, 0,0.5, 0)
			TextLabel_8.Size = UDim2.new(0, 20,0, 20)
			TextLabel_8.Font = Enum.Font.Gotham
			TextLabel_8.Text = "Blue"
			TextLabel_8.TextSize = 9
			TextLabel_8.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel_8.TextColor3 = Color3.fromRGB(255, 255, 255)

			addToTheme('Text & Icon', TextLabel_8)

			local Shower = Instance.new("Frame")
			local UICornerShow = Instance.new("UICorner")
			local GlowDotShow = Instance.new("ImageLabel")

			Shower.Name = "Shower"
			Shower.Parent = ColorpickBar
			Shower.AnchorPoint = Vector2.new(1, 0)
			Shower.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			Shower.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Shower.BorderSizePixel = 0
			Shower.Position = UDim2.new(1, 0, 0.0500000007, 0)
			Shower.Size = UDim2.new(0, 40, 0, 15)

			UICornerShow.CornerRadius = UDim.new(1, 0)
			UICornerShow.Name = "UICornerShow"
			UICornerShow.Parent = Shower

			GlowDotShow.Name = "GlowDotShow"
			GlowDotShow.Parent = Shower
			GlowDotShow.AnchorPoint = Vector2.new(0.5, 0.5)
			GlowDotShow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			GlowDotShow.BackgroundTransparency = 1.000
			GlowDotShow.BorderColor3 = Color3.fromRGB(0, 0, 0)
			GlowDotShow.BorderSizePixel = 0
			GlowDotShow.Position = UDim2.new(0.5, 0, 0.5, 0)
			GlowDotShow.Size = UDim2.new(1.25, 0, 1.5, 0)
			GlowDotShow.Image = GetAsset("105506802034513")
			GlowDotShow.ImageColor3 = Color3.fromRGB(255, 0, 0)
			GlowDotShow.ImageTransparency = 0.200

			local Click = click(ColorPicker)
			local ClickColor = click(Color_1)
			local ClickHue = click(Hue_1)
			local isopen = false

			local ColorH, ColorS, ColorV = 1, 1, 1
			local lastColorH = -1
			local ColorInput = nil
			local HueInput = nil
			local Mouse = _Services.Players.LocalPlayer:GetMouse()
			local lastColor = nil
			local ColorInput = nil
			local HueInput = nil
			local isTouchDevice = U.TouchEnabled

			local function open()
				local targetX = Picker_1.AbsolutePosition.X - ColorpickBar.Parent.AbsolutePosition.X + Picker_1.Size.X.Offset - 145
				local targetY = Picker_1.AbsolutePosition.Y - ColorpickBar.Parent.AbsolutePosition.Y + Picker_1.Size.Y.Offset - 50
				tw({v = ColorpickBar, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(0, 200,0, 125), Position = UDim2.new(0, targetX, 0, targetY)}}):Play()
				tw({v = UIStroke_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Transparency = 0.95}}):Play()
			end
			local function close()
				isopen = false
				tw({v = ColorpickBar, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(0, 200,0, 0)}}):Play()
				tw({v = UIStroke_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {Transparency = 1}}):Play()
			end

			U.InputBegan:Connect(function(A)
				if A.UserInputType == Enum.UserInputType.MouseButton1 or A.UserInputType == Enum.UserInputType.Touch then
					local B, C = ColorpickBar.AbsolutePosition, ColorpickBar.AbsoluteSize
					if _Services.Players.LocalPlayer:GetMouse().X < B.X or _Services.Players.LocalPlayer:GetMouse().X > B.X + C.X or _Services.Players.LocalPlayer:GetMouse().Y < (B.Y - 20 - 1) or _Services.Players.LocalPlayer:GetMouse().Y > B.Y + C.Y then
						close()
					end
				end
			end)

			Click.MouseButton1Click:Connect(function()
				isopen = not isopen
				if isopen then
					open()
				else
					close()
				end
			end)

			local function UpdateColorPicker(nope)
				Picker_1.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
				GlowDot_1.ImageColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
				Color_1.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)

				Shower.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
				GlowDotShow.ImageColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)

				local r, g, b = Picker_1.BackgroundColor3.R * 255, Picker_1.BackgroundColor3.G * 255, Picker_1.BackgroundColor3.B * 255

				TextLabel_3.Text = tostring(math.floor(r))
				TextLabel_5.Text = tostring(math.floor(g))
				TextLabel_7.Text = tostring(math.floor(b))

				local hex = string.format("#%02X%02X%02X", math.floor(r), math.floor(g), math.floor(b))
				TextLabel_1.Text = hex

				ColorH, ColorS, ColorV = Color3.toHSV(Picker_1.BackgroundColor3)

				if ColorS ~= 0 and ColorV ~= 0 then
					tw({v = ColorSelection_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Position = UDim2.new(ColorS, 0, 1 - ColorV, 0)}}):Play()
				end
				if lastColorH ~= ColorH and ColorS ~= 0 and ColorV ~= 0 and ColorS ~= 255 and ColorV ~= 255 then
					lastColorH = ColorH
					tw({v = HueSelection_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Position = UDim2.new(0.5, 0, 1 - ColorH, 0)}}):Play()
				end

				if lastColor ~= Picker_1.BackgroundColor3 then
					lastColor = Picker_1.BackgroundColor3
					pcall(Callback, math.floor(r), math.floor(g), math.floor(b))
				end
			end

			local function HexToRGB(hex)
				if hex:sub(1, 1) == "#" then
					hex = hex:sub(2)
				end

				if #hex == 6 then
					local r = tonumber(hex:sub(1, 2), 16) / 255
					local g = tonumber(hex:sub(3, 4), 16) / 255
					local b = tonumber(hex:sub(5, 6), 16) / 255
					return r, g, b
				else
					return 0, 0, 0
				end
			end

			local function UpdateColorFromText()
				local hex = TextLabel_1.Text:match("^#[%x]+$")
				if hex then
					local r, g, b = HexToRGB(hex)
					r = math.clamp(r, 0, 1)
					g = math.clamp(g, 0, 1)
					b = math.clamp(b, 0, 1)

					local h, s, v = Color3.toHSV(Color3.new(r, g, b))
					ColorH, ColorS, ColorV = h, s, v
					UpdateColorPicker(true)
				else
					local r = tonumber(TextLabel_3.Text) or 0
					local g = tonumber(TextLabel_5.Text) or 0
					local b = tonumber(TextLabel_7.Text) or 0

					r = math.clamp(r, 0, 255) / 255
					g = math.clamp(g, 0, 255) / 255
					b = math.clamp(b, 0, 255) / 255

					local h, s, v = Color3.toHSV(Color3.new(r, g, b))
					ColorH, ColorS, ColorV = h, s, v
					UpdateColorPicker(true)
				end
			end

			TextLabel_3.FocusLost:Connect(UpdateColorFromText)
			TextLabel_5.FocusLost:Connect(UpdateColorFromText)
			TextLabel_7.FocusLost:Connect(UpdateColorFromText)
			TextLabel_1.FocusLost:Connect(UpdateColorFromText)


			ColorH = 1 - (math.clamp(HueSelection_1.AbsolutePosition.Y - Hue_1.AbsolutePosition.Y, 0, Hue_1.AbsoluteSize.Y) / Hue_1.AbsoluteSize.Y)
			ColorS = (math.clamp(ColorSelection_1.AbsolutePosition.X - Color_1.AbsolutePosition.X, 0, Color_1.AbsoluteSize.X) / Color_1.AbsoluteSize.X)
			ColorV = 1 - (math.clamp(ColorSelection_1.AbsolutePosition.Y - Color_1.AbsolutePosition.Y, 0, Color_1.AbsoluteSize.Y) / Color_1.AbsoluteSize.Y)

			Picker_1.BackgroundColor3 = Value
			Color_1.BackgroundColor3 = Value

			ClickColor.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if ColorInput then
						ColorInput:Disconnect()
					end

					ColorInput = _Services.RunService.RenderStepped:Connect(function()
						local ColorX = (math.clamp(Mouse.X - Color_1.AbsolutePosition.X, 0, Color_1.AbsoluteSize.X) /Color_1.AbsoluteSize.X)
						local ColorY = (math.clamp(Mouse.Y - Color_1.AbsolutePosition.Y, 0, Color_1.AbsoluteSize.Y) /Color_1.AbsoluteSize.Y)

						tw({v = ColorSelection_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Position = UDim2.new(ColorX, 0, ColorY, 0)}}):Play()
						ColorS = ColorX
						ColorV = 1 - ColorY

						UpdateColorPicker(true)
					end)
				end
			end)

			ClickColor.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if ColorInput then
						ColorInput:Disconnect()
					end
				end
			end)

			ClickHue.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if HueInput then
						HueInput:Disconnect()
					end

					HueInput = _Services.RunService.RenderStepped:Connect(function()
						local HueY = (math.clamp(Mouse.Y - Hue_1.AbsolutePosition.Y, 0, Hue_1.AbsoluteSize.Y) /Hue_1.AbsoluteSize.Y)
						tw({v = HueSelection_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Position = UDim2.new(0.5, 0, HueY, 0)}}):Play()
						ColorH = 1 - HueY

						UpdateColorPicker(true)
					end)
				end
			end)

			ClickHue.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if HueInput then
						HueInput:Disconnect()
					end
				end
			end)

			if isTouchDevice then
				Color_1.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Touch then
						if ColorInput then
							ColorInput:Disconnect()
						end

						ColorInput = _Services.RunService.RenderStepped:Connect(function()
							local ColorX = (math.clamp(Mouse.X - Color_1.AbsolutePosition.X, 0, Color_1.AbsoluteSize.X) / Color_1.AbsoluteSize.X)
							local ColorY = (math.clamp(Mouse.Y - Color_1.AbsolutePosition.Y, 0, Color_1.AbsoluteSize.Y) / Color_1.AbsoluteSize.Y)

							ColorSelection_1.Position = UDim2.new(ColorX, 0, ColorY, 0)
							ColorS = ColorX
							ColorV = 1 - ColorY

							UpdateColorPicker(true)
						end)
					end
				end)

				Color_1.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Touch then
						if ColorInput then
							ColorInput:Disconnect()
						end
					end
				end)

				Hue_1.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Touch then
						if HueInput then
							HueInput:Disconnect()
						end

						HueInput = _Services.RunService.RenderStepped:Connect(function()
							local HueY = (math.clamp(Mouse.Y - Hue_1.AbsolutePosition.Y, 0, Hue_1.AbsoluteSize.Y) / Hue_1.AbsoluteSize.Y)

							HueSelection_1.Position = UDim2.new(0.48, 0, HueY, 0)
							ColorH = 1 - HueY

							UpdateColorPicker(true)
						end)
					end
				end)

				Hue_1.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.Touch then
						if HueInput then
							HueInput:Disconnect()
						end
					end
				end)
			end

			delay(0,function()
				ColorH, ColorS, ColorV = Color3.toHSV(Picker_1.BackgroundColor3)
				UpdateColorPicker(true)
				local r, g, b = Picker_1.BackgroundColor3.R * 255, Picker_1.BackgroundColor3.G * 255, Picker_1.BackgroundColor3.B * 255
				pcall(Callback, math.floor(r), math.floor(g), math.floor(b))
			end)

			local New = {}

			function New:SetTitle(t)
				Config:SetTitle(t)
			end

			function New:SetDesc(t)
				Config:SetDesc(t)
			end

			function New:SetVisible(t)
				ColorPicker.Visible = t
			end

			function New:SetValue(colorTable)
				local r = colorTable.R or Picker_1.BackgroundColor3.R * 255
				local g = colorTable.G or Picker_1.BackgroundColor3.G * 255
				local b = colorTable.B or Picker_1.BackgroundColor3.B * 255

				if r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255 then
					local newColor = Color3.fromRGB(r, g, b)

					Picker_1.BackgroundColor3 = newColor
					Color_1.BackgroundColor3 = newColor

					local h, s, v = Color3.toHSV(newColor)
					ColorH, ColorS, ColorV = h, s, v

					ColorSelection_1.Position = UDim2.new(s, 0, 1 - v, 0)
					HueSelection_1.Position = UDim2.new(0.48, 0, 1 - h, 0)
					pcall(Callback, r, g, b)
				end
			end

			return New
		end

		function Func:Textbox(p)
			local Title = p.Title
			local Desc = p.Desc or ''
			local Image = p.Image or ''
			local Value = p.Value or ''
			local Placeholder = p.Placeholder or 'Paste Your Text'
			local ClearText = p.ClearText or p.ClearTextOnFocus or false
			local Callback = p.Callback or function() end

			local Textbox, Config = background(ScrollingFrame_1, Title, Desc, Image, 'Textbox')

			Config:SetTextTransparencyTitle(0)
			Config:SetSizeT(145)

			local F = Instance.new("Frame")
			local UIListLayout_1 = Instance.new("UIListLayout")
			local UIPadding_1 = Instance.new("UIPadding")
			local Frame_1 = Instance.new("Frame")
			local UICorner_1 = Instance.new("UICorner")
			local UIStroke_1 = Instance.new("UIStroke")
			local UIPadding_2 = Instance.new("UIPadding")
			local ImageLabel_1 = Instance.new("ImageLabel")
			local TextLabel_1 = Instance.new("TextBox")
			local Frame_2 = Instance.new("Frame")

			F.Name = "F"
			F.Parent = Textbox
			F.AnchorPoint = Vector2.new(1, 0.5)
			F.BackgroundColor3 = Color3.fromRGB(255,255,255)
			F.BackgroundTransparency = 1
			F.BorderColor3 = Color3.fromRGB(0,0,0)
			F.BorderSizePixel = 0
			F.Position = UDim2.new(1, 0,0.5, 0)
			F.Size = UDim2.new(0, 150,0.800000012, 0)

			UIListLayout_1.Parent = F
			UIListLayout_1.Padding = UDim.new(0,15)
			UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Right
			UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

			UIPadding_1.Parent = F
			UIPadding_1.PaddingRight = UDim.new(0,13)

			Frame_1.Parent = F
			Frame_1.BackgroundColor3 = Color3.fromRGB(24,24,31)
			Frame_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Frame_1.BorderSizePixel = 0
			Frame_1.Size = UDim2.new(0, 130,0, 25)

			addToTheme('Function.Textbox.Value Background', Frame_1)

			UICorner_1.Parent = Frame_1
			UICorner_1.CornerRadius = UDim.new(0,4)

			UIStroke_1.Parent = Frame_1
			UIStroke_1.Color = Color3.fromRGB(255,255,255)
			UIStroke_1.Thickness = 1
			UIStroke_1.Transparency = 0.95

			addToTheme('Function.Textbox.Value Stroke', UIStroke_1)

			UIPadding_2.Parent = Frame_1
			UIPadding_2.PaddingLeft = UDim.new(0,5)
			UIPadding_2.PaddingRight = UDim.new(0,5)

			ImageLabel_1.Parent = Frame_1
			ImageLabel_1.AnchorPoint = Vector2.new(1, 0.5)
			ImageLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ImageLabel_1.BackgroundTransparency = 1
			ImageLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ImageLabel_1.BorderSizePixel = 0
			ImageLabel_1.Position = UDim2.new(1, 0,0.5, 0)
			ImageLabel_1.Size = UDim2.new(0, 15,0, 15)
			ImageLabel_1.Image = GetAsset("13868675087")
			ImageLabel_1.ImageTransparency = 0.30000001192092896

			addToTheme('Text & Value', ImageLabel_1)

			TextLabel_1.Name = "TextLabel"
			TextLabel_1.Parent = Frame_1
			TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			TextLabel_1.BackgroundTransparency = 1
			TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
			TextLabel_1.BorderSizePixel = 0
			TextLabel_1.Size = UDim2.new(0.800000012, 0,1, 0)
			TextLabel_1.Font = Enum.Font.GothamBold
			TextLabel_1.PlaceholderColor3 = Color3.fromRGB(178,178,178)
			TextLabel_1.PlaceholderText = Placeholder
			TextLabel_1.RichText = true
			TextLabel_1.Text = Value
			TextLabel_1.TextColor3 = Color3.fromRGB(255,255,255)
			TextLabel_1.TextSize = 10
			TextLabel_1.TextTransparency = 0.30000001192092896
			TextLabel_1.TextWrapped = true
			TextLabel_1.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel_1.ClearTextOnFocus = not ClearText

			addToTheme('Text & Value', TextLabel_1)

			Frame_2.Parent = Frame_1
			Frame_2.AnchorPoint = Vector2.new(0.5, 1)
			Frame_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Frame_2.BackgroundTransparency = 0.949999988079071
			Frame_2.BorderColor3 = Color3.fromRGB(0,0,0)
			Frame_2.BorderSizePixel = 0
			Frame_2.Position = UDim2.new(0.5, 0,1, 0)
			Frame_2.Size = UDim2.new(1.05, 0,0, 2)

			local function o()
				if #TextLabel_1.Text > 0 then
					pcall(Callback, TextLabel_1.Text)
				end
			end

			TextLabel_1.FocusLost:Connect(o)

			delay(0, o)

			local New = {}

			function New:SetTitle(t)
				Config:SetTitle(t)
			end

			function New:SetDesc(t)
				Config:SetDesc(t)
			end

			function New:SetVisible(t)
				Textbox.Visible = t
			end

			function New:SetValue(t)
				TextLabel_1.Text = t
			end

			function New:SetClearTextOnFocus(t)
				TextLabel_1.ClearTextOnFocus = not t
			end

			function New:SetPlaceholderText(t)
				TextLabel_1.PlaceholderText = t
			end

			return New
		end

		function Func:Image()
			local ImageLogo = Instance.new("ImageLabel")
			local SecondImage = Instance.new("ImageLabel")
			local UICorner_1 = Instance.new("UICorner")
			local UICorner_2 = Instance.new("UICorner")
			
			ImageLogo.Name = "Im"
			ImageLogo.Parent = ScrollingFrame_1
			ImageLogo.AnchorPoint = Vector2.new(0.5,0.5)
			ImageLogo.Position = UDim2.new(0.5,0,0.5,0)
			ImageLogo.BackgroundTransparency = 1
			ImageLogo.Size = UDim2.new(1, 0, 0, 180)
			ImageLogo.Image = GetAsset("111362591084511")
			ImageLogo.ScaleType = Enum.ScaleType.Crop
			
			UICorner_1.Parent = ImageLogo
			UICorner_1.CornerRadius = UDim.new(0, 8) -- 8

			-- Overlay for crossfade
			SecondImage.Name = "ImOverlay"
			SecondImage.Parent = ImageLogo
			SecondImage.BackgroundTransparency = 1
			SecondImage.Size = UDim2.new(1, 0, 1, 0)
			SecondImage.Image = ''
			SecondImage.ScaleType = Enum.ScaleType.Crop
			SecondImage.ImageTransparency = 1
			
			UICorner_2.Parent = SecondImage
			UICorner_2.CornerRadius = UDim.new(0, 8)

			local New = {}

			function New:SetImage(img, doFade)
				if doFade then
					SecondImage.Image = img
					SecondImage.ImageTransparency = 1
					local t = tw({
						v = SecondImage, 
						t = 0.5, 
						s = Enum.EasingStyle.Quad, 
						d = "InOut", 
						g = {ImageTransparency = 0}
					})
					t:Play()
					task.wait(0.5)
					ImageLogo.Image = img
					SecondImage.ImageTransparency = 1
				else
					ImageLogo.Image = img
				end
			end

			function New:SetVisible(t)
				ImageLogo.Visible = t
			end

			return New
		end

		return Func
	end

	local Notification = Instance.new("Frame")
	local UIPaddingUIListLayoutNotification_1 = Instance.new("UIPadding")
	local UIListLayoutNotification_1 = Instance.new("UIListLayout")

	Notification.Name = "Notification"
	Notification.Parent = ScreenGui
	Notification.AnchorPoint = Vector2.new(1, 1)
	Notification.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Notification.BackgroundTransparency = 1
Notification.BorderColor3 = Color3.fromRGB(0,0,0)
	Notification.BorderSizePixel = 0
	Notification.Position = UDim2.new(1, 0,1, 0)
	Notification.Size = UDim2.new(0, 100,0, 100)

	UIPaddingUIListLayoutNotification_1.Parent = Notification
	UIPaddingUIListLayoutNotification_1.PaddingBottom = UDim.new(0,20)
	UIPaddingUIListLayoutNotification_1.PaddingRight = UDim.new(0,5)

	UIListLayoutNotification_1.Parent = Notification
	UIListLayoutNotification_1.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayoutNotification_1.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayoutNotification_1.VerticalAlignment = Enum.VerticalAlignment.Bottom

	function Tabs:Notify(p)
		local Title = p.Title or 'Notification'
		local Desc = p.Desc or ''
		local Time = p.Time or 5

		local Shadow = Instance.new("ImageLabel")
		local UIPadding_1 = Instance.new("UIPadding")
		local Background_1 = Instance.new("CanvasGroup")
		local UICorner_1 = Instance.new("UICorner")
		local Frame_1 = Instance.new("Frame")
		
		local ContentContainer = Instance.new("Frame")
		local UIListLayout_Content = Instance.new("UIListLayout")
		local IconImg = Instance.new("ImageLabel")
		local Text_1 = Instance.new("Frame")
		local Title_1 = Instance.new("TextLabel")
		local UIListLayout_1 = Instance.new("UIListLayout")
		local Description_1 = Instance.new("TextLabel")

		Shadow.Name = "Shadow"
		Shadow.Parent = Notification
		Shadow.BackgroundColor3 = Color3.fromRGB(163,162,165)
		Shadow.BackgroundTransparency = 1
		Shadow.Size = UDim2.new(0, 240,0, 0)
		Shadow.Image = GetAsset("1316045217")
		Shadow.ImageColor3 = themes[IsTheme].Shadow
		Shadow.ImageTransparency = 0.5
		Shadow.ScaleType = Enum.ScaleType.Slice
		Shadow.SliceCenter = Rect.new(10, 10, 118, 118)

		addToTheme('Shadow', Shadow)

		UIPadding_1.Parent = Shadow
		UIPadding_1.PaddingBottom = UDim.new(0,5)
		UIPadding_1.PaddingLeft = UDim.new(0,5)
		UIPadding_1.PaddingRight = UDim.new(0,5)
		UIPadding_1.PaddingTop = UDim.new(0,5)

		Background_1.Name = "Background"
		Background_1.Parent = Shadow
		Background_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Background_1.BackgroundColor3 = themes[IsTheme].Background
		Background_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Background_1.BorderSizePixel = 0
		Background_1.Position = UDim2.new(0.5, 0,0.5, 0)
		Background_1.Size = UDim2.new(1, 0,1, 0)
		Background_1.ClipsDescendants = true
		Background_1.GroupTransparency = 1

		addToTheme('Background', Background_1)

		UICorner_1.Parent = Background_1
		UICorner_1.CornerRadius = UDim.new(0,8)

		Frame_1.Parent = Background_1
		Frame_1.AnchorPoint = Vector2.new(0, 1)
		Frame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Frame_1.BackgroundTransparency = 0.85
		Frame_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Frame_1.BorderSizePixel = 0
		Frame_1.Position = UDim2.new(0, 0,1, 0)
		Frame_1.Size = UDim2.new(1, 0,0, 4)
		
		ContentContainer.Name = "ContentContainer"
		ContentContainer.Parent = Background_1
		ContentContainer.BackgroundTransparency = 1
		ContentContainer.Size = UDim2.new(1, -24, 1, -24)
		ContentContainer.Position = UDim2.new(0, 12, 0, 12)
		
		UIListLayout_Content.Parent = ContentContainer
		UIListLayout_Content.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_Content.Padding = UDim.new(0, 12)
		UIListLayout_Content.VerticalAlignment = Enum.VerticalAlignment.Center
		
		IconImg.Name = "Icon"
		IconImg.Parent = ContentContainer
		IconImg.BackgroundTransparency = 1
		IconImg.Size = UDim2.new(0, 28, 0, 28)
		if p.Icon then
			IconImg.Image = GetAsset(p.Icon)
			addToTheme('Text & Icon', IconImg)
		else
			IconImg.Image = Icon_1.Image
			IconImg.ImageRectSize = Icon_1.ImageRectSize
			IconImg.ImageRectOffset = Icon_1.ImageRectOffset
			IconImg.ImageColor3 = Color3.fromRGB(255,255,255)
		end
		
		Text_1.Name = "Text"
		Text_1.Parent = ContentContainer
		Text_1.BackgroundTransparency = 1
		Text_1.Size = UDim2.new(1, -40, 1, 0)

		Title_1.Name = "Title"
		Title_1.Parent = Text_1
		Title_1.AutomaticSize = Enum.AutomaticSize.Y
		Title_1.BackgroundTransparency = 1
		Title_1.Size = UDim2.new(1, 0,0, 0)
		Title_1.Font = Enum.Font.GothamBold
		Title_1.Text = tostring(Title)
		Title_1.TextColor3 = themes[IsTheme]['Text & Icon']
		Title_1.TextSize = 14
		Title_1.TextWrapped = true
		Title_1.RichText = true
		Title_1.TextXAlignment = Enum.TextXAlignment.Left
		Title_1.TextYAlignment = Enum.TextYAlignment.Top

		addToTheme('Text & Icon', Title_1)

		UIListLayout_1.Parent = Text_1
		UIListLayout_1.Padding = UDim.new(0,4)
		UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder

		Description_1.Name = "Description"
		Description_1.Parent = Text_1
		Description_1.AutomaticSize = Enum.AutomaticSize.Y
		Description_1.BackgroundTransparency = 1
		Description_1.LayoutOrder = 2
		Description_1.Size = UDim2.new(1, 0,0, 0)
		Description_1.Font = Enum.Font.Gotham
		Description_1.Text = tostring(Desc)
		Description_1.TextColor3 = themes[IsTheme]['Text & Icon']
		Description_1.TextSize = 12
		Description_1.TextTransparency = 0.4
		Description_1.TextWrapped = true
		Description_1.RichText = true
		Description_1.TextXAlignment = Enum.TextXAlignment.Left
		Description_1.TextYAlignment = Enum.TextYAlignment.Top
		
		if Desc == "" then
			Description_1.Visible = false
		end

		addToTheme('Text & Icon', Description_1)

		Background_1.Size = UDim2.new(1, 0,1, 0) - UDim2.fromOffset(5, 5)

		if Desc and Desc ~= '' then
			Description_1.Visible = true
		end

		local function updateSize()
			task.defer(function()
				local newSize = math.max(28, UIListLayout_1.AbsoluteContentSize.Y) + 32
				if Shadow.Size.Y.Offset ~= newSize then
					Shadow.Size = UDim2.new(0, 240, 0, newSize)
				end
			end)
		end

		delay(.1, updateSize)

		UIListLayout_1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSize)

		local g = tw({
			v = Shadow,
			t = 0.15,
			s = Enum.EasingStyle.Exponential,
			d = "InOut",
			g = {
				Size = UDim2.new(0, 180,0, 55)
			}
		})
		g:Play()
		g.Completed:Wait()
		tw({
			v = Background_1,
			t = 0.15,
			s = Enum.EasingStyle.Linear,
			d = "InOut",
			g = {
				Size = UDim2.new(1, 0,1, 0),
				GroupTransparency = 0.3
			}
		}):Play()

		task.spawn(function()
			for i = Time, 1, -1 do
				tw({v = Frame_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = UDim2.new(i / Time, 0,0, 4)}}):Play()
				task.wait(1)
			end
			local f = tw({
				v = Background_1,
				t = 0.15,
				s = Enum.EasingStyle.Linear,
				d = "InOut",
				g = {
					Size = UDim2.new(1, 0,1, 0) - UDim2.fromOffset(5, 5),
					GroupTransparency = 1
				}
			})
			f:Play()
			f.Completed:Connect(function()
				Shadow.ImageTransparency = 1
				local g = tw({
					v = Shadow,
					t = 0.15,
					s = Enum.EasingStyle.Exponential,
					d = "InOut",
					g = {
						Size = UDim2.new(0, 180,0, 0)
					}
				})
				g:Play()
				g.Completed:Connect(function()
					Shadow:Destroy()
				end)
			end)
		end)
	end

	function Tabs:Dialog(p)
		if Shadow_1:FindFirstChild('Dialog') then
			return
		end
		local Button1 = p.Button1.Callback or function() end
		local Button2 = p.Button2.Callback or function() end
		local Title = p.Title or 'null'
		local TitleButton1 = p.Button1.Title or 'null'
		local TitleButton2 = p.Button2.Title or 'null'
		local Color1 = p.Button1.Color or Color3.fromRGB(0, 188, 0)
		local Color2 = p.Button2.Color or Color3.fromRGB(226, 39, 6)

		local Dialog = Instance.new("CanvasGroup")
		local UICorner_1 = Instance.new("UICorner")
		local Frame_1 = Instance.new("Frame")
		local TextLabel_1 = Instance.new("TextLabel")
		local UIListLayout_1 = Instance.new("UIListLayout")
		local Frame_2 = Instance.new("Frame")
		local Button1_1 = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIGradient_1 = Instance.new("UIGradient")
		local UIStroke_1 = Instance.new("UIStroke")
		local UIGradient_2 = Instance.new("UIGradient")
		local TextLabel_2 = Instance.new("TextLabel")
		local UIStroke_2 = Instance.new("UIStroke")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local Button2_1 = Instance.new("Frame")
		local UICorner_3 = Instance.new("UICorner")
		local UIGradient_3 = Instance.new("UIGradient")
		local UIStroke_3 = Instance.new("UIStroke")
		local UIGradient_4 = Instance.new("UIGradient")
		local TextLabel_3 = Instance.new("TextLabel")
		local UIStroke_4 = Instance.new("UIStroke")

		Dialog.Name = "Dialog"
		Dialog.Parent = Shadow_1
		Dialog.BackgroundColor3 = Color3.fromRGB(0,0,0)
		Dialog.BackgroundTransparency = 0.3
		Dialog.BorderColor3 = Color3.fromRGB(0,0,0)
		Dialog.BorderSizePixel = 0
		Dialog.Size = UDim2.new(1, 0,1, 0)
		Dialog.GroupTransparency = 1

		UICorner_1.Parent = Dialog
		UICorner_1.CornerRadius = UDim.new(0,17)

		Frame_1.Parent = Dialog
		Frame_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Frame_1.BackgroundTransparency = 1
		Frame_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Frame_1.BorderSizePixel = 0
		Frame_1.Position = UDim2.new(0.5, 0,0.5, 0)
		Frame_1.Size = UDim2.new(0, 100,0, 100)

		TextLabel_1.Parent = Frame_1
		TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabel_1.BackgroundTransparency = 1
		TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
		TextLabel_1.BorderSizePixel = 0
		TextLabel_1.Size = UDim2.new(0, 200,0, 30)
		TextLabel_1.Font = Enum.Font.GothamBold
		TextLabel_1.RichText = true
		TextLabel_1.Text = tostring(Title)
		TextLabel_1.TextColor3 = Color3.fromRGB(255,255,255)
		TextLabel_1.TextSize = 20

		UIListLayout_1.Parent = Frame_1
		UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

		Frame_2.Parent = Frame_1
		Frame_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Frame_2.BackgroundTransparency = 1
		Frame_2.BorderColor3 = Color3.fromRGB(0,0,0)
		Frame_2.BorderSizePixel = 0
		Frame_2.LayoutOrder = 1
		Frame_2.Size = UDim2.new(0, 100,0, 50)

		Button1_1.Name = "Button1"
		Button1_1.Parent = Frame_2
		Button1_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Button1_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Button1_1.BorderSizePixel = 0
		Button1_1.Size = UDim2.new(0, 130,0, 40)

		UICorner_2.Parent = Button1_1
		UICorner_2.CornerRadius = UDim.new(1,0)

		UIGradient_1.Parent = Button1_1
		UIGradient_1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(124, 124, 124))}

		UIStroke_1.Parent = Button1_1
		UIStroke_1.Color = Color3.fromRGB(255,255,255)
		UIStroke_1.Thickness = 2

		UIGradient_2.Parent = UIStroke_1
		UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(124, 124, 124))}
		UIGradient_2.Rotation = 180

		TextLabel_2.Parent = Button1_1
		TextLabel_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabel_2.BackgroundTransparency = 1
		TextLabel_2.BorderColor3 = Color3.fromRGB(0,0,0)
		TextLabel_2.BorderSizePixel = 0
		TextLabel_2.Size = UDim2.new(1, 0,1, 0)
		TextLabel_2.Font = Enum.Font.GothamBold
		TextLabel_2.Text = TitleButton1
		TextLabel_2.TextColor3 = Color1
		TextLabel_2.TextSize = 16

		UIStroke_2.Parent = TextLabel_2
		UIStroke_2.Thickness = 1
		UIStroke_2.Transparency = 0.95

		UIListLayout_2.Parent = Frame_2
		UIListLayout_2.Padding = UDim.new(0,10)
		UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

		Button2_1.Name = "Button2"
		Button2_1.Parent = Frame_2
		Button2_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Button2_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Button2_1.BorderSizePixel = 0
		Button2_1.Size = UDim2.new(0, 130,0, 40)

		UICorner_3.Parent = Button2_1
		UICorner_3.CornerRadius = UDim.new(1,0)

		UIGradient_3.Parent = Button2_1
		UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(124, 124, 124))}

		UIStroke_3.Parent = Button2_1
		UIStroke_3.Color = Color3.fromRGB(255,255,255)
		UIStroke_3.Thickness = 2

		UIGradient_4.Parent = UIStroke_3
		UIGradient_4.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(124, 124, 124))}
		UIGradient_4.Rotation = 180

		TextLabel_3.Parent = Button2_1
		TextLabel_3.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabel_3.BackgroundTransparency = 1
		TextLabel_3.BorderColor3 = Color3.fromRGB(0,0,0)
		TextLabel_3.BorderSizePixel = 0
		TextLabel_3.Size = UDim2.new(1, 0,1, 0)
		TextLabel_3.Font = Enum.Font.GothamBold
		TextLabel_3.Text = TitleButton2
		TextLabel_3.TextColor3 = Color2
		TextLabel_3.TextSize = 16

		UIStroke_4.Parent = TextLabel_3
		UIStroke_4.Thickness = 1
		UIStroke_4.Transparency = 0.95

		tw({v = Dialog, t = 0.25, s = Enum.EasingStyle.Linear, d = "Out", g = {GroupTransparency = 0}}):Play()
		local Click1 = click(Button1_1)
		local Click2 = click(Button2_1)
		Click1.MouseButton1Click:Connect(function()
			pcall(Button1)
			tw({v = TextLabel_2, t = 0.15, s = Enum.EasingStyle.Back, d = "Out", g = {TextSize = TextLabel_2.TextSize - 2}}):Play()
			delay(.06, function()
				tw({v = TextLabel_2, t = 0.15, s = Enum.EasingStyle.Back, d = "Out", g = {TextSize = 16}}):Play()
			end)
			local f = tw({v = Dialog, t = 0.25, s = Enum.EasingStyle.Linear, d = "Out", g = {GroupTransparency = 1}})
			f:Play()
			f.Completed:Wait()
			Dialog:Destroy()
		end)

		Click2.MouseButton1Click:Connect(function()
			pcall(Button2)
			tw({v = TextLabel_3, t = 0.15, s = Enum.EasingStyle.Back, d = "Out", g = {TextSize = TextLabel_3.TextSize - 2}}):Play()
			delay(.06, function()
				tw({v = TextLabel_3, t = 0.15, s = Enum.EasingStyle.Back, d = "Out", g = {TextSize = 16}}):Play()
			end)
			local f = tw({v = Dialog, t = 0.25, s = Enum.EasingStyle.Linear, d = "Out", g = {GroupTransparency = 1}})
			f:Play()
			f.Completed:Wait()
			Dialog:Destroy()
		end)
	end

	do
		local ReopenBreadcrumb, ReopenBreadcrumbEnabled -- breadcrumb (CloseUIButton) /
		local Size_1 = Instance.new("TextButton")

		Size_1.Name = "Size"
		Size_1.Parent = Background_1
		Size_1.Active = true
		Size_1.AnchorPoint = Vector2.new(1, 1)
		Size_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Size_1.BackgroundTransparency = 1
		Size_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Size_1.BorderSizePixel = 0
		Size_1.Position = UDim2.new(1, 0,1, 0)
		Size_1.Size = UDim2.new(0, 20,0, 20)
		Size_1.Font = Enum.Font.SourceSans
		Size_1.Text = ""
		Size_1.TextSize = 14

		local SizeFrame = Instance.new("Frame")
		local ImageLabel_1 = Instance.new("ImageLabel")
		local UICorner_1 = Instance.new("UICorner")

		SizeFrame.Name = "SizeFrame"
		SizeFrame.Parent = Background_1
		SizeFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
		SizeFrame.BackgroundTransparency = 1
		SizeFrame.BorderColor3 = Color3.fromRGB(0,0,0)
		SizeFrame.BorderSizePixel = 0
		SizeFrame.Size = UDim2.new(1, 0,1, 0)

		ImageLabel_1.Parent = SizeFrame
		ImageLabel_1.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		ImageLabel_1.BackgroundTransparency = 1
		ImageLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
		ImageLabel_1.BorderSizePixel = 0
		ImageLabel_1.Position = UDim2.new(0.5, 0,0.5, 0)
		ImageLabel_1.Size = UDim2.new(0, 100,0, 100)
		ImageLabel_1.Image = GetAsset("13857987062")
		ImageLabel_1.ImageTransparency = 1

		UICorner_1.Parent = SizeFrame
		UICorner_1.CornerRadius = UDim.new(0,17)

		Size_1.MouseButton1Down:Connect(function()
			R = true
		end)

		local isZ = false
		local originalSize, originalPosition

		Minisize_1.MouseButton1Click:Connect(function()
			if not isZ then
				originalSize = Shadow_1.Size
				originalPosition = Shadow_1.Position
				tw({v = Shadow_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0, 0, 0, 0)
				}}):Play()
				Minisize_1.Image = GetAsset("13857981896")
			else
				Minisize_1.Image = GetAsset("13857987062")
				tw({v = Shadow_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {
					Size = originalSize,
					Position = originalPosition
				}}):Play()
			end
			isZ = not isZ
		end)

		if not HAA then
			local AP, PAZ = Shadow_1.AbsolutePosition, Shadow_1.Parent.AbsoluteSize
			local NP = UDim2.new((AP.X / PAZ.X),
				Shadow_1.Position.X.Offset,
				(AP.Y / PAZ.Y),
				Shadow_1.Position.Y.Offset)

			Shadow_1.AnchorPoint = Vector2.new(0, 0)
			Shadow_1.Position = NP
			HAA = true
		end

		U.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				R = false
				tw({v = SizeFrame, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {BackgroundTransparency = 1}}):Play()
				tw({v = ImageLabel_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageTransparency = 1}}):Play()
			end
		end)

		U.InputChanged:Connect(function(i)
			if not isZ and R and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				local nW = math.max(450, i.Position.X - Shadow_1.AbsolutePosition.X)
				local nH = math.max(220, i.Position.Y - Shadow_1.AbsolutePosition.Y)
				local nZ = UDim2.new(0, nW, 0, nH)
				tw({v = Shadow_1, t = 0.05, s = Enum.EasingStyle.Exponential, d = "Out", g = {Size = nZ}}):Play()
				tw({v = SizeFrame, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {BackgroundTransparency = 0.6}}):Play()
				tw({v = ImageLabel_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageTransparency = 0}}):Play()
				ImageLabel_1.Image = GetAsset("13857987062")	
			elseif isZ and R and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				tw({v = SizeFrame, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {BackgroundTransparency = 0.6}}):Play()
				tw({v = ImageLabel_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "Out", g = {ImageTransparency = 0}}):Play()
				ImageLabel_1.Image = GetAsset("14906268026")
			end
		end)

		lak(Topbar_1, Shadow_1)

		local isopen = false
		local firsttime = false
		local oSize
		local uiTweening = false
		local function closeui()
			if uiTweening then return end
			uiTweening = true
			task.delay(0.4, function() uiTweening = false end)
			
			isopen = not isopen
			if isopen then
				oSize = Background_1.Size
				local close = tw({
					v = Background_1,
					t = 0.15,
					s = Enum.EasingStyle.Linear,
					d = "InOut",
					g = {
						GroupTransparency = 1,
						Size = oSize - UDim2.fromOffset(5, 5)
					}
				})
				close:Play()
				close.Completed:Wait()
				Shadow_1.Visible = false
				
				-- Hide any open dropdowns when the main UI closes
				if ScreenGui then
					for _, child in ipairs(ScreenGui:GetChildren()) do
						if child.Name == "XinzDropdown" and child.Visible then
							child.Visible = false
						end
					end
				end
			else
				Shadow_1.Visible = true  
				local open = tw({
					v = Background_1,
					t = 0.15,
					s = Enum.EasingStyle.Linear,
					d = "InOut",
					g = {
						GroupTransparency = 0,
						Size = oSize
					}
				})
				open:Play()
			end

			if ReopenBreadcrumb then
				if isopen and ReopenBreadcrumbEnabled then
					ReopenBreadcrumb.Visible = true
					local targetPos = ReopenBreadcrumb.Position
					local startPos
					if CrumbOrientation == "Bottom" then
						startPos = UDim2.new(targetPos.X.Scale, targetPos.X.Offset, targetPos.Y.Scale, targetPos.Y.Offset + 50)
					elseif CrumbOrientation == "Top" then
						startPos = UDim2.new(targetPos.X.Scale, targetPos.X.Offset, targetPos.Y.Scale, targetPos.Y.Offset - 50)
					elseif CrumbOrientation == "Left" then
						startPos = UDim2.new(targetPos.X.Scale, targetPos.X.Offset - 50, targetPos.Y.Scale, targetPos.Y.Offset)
					elseif CrumbOrientation == "Right" then
						startPos = UDim2.new(targetPos.X.Scale, targetPos.X.Offset + 50, targetPos.Y.Scale, targetPos.Y.Offset)
					else
						startPos = UDim2.new(targetPos.X.Scale, targetPos.X.Offset, targetPos.Y.Scale, targetPos.Y.Offset + 50)
					end
					ReopenBreadcrumb.Position = startPos
					tw({
						v = ReopenBreadcrumb,
						t = 0.4,
						s = Enum.EasingStyle.Exponential,
						d = "Out",
						g = {Position = targetPos}
					}):Play()
				else
					local origPos = ReopenBreadcrumb.Position
					local outPos
					if CrumbOrientation == "Bottom" then
						outPos = UDim2.new(origPos.X.Scale, origPos.X.Offset, origPos.Y.Scale, origPos.Y.Offset + 50)
					elseif CrumbOrientation == "Top" then
						outPos = UDim2.new(origPos.X.Scale, origPos.X.Offset, origPos.Y.Scale, origPos.Y.Offset - 50)
					elseif CrumbOrientation == "Left" then
						outPos = UDim2.new(origPos.X.Scale, origPos.X.Offset - 50, origPos.Y.Scale, origPos.Y.Offset)
					elseif CrumbOrientation == "Right" then
						outPos = UDim2.new(origPos.X.Scale, origPos.X.Offset + 50, origPos.Y.Scale, origPos.Y.Offset)
					else
						outPos = UDim2.new(origPos.X.Scale, origPos.X.Offset, origPos.Y.Scale, origPos.Y.Offset + 50)
					end
					
					local outTween = tw({
						v = ReopenBreadcrumb,
						t = 0.3,
						s = Enum.EasingStyle.Exponential,
						d = "In",
						g = {Position = outPos}
					})
					outTween:Play()
					task.delay(0.3, function()
						if not isopen then
							ReopenBreadcrumb.Visible = false
							ReopenBreadcrumb.Position = origPos
						end
					end)
				end
			end

			if not firsttime then
				firsttime = true
				Tabs:Notify({
					Title = Title .. " v" .. Version,
					Desc = 'Press the <font color="#FF77A5" size="14">('..tostring(Keybind):gsub("Enum.KeyCode.", "")..')</font> button to hide and show the UI',
					Time = 10
				})
			end
		end
		Tabs.closeui = closeui

		ChSize_1.MouseButton1Click:Connect(closeui)

		U.InputBegan:Connect(function(i)
			if i.KeyCode == Keybind then
				local focusedTextBox = U:GetFocusedTextBox()
				if not focusedTextBox then
					closeui()
				end
			end
		end)

		local CallTheme = function(v)
			IsTheme = v
			local t = themes[v]
			Library:setTheme({
				['Shadow'] = t.Shadow,
				['Background'] = t.Background,
				['Page'] = t.Page,
				['Main'] = t.Main,
				['Text'] = t.Text,
				['Icon'] = t.Icon,
				['Text & Icon'] = t['Text & Icon'],
				['Function'] = {
					['Toggle'] = {
						['Background'] = t.Function.Toggle.Background,
						['True'] = {
							['Toggle Background'] = t.Function.Toggle.True['Toggle Background'],
							['Toggle Value'] = t.Function.Toggle.True['Toggle Value'],
						},
						['False'] = {
							['Toggle Background'] = t.Function.Toggle.False['Toggle Background'],
							['Toggle Value'] = t.Function.Toggle.False['Toggle Value'],
						}
					},
					['Label'] = {
						['Background'] = t.Function.Label.Background,
					},
					['Dropdown'] = {
						['Background'] = t.Function.Dropdown.Background,
						['Value Background'] = t.Function.Dropdown['Value Background'],
						['Value Stroke'] = t.Function.Dropdown['Value Stroke'],
						['Dropdown Select'] = {
							['Background'] = t.Function.Dropdown['Dropdown Select'].Background,
							['Search'] = t.Function.Dropdown['Dropdown Select'].Search,
							['Item Background'] = t.Function.Dropdown['Dropdown Select']['Item Background'],
						}
					},
					['Slider'] = {
						['Background'] = t.Function.Slider.Background,
						['Value Background'] = t.Function.Slider['Value Background'],
						['Value Stroke'] = t.Function.Slider['Value Stroke'],
						['Slider Bar'] = t.Function.Slider['Slider Bar'],
						['Slider Bar Value'] = t.Function.Slider['Slider Bar Value'],
						['Circle Value'] = t.Function.Slider['Circle Value'],
					},
					['Code'] = {
						['Background'] = t.Function.Code.Background,
						['Background Code'] = t.Function.Code['Background Code'],
						['Background Code Value'] = t.Function.Code['Background Code Value'],
						['ScrollingFrame Code'] = t.Function.Code['ScrollingFrame Code'],
					},
					['Button'] = {
						['Background'] = t.Function.Button.Background,
						['Click'] = t.Function.Button.Click,
					},
					['Textbox'] = {
						['Background'] = t.Function.Textbox.Background,
						['Value Background'] = t.Function.Textbox['Value Background'],
						['Value Stroke'] = t.Function.Textbox['Value Stroke'],
					},
					['Keybind'] = {
						['Background'] = t.Function.Keybind.Background,
						['Value Background'] = t.Function.Keybind['Value Background'],
						['Value Stroke'] = t.Function.Keybind['Value Stroke'],
						['True'] = {
							['Toggle Background'] = t.Function.Keybind.True['Toggle Background'],
							['Toggle Value'] = t.Function.Keybind.True['Toggle Value'],
						},
						['False'] = {
							['Toggle Background'] = t.Function.Keybind.False['Toggle Background'],
							['Toggle Value'] = t.Function.Keybind.False['Toggle Value'],
						}
					},
					['Color Picker'] = {
						['Background'] = t.Function['Color Picker'].Background,
						['Color Select'] = {
							['Background'] = t.Function['Color Picker']['Color Select'].Background,
							['UIStroke'] = t.Function['Color Picker']['Color Select'].UIStroke,
						}
					}
				}
			})
			if Tabs.ActiveTabTitle then
				Tabs.ActiveTabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
			if Tabs.ActiveTabIcon then
				Tabs.ActiveTabIcon.ImageColor3 = t.Main
			end
			if Tabs.ActiveDockBtn then
				Tabs.ActiveDockBtn.ImageColor3 = t.Main
			end
		end
		local ThemeDrop = addDropdownSelect(DropdownValue_1, DropdownValue_1, false, CallTheme, Theme, themes.index)

		Close_1.MouseButton1Click:Connect(function()
			Tabs:Dialog({
				Title = "Do you want to <font color='#FF0000'>close</font> the ui?",
				Button1 = {
					Title = 'Confirm',
					Color = Color3.fromRGB(0, 188, 0),
					Callback = function()
						ScreenGui:Destroy()
					end,
				},
				Button2 = {
					Title = 'Cancel',
					Color = Color3.fromRGB(226, 39, 6),
				}
			})
		end)

		do
			local CloseUI = p.CloseUIButton
			local CloseUIEnabled = CloseUI.Enabled
			if CloseUIEnabled == nil then CloseUIEnabled = true end

			local currentClosedStyle = "Breadcrumb"
			local CloseUIShadow = Instance.new("ImageLabel")
			local UIPaddingCloseUI_1 = Instance.new("UIPadding")
			local BackgroundCloseUI_1 = Instance.new("Frame")
			local UICornerCloseUI_1 = Instance.new("UICorner")
			local Crumb_1 = Instance.new("Frame")
			local UIListLayoutCrumb_1 = Instance.new("UIListLayout")
			local UIPaddingCrumb_1 = Instance.new("UIPadding")
			local HomeBadge_1 = Instance.new("Frame")
			local UICornerHome_1 = Instance.new("UICorner")
			local HomeIcon_1 = Instance.new("ImageLabel")
			local Chevron_1 = Instance.new("ImageLabel")
			local Title_1 = Instance.new("TextLabel")

			CloseUIShadow.Name = "CloseUIShadow"
			CloseUIShadow.Parent = ScreenGui
			CloseUIShadow.BackgroundColor3 = Color3.fromRGB(163,162,165)
			CloseUIShadow.BackgroundTransparency = 1
			CloseUIShadow.AnchorPoint = Vector2.new(0.5, 1)
			CloseUIShadow.Position = UDim2.new(0.5, 0, 0.98, 0)
			CloseUIShadow.Size = UDim2.new(0, 120, 0, 48)
			CloseUIShadow.Image = GetAsset("1316045217")
			CloseUIShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
			CloseUIShadow.ImageTransparency = 0.5
			CloseUIShadow.ScaleType = Enum.ScaleType.Slice
			CloseUIShadow.SliceCenter = Rect.new(10, 10, 118, 118)
			CloseUIShadow.Visible = false -- UI   closeui()
			
			local CloseUIScale = Instance.new("UIScale")
			CloseUIScale.Parent = CloseUIShadow
			CloseUIScale.Scale = 1

			addToTheme('Shadow', CloseUIShadow)

			UIPaddingCloseUI_1.Parent = CloseUIShadow
			UIPaddingCloseUI_1.PaddingBottom = UDim.new(0,5)
			UIPaddingCloseUI_1.PaddingLeft = UDim.new(0,5)
			UIPaddingCloseUI_1.PaddingRight = UDim.new(0,5)
			UIPaddingCloseUI_1.PaddingTop = UDim.new(0,5)

			BackgroundCloseUI_1.Name = "BackgroundCloseUI"
			BackgroundCloseUI_1.Parent = CloseUIShadow
			BackgroundCloseUI_1.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
			BackgroundCloseUI_1.BorderSizePixel = 0
			BackgroundCloseUI_1.Size = UDim2.new(1, 0, 1, 0)
			BackgroundCloseUI_1.ClipsDescendants = true

			addToTheme('Background', BackgroundCloseUI_1)

			UICornerCloseUI_1.Parent = BackgroundCloseUI_1
			UICornerCloseUI_1.CornerRadius = UDim.new(1, 0)

			Crumb_1.Name = "Crumb"
			Crumb_1.Parent = BackgroundCloseUI_1
			Crumb_1.BackgroundTransparency = 1
			Crumb_1.Size = UDim2.new(1, 0, 1, 0)

			UIListLayoutCrumb_1.Parent = Crumb_1
			UIListLayoutCrumb_1.FillDirection = Enum.FillDirection.Horizontal
			UIListLayoutCrumb_1.Padding = UDim.new(0, 6)
			UIListLayoutCrumb_1.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayoutCrumb_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayoutCrumb_1.VerticalAlignment = Enum.VerticalAlignment.Center

			UIPaddingCrumb_1.Parent = Crumb_1
			UIPaddingCrumb_1.PaddingLeft = UDim.new(0, 3)
			UIPaddingCrumb_1.PaddingRight = UDim.new(0, 3)
			UIPaddingCrumb_1.PaddingTop = UDim.new(0, 3)
			UIPaddingCrumb_1.PaddingBottom = UDim.new(0, 3)

			HomeBadge_1.Name = "HomeBadge"
			HomeBadge_1.Parent = Crumb_1
			HomeBadge_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HomeBadge_1.BackgroundTransparency = 0.95
			HomeBadge_1.Size = UDim2.new(0, 32, 0, 32)
			HomeBadge_1.LayoutOrder = 1
			
			local UIStroke_Home = Instance.new("UIStroke")
			UIStroke_Home.Parent = HomeBadge_1
			UIStroke_Home.Color = Color3.fromRGB(255, 255, 255)
			UIStroke_Home.Transparency = 0.9

			UICornerHome_1.Parent = HomeBadge_1
			UICornerHome_1.CornerRadius = UDim.new(1, 0)

			HomeIcon_1.Parent = HomeBadge_1
			HomeIcon_1.AnchorPoint = Vector2.new(0.5, 0.5)
			HomeIcon_1.BackgroundTransparency = 1
			HomeIcon_1.Position = UDim2.new(0.5, 0, 0.5, 0)
			HomeIcon_1.Size = UDim2.new(0, 26, 0, 26)
			HomeIcon_1.Image = Icon_1.Image
			HomeIcon_1.ImageRectSize = Icon_1.ImageRectSize
			HomeIcon_1.ImageRectOffset = Icon_1.ImageRectOffset
			HomeIcon_1.ImageColor3 = Color3.fromRGB(255,255,255)

			Chevron_1.Visible = false



			if CloseUI.Icon then
				local IconImg = Instance.new("ImageLabel")
				IconImg.Name = "Icon"
				IconImg.Parent = Crumb_1
				IconImg.BackgroundTransparency = 1
				IconImg.Size = UDim2.new(0, 20, 0, 20)
				IconImg.LayoutOrder = 4
				IconImg.Image = type(CloseUI.Icon) == "number" and "rbxassetid://"..CloseUI.Icon or CloseUI.Icon
				addToTheme('Text & Icon', IconImg)
			end


			local HomeClick = Instance.new("TextButton")
			HomeClick.Name = "HomeClick"
			HomeClick.Parent = HomeBadge_1
			HomeClick.Size = UDim2.new(1, 0, 1, 0)
			HomeClick.BackgroundTransparency = 1
			HomeClick.Text = ""
			HomeClick.ZIndex = 10
			
			local isBreadcrumbMini = false
			local updateCrumbSize
			
			local function toggleMini(force)
				if force ~= nil then
					isBreadcrumbMini = force
				else
					isBreadcrumbMini = not isBreadcrumbMini
				end
				
				if currentClosedStyle == "Breadcrumb" then
					for _, child in ipairs(Crumb_1:GetChildren()) do
						if child.Name:match("^DockBtn_") then
							child.Visible = not isBreadcrumbMini
						end
					end
				else
					for _, child in ipairs(Crumb_1:GetChildren()) do
						if child.Name:match("^DockBtn_") then
							child.Visible = true
						end
					end
				end
				if updateCrumbSize then updateCrumbSize() end
			end

			local animGeneration = 0
			updateCrumbSize = function()
				task.defer(function()
					local dockBtns = {}
					for _, child in ipairs(Crumb_1:GetChildren()) do
						if child.Name:match("^DockBtn_") then
							table.insert(dockBtns, child)
						end
					end
					
					animGeneration = animGeneration + 1
					local currentGen = animGeneration
					
					local easingStyle = currentClosedStyle == "Gooey plus menu" and Enum.EasingStyle.Back or Enum.EasingStyle.Exponential
					local duration = currentClosedStyle == "Gooey plus menu" and 0.4 or 0.2
					
					if currentClosedStyle == "Gooey plus menu" then
						UIListLayoutCrumb_1.Parent = nil
						BackgroundCloseUI_1.ClipsDescendants = false
						HomeBadge_1.AnchorPoint = Vector2.new(0.5, 0.5)
						HomeBadge_1.Position = UDim2.new(0.5, 0, 0.5, 0)
						BackgroundCloseUI_1.AnchorPoint = Vector2.new(0.5, 0.5)
						BackgroundCloseUI_1.Position = UDim2.new(0.5, 0, 0.5, 0)
						UIPaddingCrumb_1.PaddingLeft = UDim.new(0, 0)
						UIPaddingCrumb_1.PaddingRight = UDim.new(0, 0)
						UIPaddingCrumb_1.PaddingTop = UDim.new(0, 0)
						UIPaddingCrumb_1.PaddingBottom = UDim.new(0, 0)
						
						local count = #dockBtns
						local radius = 80
						local anglePerItem = 40 -- Degrees between each item
						local totalSpread = (count - 1) * anglePerItem
						local maxSpread = 180
						
						if totalSpread > maxSpread then
							totalSpread = maxSpread
							if count > 1 then
								anglePerItem = maxSpread / (count - 1)
							end
						end
						
						local baseAngle = 0
						if CrumbOrientation == "Bottom" then baseAngle = 270
						elseif CrumbOrientation == "Top" then baseAngle = 90
						elseif CrumbOrientation == "Left" then baseAngle = 0
						elseif CrumbOrientation == "Right" then baseAngle = 180
						end
						
						local actualStartAngle
						local angleStep
						if CrumbOrientation == "Bottom" or CrumbOrientation == "Left" then
							actualStartAngle = baseAngle - (totalSpread / 2)
							angleStep = anglePerItem
						else
							actualStartAngle = baseAngle + (totalSpread / 2)
							angleStep = -anglePerItem
						end
						
						if count > 0 then
							for i, btn in ipairs(dockBtns) do
								btn.AnchorPoint = Vector2.new(0.5, 0.5)
								
								local bg = btn.Parent:FindFirstChild("IconBg_" .. btn.Name)
								if not bg then
									bg = Instance.new("Frame")
									bg.Name = "IconBg_" .. btn.Name
									bg.AnchorPoint = Vector2.new(0.5, 0.5)
									bg.Position = UDim2.new(0.5, 0, 0.5, 0)
									bg.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
									bg.ZIndex = btn.ZIndex - 1
									local corner = Instance.new("UICorner")
									corner.CornerRadius = UDim.new(1, 0)
									corner.Parent = bg
									bg.Parent = btn.Parent
									if addToTheme then addToTheme('Background', bg) end
								end
								
								if btn.Image == "" or btn.Image == GetAsset("0") then
									bg.Visible = false
								else
									bg.Visible = true
								end
								
								local delayTime = not isBreadcrumbMini and ((i - 1) * 0.025) or ((count - i) * 0.015)
								
								task.delay(delayTime, function()
									if currentGen ~= animGeneration then return end
									
									if not isBreadcrumbMini then
										local angleDeg = actualStartAngle + (i - 1) * angleStep
										local angle = math.rad(angleDeg)
										local offsetX = math.cos(angle) * radius
										local offsetY = math.sin(angle) * radius
										
										tw({v = btn, t = 0.5, s = Enum.EasingStyle.Back, d = "Out", g = {Position = UDim2.new(0.5, offsetX, 0.5, offsetY), Size = UDim2.new(0, 22, 0, 22), ImageTransparency = 0}}):Play()
										tw({v = bg, t = 0.5, s = Enum.EasingStyle.Back, d = "Out", g = {Position = UDim2.new(0.5, offsetX, 0.5, offsetY), Size = UDim2.new(0, 38, 0, 38), BackgroundTransparency = 0}}):Play()
									else
										tw({v = btn, t = 0.3, s = Enum.EasingStyle.Quad, d = "Out", g = {Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1}}):Play()
										tw({v = bg, t = 0.3, s = Enum.EasingStyle.Quad, d = "Out", g = {Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}}):Play()
									end
								end)
							end
						end
						
						if not isBreadcrumbMini then
							tw({v = CloseUIShadow, t = duration, s = easingStyle, d = "Out", g = {Size = UDim2.new(0, 200, 0, 200)}}):Play()
							tw({v = HomeIcon_1, t = duration, s = easingStyle, d = "Out", g = {Size = UDim2.new(0, 32, 0, 32)}}):Play()
							tw({v = HomeBadge_1, t = duration, s = easingStyle, d = "Out", g = {Size = UDim2.new(0, 38, 0, 38)}}):Play()
						else
							tw({v = CloseUIShadow, t = duration, s = easingStyle, d = "Out", g = {Size = UDim2.new(0, 48, 0, 48)}}):Play()
							tw({v = HomeIcon_1, t = duration, s = easingStyle, d = "Out", g = {Size = UDim2.new(0, 26, 0, 26)}}):Play()
							tw({v = HomeBadge_1, t = duration, s = easingStyle, d = "Out", g = {Size = UDim2.new(0, 32, 0, 32)}}):Play()
						end
						tw({v = BackgroundCloseUI_1, t = duration, s = easingStyle, d = "Out", g = {Size = UDim2.new(0, 44, 0, 44)}}):Play()
					else
						UIListLayoutCrumb_1.Parent = Crumb_1
						BackgroundCloseUI_1.ClipsDescendants = true
						HomeBadge_1.AnchorPoint = Vector2.new(0, 0)
						HomeBadge_1.Position = UDim2.new(0, 0, 0, 0)
						BackgroundCloseUI_1.AnchorPoint = Vector2.new(0, 0)
						BackgroundCloseUI_1.Position = UDim2.new(0, 0, 0, 0)
						tw({v = BackgroundCloseUI_1, t = duration, s = easingStyle, d = "Out", g = {Size = UDim2.new(1, 0, 1, 0)}}):Play()
						tw({v = HomeIcon_1, t = duration, s = easingStyle, d = "Out", g = {Size = UDim2.new(0, 26, 0, 26)}}):Play()
						tw({v = HomeBadge_1, t = duration, s = easingStyle, d = "Out", g = {Size = UDim2.new(0, 32, 0, 32)}}):Play()
						
						for _, btn in ipairs(dockBtns) do
							btn.AnchorPoint = Vector2.new(0, 0)
							btn.Size = UDim2.new(0, 24, 0, 24)
							btn.ImageTransparency = 0
							local bg = btn.Parent:FindFirstChild("IconBg_" .. btn.Name)
							if bg then bg.Visible = false end
						end

						if CrumbOrientation == "Bottom" or CrumbOrientation == "Top" then
							UIPaddingCrumb_1.PaddingRight = UDim.new(0, isBreadcrumbMini and 3 or 14)
							UIPaddingCrumb_1.PaddingBottom = UDim.new(0, 3)
							UIPaddingCrumb_1.PaddingTop = UDim.new(0, 3)
							UIPaddingCrumb_1.PaddingLeft = UDim.new(0, 3)
							local targetW = (UIListLayoutCrumb_1.AbsoluteContentSize.X / CloseUIScale.Scale) + (isBreadcrumbMini and 16 or 27)
							local w = math.max(48, targetW)
							tw({v = CloseUIShadow, t = duration, s = easingStyle, d = "Out", g = {Size = UDim2.new(0, w, 0, 48)}}):Play()
						else
							UIPaddingCrumb_1.PaddingRight = UDim.new(0, 3)
							UIPaddingCrumb_1.PaddingBottom = UDim.new(0, isBreadcrumbMini and 3 or 14)
							UIPaddingCrumb_1.PaddingTop = UDim.new(0, 3)
							UIPaddingCrumb_1.PaddingLeft = UDim.new(0, 3)
							local targetH = (UIListLayoutCrumb_1.AbsoluteContentSize.Y / CloseUIScale.Scale) + (isBreadcrumbMini and 16 or 27)
							local h = math.max(48, targetH)
							tw({v = CloseUIShadow, t = duration, s = easingStyle, d = "Out", g = {Size = UDim2.new(0, 48, 0, h)}}):Play()
						end
					end
				end)
			end
			UIListLayoutCrumb_1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCrumbSize)
			delay(0.1, function() toggleMini(true) end)
			
			Tabs.SetCrumbOrientation = function(pos)
				CrumbOrientation = pos
				if pos == "Bottom" then
					CloseUIShadow.AnchorPoint = Vector2.new(0.5, 1)
					tw({v = CloseUIShadow, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {Position = UDim2.new(0.5, 0, 0.98, 0)}}):Play()
					UIListLayoutCrumb_1.FillDirection = Enum.FillDirection.Horizontal
				elseif pos == "Top" then
					CloseUIShadow.AnchorPoint = Vector2.new(0.5, 0)
					tw({v = CloseUIShadow, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {Position = UDim2.new(0.5, 0, 0, 2)}}):Play()
					UIListLayoutCrumb_1.FillDirection = Enum.FillDirection.Horizontal
				elseif pos == "Left" then
					CloseUIShadow.AnchorPoint = Vector2.new(0, 0.5)
					tw({v = CloseUIShadow, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {Position = UDim2.new(0.02, 0, 0.5, 0)}}):Play()
					UIListLayoutCrumb_1.FillDirection = Enum.FillDirection.Vertical
				elseif pos == "Right" then
					CloseUIShadow.AnchorPoint = Vector2.new(1, 0.5)
					tw({v = CloseUIShadow, t = 0.3, s = Enum.EasingStyle.Exponential, d = "Out", g = {Position = UDim2.new(0.98, 0, 0.5, 0)}}):Play()
					UIListLayoutCrumb_1.FillDirection = Enum.FillDirection.Vertical
				end
				updateCrumbSize()
			end

			HomeClick.MouseButton1Click:Connect(function()
				if currentClosedStyle == "Breadcrumb" then
					toggleMini()
				else
					if Tabs.closeui then Tabs.closeui() end
				end
			end)
			
			CloseUIShadow.MouseEnter:Connect(function()
				if currentClosedStyle == "Gooey plus menu" then
					toggleMini(false) -- Expand
				end
			end)
			
			CloseUIShadow.MouseLeave:Connect(function()
				if currentClosedStyle == "Gooey plus menu" then
					toggleMini(true) -- Collapse
				end
			end)

			ReopenBreadcrumb = CloseUIShadow
			ReopenBreadcrumbEnabled = CloseUIEnabled
			Tabs.ReopenBreadcrumb = CloseUIShadow

			Tabs.SetClosedUIStyle = function(style)
				currentClosedStyle = style
				if style == "Gooey plus menu" then
					CloseUIShadow.ImageTransparency = 1
					toggleMini(true)
				else
					CloseUIShadow.ImageTransparency = 0.5
				end
			end
		end
	end

		-- Auto-generate Home Tab
		local HomeTab = Tabs:Tab({
			Title = "Home",
			Icon = "house"
		})

		-- Image Carousel ( ID )
		local CarouselImages = {
			GetAsset("92567372646337"), -- 1
			GetAsset("92567372646337"), -- 2
			GetAsset("92567372646337"), -- 3
		}
		
		local HomeCarousel = HomeTab:Image()
		HomeCarousel:SetImage(CarouselImages[1])
		
		task.spawn(function()
			local idx = 1
			while task.wait(5) do -- 5
				if not HomeCarousel then break end
				idx = idx + 1
				if idx > #CarouselImages then idx = 1 end
				
				local s = pcall(function()
					HomeCarousel:SetImage(CarouselImages[idx], true) -- true =  Fade ()
				end)
				if not s then break end
			end
		end)

		local plr = _Services.Players.LocalPlayer
		HomeTab:Label({
			Title = "Welcome, " .. (plr and plr.DisplayName or "User") .. "!",
			Desc = "Thanks for using " .. tostring(Title) .. (Version and (" v" .. tostring(Version)) or "")
		})

		HomeTab:Section({
			Title = "System Information"
		})

		HomeTab:Label({
			Title = "User",
			Desc = plr and plr.Name or "Unknown"
		})

		HomeTab:Label({
			Title = "Executor",
			Desc = (identifyexecutor and identifyexecutor()) or "Unknown"
		})

		-- Time updater
		local TimeLabel = HomeTab:Label({
			Title = "Current Time",
			Desc = os.date("%X")
		})
		task.spawn(function()
			while task.wait(1) do
				if not TimeLabel then break end
				local s, e = pcall(function()
					TimeLabel:SetDesc(os.date("%X"))
				end)
				if not s then break end
			end
		end)

		-- Resize Handle
		local ResizeHandle = Instance.new("ImageButton")
		ResizeHandle.Name = "ResizeHandle"
		ResizeHandle.Parent = Background_1
		ResizeHandle.AnchorPoint = Vector2.new(1, 1)
		ResizeHandle.Position = UDim2.new(1, -2, 1, -2)
		ResizeHandle.Size = UDim2.new(0, 15, 0, 15)
		ResizeHandle.BackgroundTransparency = 1
		ResizeHandle.Image = GetAsset("10901594247") -- using generic user icon as a placeholder handle, can be invisible
		ResizeHandle.ImageTransparency = 0.8
		ResizeHandle.ZIndex = 100
		
		make_resize(ResizeHandle, Shadow_1)

		local SettingsTab = Tabs:Tab({ Title = "UI Settings", Icon = "settings", LayoutOrder = 9999 })
		SettingsTab:Keybind({
			Title = "Toggle UI Keybind",
			Desc = "Change the key used to hide/show the UI",
			Key = Keybind,
			KeyChangedCallback = function(key)
				Keybind = key
			end
		})
		SettingsTab:Dropdown({
			Title = "Closed UI Style",
			Desc = "Select the style of the minimized UI",
			List = {"Breadcrumb", "Gooey plus menu"},
			Value = "Breadcrumb",
			Callback = function(style)
				if Tabs.SetClosedUIStyle then
					Tabs.SetClosedUIStyle(style)
				end
			end
		})

		SettingsTab:Dropdown({
			Title = "Breadcrumb Position",
			Desc = "Change where the closed UI tab is placed",
			List = {"Bottom", "Top", "Left", "Right"},
			Value = "Bottom",
			Callback = function(pos)
				if Tabs.SetCrumbOrientation then
					Tabs.SetCrumbOrientation(pos)
				end
			end
		})

		local breadcrumbSliderObj = SettingsTab:Slider({
			Title = "Breadcrumb Size",
			Desc = "Adjust the scale of the minimized UI tab",
			Min = 100,
			Max = 200,
			Default = 100,
			Callback = function(val)
				local closeShadow = ScreenGui:FindFirstChild("CloseUIShadow")
				if closeShadow and closeShadow:FindFirstChild("UIScale") then
					tw({v = closeShadow.UIScale, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {Scale = val / 100}}):Play()
				end
			end
		})	
		SettingsTab:Button({
			Title = "Reset UI",
			Desc = "Reset UI position and scale",
			Callback = function()
				if Tabs.SetCrumbOrientation then
					Tabs.SetCrumbOrientation("Top")
				end
				if breadcrumbSliderObj then
					breadcrumbSliderObj:SetValue(100)
				end
				Shadow_1.AnchorPoint = Vector2.new(0.5, 0.5)
				Shadow_1.Position = UDim2.new(0.5, 0, 0.5, 0)
			end
		})

		return Tabs
end

return Library
