------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Krik'thir the Gatewatcher"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local frenzyannounced = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Krik'thir",

	curse = "Curse of Fatigue",
	curse_desc = "Warn when someone has Curse of Fatigue.",
	curse_message = "Curse of Fatigue - %s",

	frenzy = "Frenzy",
	frenzy_desc = "Warnings when Krik'thir goes into a frenzy.",
	frenzy_message = "Krik'thir is frenzied",
	frenzysoon_message = "Frenzy Soon",
} end)

L:RegisterTranslations("koKR", function() return {
	curse = "피로의 저주",
	curse_desc = "피로의 저주에 걸린 플레이어를 알립니다.",
	curse_message = "피로의 저주 - %s",

	frenzy = "광기",
	frenzy_desc = "크릭시르의 광기에 대해 알립니다.",
	frenzy_message = "크릭시르 광기!",
	frenzysoon_message = "잠시 후 광기",
} end)

L:RegisterTranslations("deDE", function() return {
	curse = "Fluch der Ermüdung",
	curse_desc = "Warnt wenn jemand den Fluch der Ermüdung hat.",
	curse_message = "Fluch der Ermüdung - %s",

	frenzy = "Raserei",
	frenzy_desc = "Warnt wenn Krik'thir Raserei bekommt.",
	frenzy_message = "Krik'thir bekommt Raserei",
	frenzysoon_message = "Raserei Bald",
} end)

L:RegisterTranslations("frFR", function() return {
	curse = "Malédiction de fatigue",
	curse_desc = "Prévient quand un joueur subit les effets de la Malédiction de fatigue.",
	curse_message = "Malédiction de fatigue - %s",

	frenzy = "Frénésie",
	frenzy_desc = "Prévient quand Krik'thir entre en frénésie.",
	frenzy_message = "Krik'thir est en frénésie",
	frenzysoon_message = "Frénésie imminente",
} end)

L:RegisterTranslations("zhCN", function() return {
} end)

L:RegisterTranslations("zhTW", function() return {
} end)

L:RegisterTranslations("esES", function() return {
} end)

L:RegisterTranslations("ruRU", function() return {
	curse = "Проклятие усталости",
	curse_desc = "Предупреждать, когда на кого-нибудь накладывается проклятие усталости.",
	curse_message = "Проклятие усталости - %s",

	frenzy = "Бешенство",
	frenzy_desc = "Предупреждать о бешенстве Krik'thi.",
	frenzy_message = "Krik'thir взбесился",
	frenzysoon_message = "Скоро бешенство",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.partycontent = true
mod.otherMenu = "Dragonblight"
mod.zonename = BZ["Azjol-Nerub"]
mod.enabletrigger = boss
mod.guid = 28684
mod.toggleoptions = {"curse", "frenzy", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("UNIT_HEALTH")
	self:AddCombatListener("SPELL_AURA_APPLIED", "Curse", 52592)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Frenzy", 28747)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	frenzyannounced = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Curse(player, spellId)
	if self.db.profile.curse then
		self:IfMessage(L["curse_message"]:format(player), "Attention", spellId)
	end
end

function mod:Frenzy(_, spellId)
	if self.db.profile.frenzy then
		self:IfMessage(L["frenzy_message"], "Important", spellId)
	end
end

function mod:UNIT_HEALTH(arg1)
	if not self.db.profile.frenzy then return end
	if UnitName(arg1) == boss then
		local health = UnitHealth(arg1)
		if health > 10 and health <= 15 and not frenzyannounced then
			frenzyannounced = true
			self:IfMessage(L["frenzysoon_message"], "Important", 28747)
		elseif health > 15 and frenzyannounced then
			frenzyannounced = nil
		end
	end
end
