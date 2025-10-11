-- ###########################################################################
-- LFM-Manager (Classic Era)
-- Tabs, Auto Group Sort (rule-based), Whisper Log (persist),
-- Whisper Rules (only when Auto Reply+Invite is enabled),
-- History Context Menu (at cursor), Excluded hard-ignore,
-- Compact Raid Settings layout
-- Sort Rules++ (>=, avoid/require/wants/prefer, Global), Persistent Roles
-- ###########################################################################

print("|cffa0ff00LFM-Manager: loading...|r")

local MyRaidAddon = LibStub("AceAddon-3.0"):NewAddon(
  "MyRaidAddon", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0"
)
local AceGUI   = LibStub("AceGUI-3.0")
local AceDB    = LibStub("AceDB-3.0")

-- defensive stub
function MyRaidAddon:UpdateRoleManagementPage() end

-- ==============================
-- Daten & Defaults
-- ==============================
local raidConfig = {
  RFC         = { RaidName="Ragefire Chasm",             RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=13, minIlvl=15 },
  WC          = { RaidName="Wailing Caverns",             RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=17, minIlvl=15 },
  DEADMINES   = { RaidName="The Deadmines",               RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=17, minIlvl=15 },
  SFK         = { RaidName="Shadowfang Keep",             RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=22, minIlvl=20 },
  BFD         = { RaidName="Blackfathom Deeps",           RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=24, minIlvl=20 },
  STOCKADES   = { RaidName="The Stockade",                RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=24, minIlvl=20 },
  GNO         = { RaidName="Gnomeregan",                  RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=29, minIlvl=25 },
  RFD         = { RaidName="Razorfen Downs",              RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=29, minIlvl=25 },
  SM_GRAVEYARD= { RaidName="Scarlet Monastery - Graveyard", RaidSize=5,NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=26, minIlvl=20 },
  SM_LIBRARY  = { RaidName="Scarlet Monastery - Library", RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=29, minIlvl=25 },
  SM_ARMORY   = { RaidName="Scarlet Monastery - Armory",  RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=32, minIlvl=25 },
  SM_CATHEDRAL= { RaidName="Scarlet Monastery - Cathedral", RaidSize=5,NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=35, minIlvl=30 },
  RFD2        = { RaidName="Razorfen Kraul",              RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=37, minIlvl=30 },
  ULDAMAN     = { RaidName="Uldaman",                     RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=41, minIlvl=35 },
  ZF          = { RaidName="Zul'Farrak",                  RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=44, minIlvl=40 },
  MARAUDON    = { RaidName="Maraudon",                    RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=46, minIlvl=40 },
  ST          = { RaidName="The Temple of Atal'Hakkar",   RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=50, minIlvl=45 },
  BRD         = { RaidName="Blackrock Depths",            RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=52, minIlvl=45 },
  LBRS        = { RaidName="Lower Blackrock Spire",       RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=55, minIlvl=50 },
  UBRS        = { RaidName="Upper Blackrock Spire",       RaidSize=10, NeedTanks=2, NeedHealers=2, NeedDPS=6, minLevel=55, minIlvl=50 },
  DM_EAST     = { RaidName="Dire Maul East",              RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=55, minIlvl=50 },
  DM_WEST     = { RaidName="Dire Maul West",              RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=58, minIlvl=50 },
  DM_NORTH    = { RaidName="Dire Maul North",             RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=58, minIlvl=55 },
  STRATH      = { RaidName="Stratholme",                  RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=58, minIlvl=55 },
  SCHOLO      = { RaidName="Scholomance",                 RaidSize=5,  NeedTanks=1, NeedHealers=1, NeedDPS=3, minLevel=58, minIlvl=55 },
  -- Raids
  ZG          = { RaidName="Zul'Gurub",                   RaidSize=20, NeedTanks=2, NeedHealers=5, NeedDPS=13, minLevel=55, minIlvl=50 },
  AQ20        = { RaidName="Ruins of Ahn'Qiraj",          RaidSize=20, NeedTanks=2, NeedHealers=5, NeedDPS=13, minLevel=55, minIlvl=55 },
  MC          = { RaidName="Molten Core",                 RaidSize=40, NeedTanks=4, NeedHealers=10, NeedDPS=26, minLevel=55, minIlvl=55 },
  ONY         = { RaidName="Onyxia's Lair",               RaidSize=40, NeedTanks=2, NeedHealers=5, NeedDPS=13, minLevel=58, minIlvl=55 },
  BWL         = { RaidName="Blackwing Lair",              RaidSize=40, NeedTanks=4, NeedHealers=10, NeedDPS=26, minLevel=58, minIlvl=60 },
  AQ40        = { RaidName="Temple of Ahn'Qiraj",         RaidSize=40, NeedTanks=4, NeedHealers=10, NeedDPS=26, minLevel=58, minIlvl=60 },
  NAXX        = { RaidName="Naxxramas",                   RaidSize=40, NeedTanks=4, NeedHealers=10, NeedDPS=26, minLevel=58, minIlvl=65 },
  CUSTOM1     = { RaidName="",                            RaidSize=10, NeedTanks=2, NeedHealers=2, NeedDPS=6, minLevel=58, minIlvl=65 },
}

local function deepCopy(tbl)
  if type(tbl)~="table" then return tbl end
  local t = {}; for k,v in pairs(tbl) do t[k] = deepCopy(v) end; return t
end
local raidConfigDefaults = deepCopy(raidConfig)

-- Persisted flags & state
local selectedRaid           = "SCHOLO"
local autoReplyInviteEnabled = false
local selectedChannels       = {}  -- map[str]=true
local lfmAutoPostTimer       = nil
local uiStatusTickerTimer    = nil

-- Rollen-/Pending-Listen (runtime)
local activeTank, activeHealer, activeRange, activeMelee = {}, {}, {}, {}
local playersWithoutRole, conversationList               = {}, {}
local playerItemLevels, playerLevels                     = {}, {}

-- Persistente Rollen (DB-gespiegelt)
-- db.profile.activeRoles = { tank={}, healer={}, range={}, melee={} }
-- db.profile.roleAssignments[name]=role
local function PersistActiveRoles()
  local db = MyRaidAddon.db and MyRaidAddon.db.profile or nil
  if not db then return end
  db.activeRoles = db.activeRoles or { tank={}, healer={}, range={}, melee={} }
  db.roleAssignments = db.roleAssignments or {}
  -- reset arrays
  db.activeRoles.tank, db.activeRoles.healer = {}, {}
  db.activeRoles.range, db.activeRoles.melee = {}, {}
  for _,n in ipairs(activeTank)   do table.insert(db.activeRoles.tank, n);   db.roleAssignments[n]="tank"   end
  for _,n in ipairs(activeHealer) do table.insert(db.activeRoles.healer, n); db.roleAssignments[n]="healer" end
  for _,n in ipairs(activeRange)  do table.insert(db.activeRoles.range, n);  db.roleAssignments[n]="range"  end
  for _,n in ipairs(activeMelee)  do table.insert(db.activeRoles.melee, n);  db.roleAssignments[n]="melee"  end
end

-- Compact role assignment window (reliable buttons), opens at cursor and toggles on repeated clicks
function MyRaidAddon:OpenAssignWindow(name, anchorFrame)
  if self._assignWin and self._assignWin.frame and self._assignWin.frame:IsShown() then
    if self._assignAnchor == anchorFrame then
      self._assignWin.frame:Hide(); self._assignWin = nil; self._assignAnchor = nil; return
    else
      self._assignWin.frame:Hide(); self._assignWin = nil; self._assignAnchor = nil
    end
  end
  local frame = AceGUI:Create("Window")
  frame:SetTitle("Assign Role: "..(name or ""))
  frame:SetLayout("List")
  frame:SetWidth(240)
  frame:SetHeight(220)
  frame:SetCallback("OnClose", function(w)
    if MyRaidAddon and MyRaidAddon._assignWin == w then MyRaidAddon._assignWin = nil; MyRaidAddon._assignAnchor = nil end
    AceGUI:Release(w)
  end)
  local roles = {
    { key="tank",  label="Tank" },
    { key="healer",label="Healer" },
    { key="range", label="Range DPS" },
    { key="melee", label="Melee DPS" },
  }
  for _,r in ipairs(roles) do
    local b = AceGUI:Create("Button"); b:SetText(r.label); b:SetWidth(200)
    b:SetCallback("OnClick", function()
      MyRaidAddon:AssignRoleAndPersist(name, r.key)
      frame:Hide()
      if MyRaidAddon and MyRaidAddon.UpdateRoleManagementPage then MyRaidAddon:UpdateRoleManagementPage() end
      if RebuildActiveTab then RebuildActiveTab() end
    end)
    frame:AddChild(b)
  end
  local rem = AceGUI:Create("Button"); rem:SetText("Remove from Roles"); rem:SetWidth(200)
  rem:SetCallback("OnClick", function()
    removeFromAllActiveLists(name)
    MyRaidAddon:AddToInvitedPlayers(name, nil, "invited")
    PersistActiveRoles()
    updatePlayersWithoutRole(); updatePlayerStatuses()
    MyRaidAddon:UpdateRoleManagementPage(); frame:Hide(); RebuildActiveTab()
  end)
  frame:AddChild(rem)
  if openAtCursor then openAtCursor(frame) end
  self._assignWin = frame; self._assignAnchor = anchorFrame
end

local function LoadActiveRolesFromDB()
  local db = MyRaidAddon.db and MyRaidAddon.db.profile or nil
  if not db then return end
  local ar = db.activeRoles
  if not ar then return end
  local function copyList(dst, src)
    table.wipe(dst)
    for _,n in ipairs(src or {}) do table.insert(dst, n) end
  end
  copyList(activeTank,   ar.tank)
  copyList(activeHealer, ar.healer)
  copyList(activeRange,  ar.range)
  copyList(activeMelee,  ar.melee)
end

-- Whisper-Historie
local WHISPER_MAX_KEEP = 200
local WHISPER_SHOW     = 20

-- Whisper Rules — Default Text (supports "||" variants)
local DEFAULT_AI_TEXT = [[
# =========================================
# LFM-Manager – Whisper Rules Template (English)
# =========================================
# Notes:
# - Matching is case-insensitive "contains".
# - match=any: any keyword is enough; match=all: all required.
# - stop=true: stop after this rule matches.
# - role: tank | healer | range | melee
# - invite=true: auto-invite on match (your addon still checks capacity).
#
# ---------- 1) Explicit role keywords ----------
rule:
keywords=tank, prot, protection, bear, druid tank, warrior tank, main tank, off tank, offtank
match=any
reply=Your shield gleams with courage — you’re in as Tank!||A steadfast protector joins us! Registered you as Tank.||Excellent — we always need a wall of steel. You’re in as Tank.||Got it, brave Tank, prepare to hold the line!
role=tank
invite=true
stop=true

rule:
keywords=heal, healer, holy, disc, discipline, resto, restoration
match=any
reply=The spirits favor you — Healer spot reserved.||Light bless your hands, Healer — welcome aboard!||Perfect, your healing touch shall keep us alive.||Registered you as Healer, may your mana never fade!
role=healer
invite=true
stop=true

rule:
keywords=melee, mdps, rogue dps, warrior dps, fury, arms, cat, feral, enh, enhance, enhancer, enhancement
match=any
reply=Your blades are sharp and your aim true — you’re in as Melee DPS.||Another warrior for the front line! Registered as Melee.||The clash of steel awaits — Melee DPS confirmed.||Excellent, you’ll strike from up close. Melee DPS locked in.
role=melee
invite=true
stop=true

rule:
keywords=range, rdps, caster, caster dps, mage dps, lock dps, warlock dps, hunter dps, shadow, owl, balance, ele, elemental
match=any
reply=The winds carry your spells far — Ranged DPS it is!||A keen eye or powerful spellcaster joins us — marked as Ranged.||Perfect, we needed more firepower from afar.||Ranged DPS confirmed — stay behind the line and unleash!
role=range
invite=true
stop=true

# ---------- 2) Class ? role (auto-assign) ----------
rule:
keywords=mage
match=any
reply=Ah, a master of arcane arts! Registered you as Ranged DPS.||The air crackles with your power — Ranged DPS confirmed.||Mage spotted — stand back and bring the fire!||Your spells will scorch our foes. Added as Ranged.
role=range
invite=true
stop=true

rule:
keywords=warlock, lock
match=any
reply=A Warlock? Excellent — we’ll need your curses. Ranged DPS confirmed.||Demons at your command — registered you as Ranged DPS.||The fel energies surge — Ranged DPS it is.||Warlock power welcomed — you’re in as Ranged.
role=range
invite=true
stop=true

rule:
keywords=hunter, jäger
match=any
reply=A keen-eyed Hunter joins the hunt — Ranged DPS confirmed.||Your arrows shall fly true. Registered as Ranged DPS.||The beasts follow your lead — Ranged spot reserved.||Welcome, tracker — Ranged DPS ready.
role=range
invite=true
stop=true

rule:
keywords=shadow
match=any
reply=Darkness stirs — Shadow Priest confirmed as Ranged DPS.||Whispers from the void — you’re in as Ranged DPS.||Perfect, our shadows just grew stronger.||Registered you as Ranged — the void calls.
role=range
invite=true
stop=true

rule:
keywords=owl, balance
match=any
reply=Feathers and moonlight — Balance Druid as Ranged DPS!||Moonkin joins! Ranged DPS confirmed.||The stars guide your aim — Ranged spot taken.||Perfect, wise owl, you’re our Ranged caster.
role=range
invite=true
stop=true

rule:
keywords=ele, elemental
match=any
reply=The elements roar — Elemental Shaman registered as Ranged DPS.||Lightning crackles — you’re in as Ranged.||Stormcaller joins the ranks! Ranged DPS confirmed.||Perfect, Elemental Shaman added as Ranged.
role=range
invite=true
stop=true

rule:
keywords=rogue, rog
match=any
reply=Silent steps, deadly strikes — Rogue confirmed as Melee.||A shadow in the fray — Melee DPS it is.||Your daggers thirst for battle — registered as Melee.||Rogue spotted — ready for close combat!
role=melee
invite=true
stop=true

# ---------- 3) Hybrids need clarification ----------
rule:
keywords=warrior
exclude=tank, prot, protection, fury, arms, dps
match=any
reply=Warrior, eh? Will you stand as Tank or charge as Melee DPS? (reply "tank" or "melee")||Mighty warrior! Tanking or slashing? (tank/melee)||Will you bear a shield or wield twin blades? (tank/melee)||Clarify your role, warrior: "tank" or "melee"?
stop=true

rule:
keywords=druid, drood
exclude=tank, bear, cat, feral, owl, balance, resto, restoration, heal, healer
match=any
reply=Druid of many forms! Will you Tank, Heal, fight as Feral (melee) or cast as Balance (range)?||Your nature’s gift is vast — which path today? Tank, Healer, Melee, or Range?||Moon, Claw, or Root — what’s your calling? (tank/healer/melee/range)||Please specify your role: tank, healer, melee, or range.
stop=true

rule:
keywords=shaman, sham
exclude=ele, elemental, enh, enhance, enhancer, enhancement, resto, restoration, heal, healer
match=any
reply=Shaman! Will you heal with waves, strike with storm, or cast lightning from afar? (healer/melee/range)||Totems at the ready — which path calls you? (healer/melee/range)||Elemental, Enhancement or Restoration? (range/melee/healer)||What’s your focus, Shaman? Healer, Melee, or Ranged?
stop=true

rule:
keywords=priest
exclude=shadow, heal, healer, holy, disc, discipline
match=any
reply=Priest of Light or Shadow? Please specify: "healer" or "range (shadow)".||Will you mend wounds or wield the void? (healer/range)||Holy or Shadow today? (healer/range)||Priest detected — healer or ranged DPS?
stop=true

# ---------- 4) Common shorthand ----------
rule:
keywords=fury, arms
match=any
reply=Ah, a Warrior DPS — blades at the ready. Melee role confirmed.||Strong arms for the frontline — Melee DPS it is.||Perfect, fury in your heart — Melee DPS locked.||Warrior DPS registered as Melee.
role=melee
invite=true
stop=true

rule:
keywords=bear
match=any
reply=The bear awakens! Registered you as Tank.||A sturdy bear joins the fray — Tank role confirmed.||Fur and fury — Druid Tank assigned.||Nature’s protector at our side — Tank role it is.
role=tank
invite=true
stop=true

rule:
keywords=cat, feral
match=any
reply=The claws of nature! Registered you as Melee DPS.||Feral Druid detected — Melee DPS confirmed.||A wild cat stalks the enemy — Melee spot taken.||Your claws will serve us well — Melee DPS added.
role=melee
invite=true
stop=true

rule:
keywords=resto, restoration
match=any
reply=The waters flow — Restoration Healer confirmed.||Healing tides rise — Healer registered.||Perfect, your totems will mend us — Healer role.||Restoration path chosen — Healer spot locked.
role=healer
invite=true
stop=true

rule:
keywords=enh, enhance, enhancer, enhancement
match=any
reply=Storms at your fists — Enhancement Shaman as Melee DPS.||Totems ready for battle — Melee DPS confirmed.||Perfect, Enhancer joins melee line.||Lightning strikes! Registered as Melee.
role=melee
invite=true
stop=true

# ---------- 5) Off-topic / trade filter ----------
rule:
keywords=boost, gdkp, carry, wts, wtb, sell gold, buy gold, token, powerlevel
match=any
reply=Appreciate the offer, but this is a raid, not a bazaar. Safe travels!||Not today, trader. The raid calls, not the market.||No trades or boosts, friend. Adventure awaits elsewhere!||We’re here for glory, not gold. Move along!
offtopic=true
stop=true

# ---------- 6) Generic fallback roles ----------
rule:
keywords=tank
match=any
reply=Copy that, brave Tank!||A true wall of steel — Tank confirmed.||Registered you as Tank — lead the charge!||Excellent, you’ll hold the line as Tank.
role=tank
invite=true
stop=true

rule:
keywords=heal, healer
match=any
reply=Healer incoming — may your mana never run dry.||Light guide you — Healer spot reserved.||Perfect, healing hands are always welcome.||Healer confirmed — we’re in good hands now.
role=healer
invite=true
stop=true

rule:
keywords=melee
match=any
reply=Melee DPS confirmed — time to spill some blood up close.||Frontline fighter ready — Melee locked.||Perfect, sharpen those blades.||Registered you as Melee DPS.
role=melee
invite=true
stop=true

rule:
keywords=range, ranged, caster
match=any
reply=Ranged DPS confirmed — unleash from afar!||Perfect, we needed more spellfire.||Registered you as Ranged.||Arrows and magic — Ranged DPS added.
role=range
invite=true
stop=true

# ---------- 7) Last resort ----------
rule:
match=any
reply=Greetings, adventurer! What’s your role: "tank", "healer", "range", or "melee"?||Welcome! What role will you take in this battle? (tank/healer/range/melee)||Hail, hero! We need to know your path — tank, healer, range, or melee?||State your intent, traveler: tank, healer, ranged, or melee?
stop=true
]]

-- ==============================
-- NEW: Sort Rules (text-driven)
-- ==============================
local DEFAULT_SORT_TEXT = [[
# ==================================
# SORT RULES+ MANUAL / REFERENCE
# ==================================
# Syntax: key=value pairs, one group per block
# Empty lines and "#" comments are ignored.
#
# ---------------------------------------------
# GLOBAL RULES
# ---------------------------------------------
# Use lines starting with "Global=" for rules that affect the entire raid.
#
# Examples:
#   Global=require Shaman>=4          ? ensures at least 4 shamans in the raid
#   Global=avoid Healer>10            ? limits healers to a maximum of 10
#   Global=prefer Druid,Hunter        ? prioritizes these classes when sorting
#
# ---------------------------------------------
# GROUP RULES
# ---------------------------------------------
# Each group block begins with "Grp=" and can contain:
#
#   wants=Tag
#       Defines the primary focus of this group (Tank, Melee, Range, Healer)
#       Controls what kind of players will fill the remaining slots.
#       Examples:
#         wants=Melee   ? fills with melee DPS
#         wants=Range   ? fills with ranged DPS
#         wants=Healer  ? fills with healers
#
#   require X[,Y]
#       Enforces minimum quotas or mandatory roles/classes.
#       Supported operators: =, >=, <=, >, <, !=
#       Examples:
#         require Tank=1, Shaman>=1
#         require Healer>=2
#
#   avoid X[,Y]
#       Restricts or discourages certain classes/roles.
#       Can also cap their number.
#       Examples:
#         avoid Healer>1
#         avoid Range>0
#
#   prefer=A,B,C
#       Sets priority when multiple candidates fit equally.
#       Examples:
#         prefer=Warrior,Rogue,Druid
#         prefer=Priest,Shaman,Druid,Mage
#
#   wants + require + avoid + prefer
#       are sufficient — "definition=" is no longer needed.
#       The algorithm works in this order:
#         1?? fill required slots (require)
#         2?? apply preferred classes (prefer)
#         3?? respect avoid rules
#         4?? fill remaining spots with the tag from "wants"
#
# ---------------------------------------------
# OPERATOR REFERENCE
# ---------------------------------------------
#   =   exactly equal
#   >=  at least
#   <=  at most
#   >   more than
#   <   less than
#   !=  not equal
#
# ---------------------------------------------
# COMMON USE CASES
# ---------------------------------------------
#   require Shaman>=1           ? ensures Windfury/Mana Totem in group
#   prefer Druid,Hunter         ? favors Feral (Leader of the Pack) / Tranq Hunter
#   avoid Healer>1              ? avoids healers in melee cores
#   wants=Range                 ? auto-fills with casters/ranged DPS
#
# ---------------------------------------------
# NOTES
# ---------------------------------------------
# - "wants" replaces the old "GrpType" field.
# - "definition=" is deprecated in Sort Rules+.
# - Global rules apply across all groups.
# - Ambiguous hybrids (e.g., Druids, Shamans) are sorted using "prefer".
# - If not all slots fill, remaining players will be filled according to "wants".
#
# ==================================
# Example Horde configuration below
# ==================================


# ---------- Global tuning ----------
Global=require Shaman>=4          # enough Windfury/Mana Totems in raid
Global=prefer Druid,Hunter        # prefer Feral (LotP) / Tranq Hunter
Global=avoid Healer>10            # limit healers overall


# ---------- G1: Main Tank + Melee Windfury core ----------
Grp=1
wants=Melee
require Tank=1, Shaman>=1
avoid=Healer>1, Range>1
prefer=Warrior,Rogue,Druid,Hunter


# ---------- G2: Second Tank + Melee Windfury core ----------
Grp=2
wants=Melee
require Tank=1, Shaman>=1
avoid=Healer>1, Range>1
prefer=Warrior,Rogue,Druid,Hunter


# ---------- G3: Melee core (no healers) ----------
Grp=3
wants=Melee
require Shaman>=1
avoid=Healer>=1, Range>0
prefer=Warrior,Rogue,Druid,Shaman


# ---------- G4: Melee core (no healers) ----------
Grp=4
wants=Melee
require Shaman>=1
avoid=Healer>=1, Range>0
prefer=Warrior,Rogue,Druid,Shaman


# ---------- G5: Caster core (with sustain) ----------
Grp=5
wants=Range
require Shaman>=1, Healer>=1
avoid=Melee>0
prefer=Warlock,Mage,Priest,Druid


# ---------- G6: Caster core (with sustain) ----------
Grp=6
wants=Range
require Shaman>=1, Healer>=1
avoid=Melee>0
prefer=Mage,Warlock,Priest,Druid


# ---------- G7: Healer pool (fill with casters) ----------
Grp=7
wants=Healer
require Healer>=2
avoid=Melee>0
prefer=Priest,Shaman,Druid,Warlock,Mage


# ---------- G8: Healer pool (fill with casters) ----------
Grp=8
wants=Healer
require Healer>=2
avoid=Melee>0
prefer=Priest,Shaman,Druid,Warlock,Mage
]]

-- UI refs
local mainFrame
local tabGroup

-- Channels
local channelOptions = {
  "YELL","GUILD","SAY","RAID","PARTY",
  "CHANNEL 1","CHANNEL 2","CHANNEL 3","CHANNEL 4","CHANNEL 5","CHANNEL 6","CHANNEL 7","CHANNEL 8",
}

-- ==============================
-- Util
-- ==============================
local function trim(s) return (s and s:match("^%s*(.-)%s*$")) or s end
local function splitCSV(s)
  local t = {}; s = s or ""
  for part in string.gmatch(s, "([^,]+)") do
    local p = trim(part); if p ~= "" then table.insert(t, p) end
  end
  return t
end
local function listContains(list, val) for i=1,#list do if list[i]==val then return true end end; return false end
local function listRemove(list, val) for i=#list,1,-1 do if list[i]==val then table.remove(list,i) end end end
local function listAddUnique(list, val) if val and not listContains(list, val) then table.insert(list, val) end end

local function getFullPlayerName(name)
  if not name then return nil end
  if not string.find(name, "-") then name = name .. "-" .. GetRealmName() end
  return name
end

-- Helper: run a /who query for a player or query string
local function doWhoQuery(query)
  if not query or query=="" then return end
  if SendWho then
    SendWho(query)
  elseif C_FriendList and C_FriendList.SendWho then
    C_FriendList.SendWho(query)
  elseif C_FriendsList and C_FriendsList.SendWho then
    C_FriendsList.SendWho(query)
  else
    if ChatFrame_OpenChat then ChatFrame_OpenChat("/who "..query) end
  end
end

local function currentRaidCfg() return raidConfig[selectedRaid] end

local function inAnyActiveList(name)
  return listContains(activeTank,name) or listContains(activeHealer,name)
      or listContains(activeRange,name) or listContains(activeMelee,name)
end

-- Gruppeneinheiten
local function IterateGroup()
  local idx, max = 0, GetNumGroupMembers()
  local isRaid = IsInRaid()
  return function()
    idx = idx + 1
    if isRaid then
      if idx <= max then return "raid"..idx end
    else
      if idx <= 4 then return "party"..idx
      elseif idx == 5 then return "player" end
    end
  end
end

local function isPlayerInGroup(name)
  if not name then return false end
  for unit in IterateGroup() do
    local nm = GetUnitName(unit, true)
    if nm and getFullPlayerName(nm) == name then return true end
  end
  return false
end

local function removeFromAllActiveLists(name)
  listRemove(activeTank, name)
  listRemove(activeHealer, name)
  listRemove(activeRange, name)
  listRemove(activeMelee, name)
  listRemove(conversationList, name)
  listRemove(playersWithoutRole, name)
  -- auch persistent entfernen
  local db = MyRaidAddon.db and MyRaidAddon.db.profile or nil
  if db and db.roleAssignments then db.roleAssignments[name]=nil end
  PersistActiveRoles()
end

-- Entfernt einen Spieler aus den aktiven Rollen, behält aber die zuletzt gewählte Rolle in roleAssignments bei.
local function removeFromActiveListsKeepAssignment(name)
  listRemove(activeTank, name)
  listRemove(activeHealer, name)
  listRemove(activeRange, name)
  listRemove(activeMelee, name)
  listRemove(conversationList, name)
  listRemove(playersWithoutRole, name)
  -- Wichtig: roleAssignments NICHT löschen – so kann die Rolle beim Rejoin wiederhergestellt werden.
  PersistActiveRoles()
end

local function canAddToRole(role)
  local cfg = currentRaidCfg(); if not cfg then return false end
  local dps = #activeMelee + #activeRange
  local total = #activeTank + #activeHealer + dps
  if role=="tank"   and #activeTank   >= cfg.NeedTanks   then return false end
  if role=="healer" and #activeHealer >= cfg.NeedHealers then return false end
  if (role=="range" or role=="melee") and dps >= cfg.NeedDPS then return false end
  if total >= cfg.RaidSize then return false end
  return true
end

-- Klassenfarbe
local function getClassColorCode(name)
  local r,g,b = 1,1,1
  for unit in IterateGroup() do
    local nm = GetUnitName(unit, true)
    if nm and getFullPlayerName(nm) == name then
      local _, class = UnitClass(unit)
      if class and RAID_CLASS_COLORS[class] then
        local c = RAID_CLASS_COLORS[class]; r,g,b = c.r,c.g,c.b
      end
      break
    end
  end
  local rec = MyRaidAddon.db and MyRaidAddon.db.profile and MyRaidAddon.db.profile.invitedPlayers and MyRaidAddon.db.profile.invitedPlayers[name]
  if (r==1 and g==1 and b==1) and rec and rec.class and RAID_CLASS_COLORS[rec.class] then
    local c = RAID_CLASS_COLORS[rec.class]; r,g,b = c.r,c.g,c.b
  end
  return string.format("%02x%02x%02x%02x", 255, r*255, g*255, b*255)
end

local function getClassOf(name)
  for unit in IterateGroup() do
    local nm = GetUnitName(unit, true)
    if nm and getFullPlayerName(nm) == name then
      local _, class = UnitClass(unit)
      return class
    end
  end
  local rec = MyRaidAddon.db and MyRaidAddon.db.profile and MyRaidAddon.db.profile.invitedPlayers and MyRaidAddon.db.profile.invitedPlayers[name]
  return rec and rec.class or nil
end

-- ==============================
-- Excluded: zentraler Guard
-- ==============================
local function isExcluded(name)
  local rec = MyRaidAddon.db.profile.invitedPlayers[name]
  return rec and rec.status == "Excluded"
end

local function InviteIfNotExcluded(name)
  if not name then return end
  if isExcluded(name) then
    print("|cffff5555[LFM]|r "..name.." is excluded and will not be invited.")
    return
  end
  -- Auto-Konvertierung: Wenn Party bereits 5 Spieler hat und kein Raid, vor der Einladung zu Raid wechseln
  local num = (GetNumGroupMembers and GetNumGroupMembers()) or 0
  local inRaid = IsInRaid and IsInRaid() or false
  local function isLeader()
    if UnitIsGroupLeader and UnitIsGroupLeader("player") then return true end
    if IsPartyLeader and IsPartyLeader() then return true end
    if IsRaidLeader and IsRaidLeader() then return true end
    if (IsInGroup and not IsInGroup()) or (not GetNumGroupMembers or num==0) then return true end
    return false
  end
  local converted = false
  if not inRaid and num >= 5 and ConvertToRaid and isLeader() then
    ConvertToRaid()
    converted = true
    print("|cff55ff55[LFM]|r Auto-converted to Raid for inviting "..name)
  end
  if converted and C_Timer and C_Timer.After then
    C_Timer.After(0.2, function() InviteUnit(name) end)
  else
    InviteUnit(name)
  end
end

-- ==============================
-- Inspect Queue (throttled)
-- ==============================
local inspectQueue, isInspecting = {}, false
local function queueInspect(unit)
  if not unit or not UnitIsConnected(unit) then return end
  table.insert(inspectQueue, unit)
end
local function pumpInspect()
  if isInspecting or #inspectQueue==0 then return end
  local unit = table.remove(inspectQueue,1)
  if UnitIsConnected(unit) and CheckInteractDistance(unit,1) then
    isInspecting = true
    NotifyInspect(unit)
  end
end

-- ==============================
-- Whisper Store
-- ==============================
local function ensureWhisperStore()
  MyRaidAddon.db.profile.whisperHistory = MyRaidAddon.db.profile.whisperHistory or {}
  return MyRaidAddon.db.profile.whisperHistory
end
local function logWhisper(name, text, dir)
  local store = ensureWhisperStore()
  if not name or not text or text=="" then return end
  local key = getFullPlayerName(name)
  store[key] = store[key] or {}
  local arr = store[key]
  table.insert(arr, {dir=dir, text=text, time=GetServerTime()})
  if #arr > WHISPER_MAX_KEEP then
    while #arr > WHISPER_MAX_KEEP do table.remove(arr,1) end
  end
end

-- ==============================
-- Pending/Status
-- ==============================
local function updatePlayersWithoutRole()
  playersWithoutRole = {}
  for unit in IterateGroup() do
    local nm = GetUnitName(unit, true)
    if nm then
      nm = getFullPlayerName(nm)
      if not inAnyActiveList(nm) then listAddUnique(playersWithoutRole, nm) end
    end
  end
  for _, nm in ipairs(conversationList) do
    if nm and not inAnyActiveList(nm) then listAddUnique(playersWithoutRole, nm) end
  end
  -- Auch Spieler berücksichtigen, die (noch) nicht in der Gruppe sind
  local invited = MyRaidAddon.db.profile.invitedPlayers
  for nm, data in pairs(invited) do
    if data and data.status ~= "Excluded" then
      if not inAnyActiveList(nm) then listAddUnique(playersWithoutRole, nm) end
    end
  end
  -- Und zuletzt gespeicherte Rollen (roleAssignments) berücksichtigen, falls Spieler nicht in invitedPlayers stehen
  local ra = MyRaidAddon.db.profile.roleAssignments or {}
  for nm, _ in pairs(ra) do
    local rec = invited[nm]
    if (not rec or rec.status ~= "Excluded") and not inAnyActiveList(nm) then
      listAddUnique(playersWithoutRole, nm)
    end
  end
  local me = getFullPlayerName(GetUnitName("player", true))
  if me and not inAnyActiveList(me) then listAddUnique(playersWithoutRole, me) end
end

local function updatePlayerStatuses()
  local unitByName = {}
  for unit in IterateGroup() do
    local nm = GetUnitName(unit, true)
    if nm then unitByName[getFullPlayerName(nm)] = unit end
  end
  for nm, data in pairs(MyRaidAddon.db.profile.invitedPlayers) do
    local unit = unitByName[nm]
    if unit then
      if inAnyActiveList(nm) then
        data.status = UnitIsConnected(unit) and "active" or "offline"
      else
        data.status = UnitIsConnected(unit) and "no Role selected" or "offline"
      end
    else
      if data.status ~= "Excluded" and data.status ~= "request" then
        data.status = "invited"
      end
    end
  end
end

-- ==============================
-- Fallback Rollen-Erkennung
-- ==============================
local function extractRole(msg)
  local m = string.lower(msg or "")
  if m:find("tank") then return "tank"
  elseif m:find("heal") then return "healer"
  elseif m:find("melee") or m:find("rog") or m:find("rogue") then return "melee"
  elseif m:find("range") or m:find("mage") or m:find("lock") or m:find("shadow") or m:find("hunt") or m:find("ele") or m:find("owl") then
    return "range"
  end
  return nil
end

-- ==============================
-- invitedPlayers DB + Persist Roles
-- ==============================
function MyRaidAddon:AddToInvitedPlayers(playerName, role, status)
  if not self.db.profile.invitedPlayers[playerName] then
    self.db.profile.invitedPlayers[playerName] = {}
  end
  local entry = self.db.profile.invitedPlayers[playerName]
  if not entry.class then
    for unit in IterateGroup() do
      local nm = GetUnitName(unit, true)
      if nm and getFullPlayerName(nm) == playerName then
        local _, class = UnitClass(unit)
        entry.class = class
        break
      end
    end
  end
  if role   ~= nil then entry.lastRole = role end
  if status ~= nil then entry.status   = status end
  entry.ilvl = playerItemLevels[playerName] or entry.ilvl or 0
  -- persist role assignment map
  self.db.profile.roleAssignments = self.db.profile.roleAssignments or {}
  if role then self.db.profile.roleAssignments[playerName] = role end
end

local function PersistAddToActive(roleKey, name)
  removeFromAllActiveLists(name)
  if roleKey=="tank"   then table.insert(activeTank,  name)
  elseif roleKey=="healer" then table.insert(activeHealer, name)
  elseif roleKey=="range"  then table.insert(activeRange,  name)
  elseif roleKey=="melee"  then table.insert(activeMelee,  name) end
  PersistActiveRoles()
end

-- ==============================
-- Whisper Rules: Parser & Matcher
-- ==============================
local function parseReplyVariants(reply)
  if not reply or reply=="" then return nil end
  local parts = {}
  for piece in tostring(reply):gmatch("([^|][^|]*)%s*||?") do
    table.insert(parts, trim(piece))
  end
  if #parts==0 then table.insert(parts, trim(reply)) end
  return parts
end

local function parseAIRules(text)
  local rules, cur = {}, nil
  local function pushRule()
    if cur then
      cur.keywordsLower = {}; for _,k in ipairs(cur.keywords or {}) do table.insert(cur.keywordsLower, string.lower(k)) end
      cur.excludeLower  = {}; for _,k in ipairs(cur.exclude  or {}) do table.insert(cur.excludeLower,  string.lower(k)) end
      cur.match = (cur.match=="all") and "all" or "any"
      if cur.reply then cur.replyVariants = parseReplyVariants(cur.reply) end
      table.insert(rules, cur); cur = nil
    end
  end
  for line in (text.."\n"):gmatch("(.-)\n") do
    local ln = trim(line or "")
    if ln == "" then pushRule()
    elseif ln:sub(1,1) == "#" then
    elseif ln:lower() == "rule:" then
      pushRule()
      cur = { keywords={}, exclude={}, match="any", invite=false, excludePlayer=false, offtopic=false, stop=false }
    else
      cur = cur or { keywords={}, exclude={}, match="any", invite=false, excludePlayer=false, offtopic=false, stop=false }
      local key, val = ln:match("^(%w+)%s*=%s*(.+)$")
      if key then
        key = key:lower()
        if key=="keywords" then cur.keywords = splitCSV(val)
        elseif key=="exclude" then cur.exclude = splitCSV(val)
        elseif key=="match" then cur.match = (string.lower(val)=="all") and "all" or "any"
        elseif key=="reply" then cur.reply = val
        elseif key=="role" then
          val = string.lower(val)
          if val=="tank" or val=="healer" or val=="range" or val=="melee" then cur.role = val end
        elseif key=="invite" then cur.invite = string.lower(val)=="true"
        elseif key=="excludeplayer" then cur.excludePlayer = string.lower(val)=="true"
        elseif key=="offtopic" then cur.offtopic = string.lower(val)=="true"
        elseif key=="stop" then cur.stop = string.lower(val)=="true"
        end
      end
    end
  end
  pushRule()
  return rules
end

local function messageHasWord(msgLower, wordLower) return msgLower:find(wordLower, 1, true) ~= nil end

local function matchesRule(rule, msgLower)
  for _,ex in ipairs(rule.excludeLower or {}) do
    if ex ~= "" and messageHasWord(msgLower, ex) then return false end
  end
  local need = #(rule.keywordsLower or {})
  if need == 0 then return true end
  local found = 0
  for _,kw in ipairs(rule.keywordsLower) do
    if kw ~= "" and messageHasWord(msgLower, kw) then
      found = found + 1
      if rule.match == "any" then return true end
    end
  end
  return (rule.match=="all") and (found == need) or false
end

local function pickReply(rule)
  local arr = rule.replyVariants
  if not arr or #arr==0 then return rule.reply end
  local i = math.random(1, #arr)
  return arr[i]
end

local function getParsedRules()
  local text = MyRaidAddon.db.profile.aiRulesText or DEFAULT_AI_TEXT
  local parsed = MyRaidAddon.db.profile.aiRulesParsed
  if not parsed then
    parsed = parseAIRules(text)
    MyRaidAddon.db.profile.aiRulesParsed = parsed
  end
  return parsed
end

local function evaluateAIRules(msg)
  local parsed = getParsedRules()
  local msgLower = string.lower(msg or "")
  for _,rule in ipairs(parsed) do
    if matchesRule(rule, msgLower) then return rule end
  end
  return nil
end

-- ==============================
-- Sort Rules: Parser & Engine (extended)
-- ==============================
-- Buff/Tag Map (vereinfachtes Mapping – erweiterbar)
local TAG_TO_SATISFIERS = {
  Crit5 = { DRUID="Feral" },         -- exemplarisch
  SpellCrit3 = { DRUID="Balance" },  -- exemplarisch
  TranquilShot = { HUNTER=true },
  Windfury = { SHAMAN=true },
}

local function parseSortRules(text)
  local groups, cur = {}, nil
  local global = { raw={}, HealerInMeleeMax=nil, ShamanPerMeleeMin=nil }

  -- helper: add parsed piece into cur.def*
  local function ensureCur()
    if not cur then return end
    cur.def = cur.def or {}
    cur.op = cur.op or { class={}, role={} }          -- {key={op,val}}
    cur.fill = cur.fill or {}                          -- role => "fill"
    cur.avoid = cur.avoid or {}                        -- set[str]=true
    cur.require = cur.require or {}                    -- list of requirements (strings or parsed quotas)
    cur.wants = cur.wants or {}                        -- tags list
    cur.prefer = cur.prefer or {}                      -- ordered list
  end

  local function push()
    if cur and cur.grp then
      -- also parse legacy "definition=" CSV chunks
      local defRaw = cur.definition or ""
      for chunk in defRaw:gmatch("([^,]+)") do
        local token = trim(chunk)
        if token ~= "" then
          -- detect keywords inside definition
          if token:lower():find("^avoid%s+") then
            ensureCur(); cur.avoid[ trim(token:sub(7)) ] = true
          elseif token:lower():find("^require%s+") then
            ensureCur(); table.insert(cur.require, trim(token:sub(9)))
          elseif token:lower():find("^wants%s*=") then
            ensureCur(); local v = trim(token:match("^wants%s*=%s*(.+)$") or "")
            if v~="" then table.insert(cur.wants, v) end
          elseif token:lower():find("^prefer%s*=") then
            ensureCur(); local v = trim(token:match("^prefer%s*=%s*(.+)$") or "")
            if v~="" then cur.prefer = splitCSV(v) end
          else
            -- quotas / fill / role counts / class counts
            local k,op,num = token:match("^([%w_%(%)/]+)%s*([<>!]=?)%s*(%d+)$")
            if k and op and num then
              ensureCur()
              local key = trim(k)
              local n = tonumber(num)
              -- classify as role or class
              local keyU = key:upper()
              if keyU=="TANK" or keyU=="HEALER" or keyU=="MELEE" or keyU=="RANGE" then
                cur.op.role[keyU] = {op=op, val=n}
              else
                cur.op.class[key] = {op=op, val=n} -- class or class(spec) string
              end
            else
              local rk, v = token:match("^([%w_]+)%s*=%s*(%w+)$")
              if rk and v then
                ensureCur()
                local RKU = rk:upper()
                if v:lower()=="fill" and (RKU=="TANK" or RKU=="HEALER" or RKU=="MELEE" or RKU=="RANGE") then
                  cur.fill[RKU] = true
                else
                  -- legacy numeric quota
                  local nv = tonumber(v)
                  if nv then
                    if RKU=="TANK" or RKU=="HEALER" or RKU=="MELEE" or RKU=="RANGE" then
                      cur.op.role[RKU] = {op="=", val=nv}
                    else
                      cur.op.class[rk] = {op="=", val=nv}
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  -- init reading
  for line in (text.."\n"):gmatch("(.-)\n") do
    local ln = trim(line or "")
    if ln=="" or ln:sub(1,1)=="#" then
      -- ignore
    elseif ln:match("^Global%s*=") then
      local gv = trim(ln:match("^Global%s*=%s*(.+)$") or "")
      if gv~="" then table.insert(global.raw, gv) end
    elseif ln:match("^Grp%s*=") then
      push()
      local g = tonumber(ln:match("^Grp%s*=%s*(%d+)"))
      if g and g>=1 and g<=8 then
        groups[g] = groups[g] or {grp=g, def={}, GrpType=nil, avoid={}, require={}, wants={}, prefer={}, op={class={},role={}}, fill={} }
        cur = groups[g]
      end
    elseif ln:match("^GrpType%s*=") then
      if cur then cur.GrpType = trim(ln:match("^GrpType%s*=%s*(.+)$") or "") end
    elseif ln:match("^definition%s*=") then
      if cur then cur.definition = trim(ln:match("^definition%s*=%s*(.+)$") or "") end
    end
  end
  push()

  -- parse simple global constraints (optional, extendable)
  local gtext = table.concat(global.raw, ";")
  if gtext~="" then
    local tokens = {}
    for tok in gtext:gmatch("([^;]+)") do table.insert(tokens, trim(tok)) end
    for _,t in ipairs(tokens) do
      local key,op,val = t:match("^([%w_]+)%s*([<>!]=?)%s*(%d+)$")
      if key and op and val then
        key = key:lower()
        local n = tonumber(val)
        if key=="healerinmelee" then global.HealerInMeleeMax = {op=op, val=n}
        elseif key=="shamanpermeleegrp" then global.ShamanPerMeleeMin = {op=op, val=n}
        end
      end
    end
  end

  return groups, global
end

-- Helpers for classification
local CLASS_TO_ROLE_HINT = {
  ROGUE="Melee", WARRIOR="Melee", HUNTER="Range", MAGE="Range", WARLOCK="Range",
  PRIEST="Healer", SHAMAN="Healer", DRUID="Healer",
}

local function collectRosterBuckets()
  local byClass = { WARRIOR={}, ROGUE={}, HUNTER={}, MAGE={}, WARLOCK={}, PRIEST={}, SHAMAN={}, DRUID={} }
  local byRole  = { Tank={}, Healer={}, Melee={}, Range={} }

  local function addTo(t, key, name) t[key] = t[key] or {}; table.insert(t[key], name) end
  for _,n in ipairs(activeTank)   do addTo(byRole, "Tank",   n) end
  for _,n in ipairs(activeHealer) do addTo(byRole, "Healer", n) end
  for _,n in ipairs(activeMelee)  do addTo(byRole, "Melee",  n) end
  for _,n in ipairs(activeRange)  do addTo(byRole, "Range",  n) end

  for unit in IterateGroup() do
    local nm = GetUnitName(unit, true)
    if nm then
      nm = getFullPlayerName(nm)
      local cls = getClassOf(nm)
      if cls and byClass[cls] then table.insert(byClass[cls], nm) end
    end
  end

  local function purgeExcluded(listMap)
    for k,arr in pairs(listMap) do
      local keep = {}
      for _,n in ipairs(arr) do if not isExcluded(n) then table.insert(keep, n) end end
      listMap[k] = keep
    end
  end
  purgeExcluded(byClass)
  purgeExcluded(byRole)

  return byClass, byRole
end

local function opCheck(actual, op, val)
  if not actual then actual=0 end
  if op=="="  then return actual==val
  elseif op=="!=" then return actual~=val
  elseif op==">"  then return actual>val
  elseif op=="<"  then return actual<val
  elseif op==">=" then return actual>=val
  elseif op=="<=" then return actual<=val
  end
  return false
end

local function buildRaidIndex()
  local byName = {}
  if not IsInRaid() then return byName end
  for i=1,GetNumGroupMembers() do
    local name, rank, subgroup = GetRaidRosterInfo(i)
    if name then
      name = getFullPlayerName(name)
      byName[name] = {index=i, subgroup=subgroup, rank=rank}
    end
  end
  return byName
end

-- prefer & wants scorer
local function scoreCandidate(name, wantsTags, avoidSet, preferList)
  local score = 0
  local cls = (getClassOf(name) or "UNKNOWN"):upper()
  -- wants: simple tag?class/spec mapping
  for _,tag in ipairs(wantsTags or {}) do
    local sat = TAG_TO_SATISFIERS[tag]
    if sat then
      if sat[cls] == true then score = score + 2
      elseif type(sat[cls])=="string" then
        -- spec hint in name not available ? mild bonus
        score = score + 1
      end
    end
  end
  -- avoid: penalize if matches role or class name
  if avoidSet then
    for av,_ in pairs(avoidSet) do
      local AVU = av:upper()
      if AVU==cls then score = score - 2 end
      -- rough role checks
      if (AVU=="HEALER" and MyRaidAddon.db.profile.roleAssignments[name]=="healer") then score=score-2 end
      if (AVU=="MELEE"  and MyRaidAddon.db.profile.roleAssignments[name]=="melee")  then score=score-2 end
      if (AVU=="RANGE"  and MyRaidAddon.db.profile.roleAssignments[name]=="range")  then score=score-2 end
      if (AVU=="TANK"   and MyRaidAddon.db.profile.roleAssignments[name]=="tank")   then score=score-2 end
    end
  end
  -- prefer order: earlier gets small boost
  if preferList and #preferList>0 then
    for i,p in ipairs(preferList) do
      local PU = p:upper()
      if PU==cls then score = score + (2 - (i-1)*0.25) end
      if PU=="MELEE"  and MyRaidAddon.db.profile.roleAssignments[name]=="melee"  then score = score + (1.5 - (i-1)*0.25) end
      if PU=="RANGE"  and MyRaidAddon.db.profile.roleAssignments[name]=="range"  then score = score + (1.5 - (i-1)*0.25) end
      if PU=="HEALER" and MyRaidAddon.db.profile.roleAssignments[name]=="healer" then score = score + (1.5 - (i-1)*0.25) end
      if PU=="TANK"   and MyRaidAddon.db.profile.roleAssignments[name]=="tank"   then score = score + (1.5 - (i-1)*0.25) end
    end
  end
  -- ilvl tie-breaker (normalized)
  local il = playerItemLevels[name] or (MyRaidAddon.db.profile.invitedPlayers[name] and MyRaidAddon.db.profile.invitedPlayers[name].ilvl) or 0
  score = score + (tonumber(il) or 0)/1000
  return score
end

local function applySortRules()
  if not IsInRaid() or GetNumGroupMembers() <= 5 then
    print("|cffffaa00[Sort Grps]|r Not in a raid or <=5 players.")
    return
  end
  if not (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
    print("|cffff5555[Sort Grps]|r You must be raid leader or assistant.")
    return
  end

  local byClass, byRole = collectRosterBuckets()

  local sortText = MyRaidAddon.db.profile.sortRulesText or DEFAULT_SORT_TEXT
  local groupsDef, global = parseSortRules(sortText)

  local total = GetNumGroupMembers()
  local neededGroups = math.min(8, math.max(1, math.ceil(total / 5)))

  local groups = {}
  for g=1,neededGroups do
    local def = groupsDef[g] or {grp=g, def={}, GrpType=nil, op={class={},role={}}, fill={}, avoid={}, require={}, wants={}, prefer={}}
    groups[g] = {
      members={}, size=0, tag=def.GrpType,
      op=def.op, fill=def.fill, avoid=def.avoid, require=def.require, wants=def.wants, prefer=def.prefer
    }
  end

  local placed = {}
  local function hasSpace(g) return groups[g].size < 5 end
  local function add(g, name)
    if not name or placed[name] or not hasSpace(g) then return false end
    table.insert(groups[g].members, name); groups[g].size = groups[g].size + 1; placed[name]=true; return true
  end

  local function takeFromPool(poolArr, count, g)
    local taken = {}
    -- score poolArr via wants/avoid/prefer
    table.sort(poolArr, function(a,b)
      return scoreCandidate(a, groups[g].wants, groups[g].avoid, groups[g].prefer) >
             scoreCandidate(b, groups[g].wants, groups[g].avoid, groups[g].prefer)
    end)
    for _,n in ipairs(poolArr) do
      if #taken>=count then break end
      if not placed[n] and add(g,n) then table.insert(taken, n) end
    end
    return taken
  end

  -- helper counts
  local function countIn(arr, pred)
    local c=0; for _,n in ipairs(arr) do if pred(n) then c=c+1 end end; return c
  end

  -- Pass 0: REQUIRE (simple): ensure textual requires like "Shaman>=1" or "Shaman" or "Melee>=1"
  local function satisfyRequire(g)
    for _,req in ipairs(groups[g].require or {}) do
      local k,op,val = req:match("^([%w_%(%)/]+)%s*([<>!]=?)%s*(%d+)$")
      local wantN = tonumber(val) or 1
      local key = k or req
      local KU = key:upper()
      local needed = wantN
      if KU=="MELEE" or KU=="RANGE" or KU=="HEALER" or KU=="TANK" then
        local pool = (KU=="MELEE" and byRole.Melee) or (KU=="RANGE" and byRole.Range) or (KU=="HEALER" and byRole.Healer) or byRole.Tank
        local have = countIn(groups[g].members, function(n)
          return (MyRaidAddon.db.profile.roleAssignments[n] or ""):upper()==KU
        end)
        if have < needed then
          local cand = {}
          for _,n in ipairs(pool or {}) do if not placed[n] then table.insert(cand, n) end end
          takeFromPool(cand, needed-have, g)
        end
      else
        -- treat as class/spec string
        local cls = key
        local pool = byClass[(cls:match("^([%w_]+)") or ""):upper()] or {}
        local have = countIn(groups[g].members, function(n)
          return ((getClassOf(n) or ""):upper() == (cls:match("^([%w_]+)") or ""):upper())
        end)
        if have < needed then
          local cand = {}
          for _,n in ipairs(pool or {}) do if not placed[n] then table.insert(cand, n) end end
          takeFromPool(cand, needed-have, g)
        end
      end
    end
  end

  -- Pass 1: explicit CLASS quotas with operators
  for g=1,neededGroups do
    satisfyRequire(g)
    for key,cond in pairs(groups[g].op.class or {}) do
      local clsKey = (key:match("^([%w_]+)") or key):upper()
      local pool = byClass[clsKey] or {}
      local have = countIn(groups[g].members, function(n)
        return ((getClassOf(n) or ""):upper()==clsKey)
      end)
      local target = cond.val
      local need = 0
      if cond.op=="=" or cond.op==">=" then need = math.max(0, target - have)
      elseif cond.op==">" then need = math.max(0, (target+1) - have)
      elseif cond.op=="<=" or cond.op=="<" or cond.op=="!=" then
        -- we don't pre-remove; handle later if exceeded
        need = 0
      end
      if need>0 then
        local cand = {}
        for _,n in ipairs(pool) do if not placed[n] then table.insert(cand, n) end end
        takeFromPool(cand, need, g)
      end
    end
  end

  -- Pass 2: explicit ROLE quotas with operators
  local ROLE_KEYS = {"TANK","HEALER","MELEE","RANGE"}
  for g=1,neededGroups do
    for _,rk in ipairs(ROLE_KEYS) do
      local cond = groups[g].op.role[rk]
      if cond then
        local have = countIn(groups[g].members, function(n)
          return ((MyRaidAddon.db.profile.roleAssignments[n] or ""):upper()==rk)
        end)
        local need = 0
        if cond.op=="=" or cond.op==">=" then need = math.max(0, cond.val - have)
        elseif cond.op==">" then need = math.max(0, (cond.val+1) - have)
        end
        if need>0 then
          local pool = (rk=="TANK" and activeTank) or (rk=="HEALER" and activeHealer) or (rk=="MELEE" and activeMelee) or activeRange
          local cand = {}
          for _,n in ipairs(pool) do if not placed[n] then table.insert(cand, n) end end
          takeFromPool(cand, need, g)
        end
      end
    end
  end

  -- Pass 3: fills (Melee/Range/Healer/Tank = fill) mit Scoring + Avoid
  for g=1,neededGroups do
    if hasSpace(g) then
      local order = {"TANK","HEALER","MELEE","RANGE"}
      if groups[g].tag=="Melee" then order = {"TANK","HEALER","MELEE","RANGE"}
      elseif groups[g].tag=="Range" or groups[g].tag=="Caster" then order = {"TANK","HEALER","RANGE","MELEE"} end
      for _,rk in ipairs(order) do
        if groups[g].fill[rk] and hasSpace(g) then
          local pool = (rk=="TANK" and activeTank) or (rk=="HEALER" and activeHealer) or (rk=="MELEE" and activeMelee) or activeRange
          local cand = {}
          for _,n in ipairs(pool) do
            if not placed[n] then
              table.insert(cand, n)
            end
          end
          local need = 5 - groups[g].size
          takeFromPool(cand, need, g)
        end
      end
    end
  end

  -- Pass 4: still space? round-robin by remaining role pools (pref by tag)
  for g=1,neededGroups do
    local roleOrder = {"TANK","HEALER","MELEE","RANGE"}
    if groups[g].tag=="Melee" then roleOrder = {"TANK","HEALER","MELEE","RANGE"}
    elseif groups[g].tag=="Range" or groups[g].tag=="Caster" then roleOrder = {"TANK","HEALER","RANGE","MELEE"} end

    while hasSpace(g) do
      local addedAny = false
      for _,rk in ipairs(roleOrder) do
        local pool = (rk=="TANK" and activeTank) or (rk=="HEALER" and activeHealer) or (rk=="MELEE" and activeMelee) or activeRange
        local cand = {}
        for _,n in ipairs(pool) do if not placed[n] then table.insert(cand, n) end end
        local got = takeFromPool(cand, 1, g)
        if #got>0 then addedAny=true; if not hasSpace(g) then break end end
      end
      if not addedAny then break end
    end
  end

  -- Pass 5: final sweep from remaining class pools
  for cls, arr in pairs(byClass) do
    for _,n in ipairs(arr) do
      if not placed[n] then
        for g=1,neededGroups do if hasSpace(g) then if add(g, n) then break end end end
      end
    end
  end

  -- (Optional) Global checks (soft): HealerInMelee / ShamanPerMeleeGrp (best-effort, no swaps)
  -- For brevity: just warn if violated
  if global then
    for g=1,neededGroups do
      if groups[g].tag=="Melee" then
        local healers = countIn(groups[g].members, function(n) return (MyRaidAddon.db.profile.roleAssignments[n] or "")=="healer" end)
        if global.HealerInMeleeMax and not opCheck(healers, global.HealerInMeleeMax.op, global.HealerInMeleeMax.val) then
          print(string.format("|cffffaa00[Sort Grps]|r Warning G%d: HealerInMelee=%d violates %s%d", g, healers, global.HealerInMeleeMax.op, global.HealerInMeleeMax.val))
        end
        local sham=0; for _,n in ipairs(groups[g].members) do if (getClassOf(n) or ""):upper()=="SHAMAN" then sham=sham+1 end end
        if global.ShamanPerMeleeMin and not opCheck(sham, global.ShamanPerMeleeMin.op, global.ShamanPerMeleeMin.val) then
          print(string.format("|cffffaa00[Sort Grps]|r Warning G%d: Shamans=%d violates %s%d", g, sham, global.ShamanPerMeleeMin.op, global.ShamanPerMeleeMin.val))
        end
      end
    end
  end

  -- apply to actual roster
  local idxMap = buildRaidIndex()
  for g=1,neededGroups do
    for _, name in ipairs(groups[g].members) do
      local rec = idxMap[name]
      if rec and rec.subgroup ~= g then
        SetRaidSubgroup(rec.index, g)
      end
    end
  end

  print(string.format("|cff55ff55[Sort Grps]|r Sorted %d players into %d groups (rules applied+).", total, neededGroups))
end

-- ==============================
-- UI Refresh Helper
-- ==============================
local function RebuildActiveTab()
  if not tabGroup or not tabGroup.GetSelected then return end
  local sel = tabGroup:GetSelected()
  if not sel then return end
  -- Erzwinge Neuaufbau, auch wenn derselbe Tab ausgewählt ist
  if SelectTab then
    SelectTab(tabGroup, nil, sel)
  else
    tabGroup:SelectTab(sel)
  end
end

-- ==============================
-- Whisper Handler
-- ==============================
local function sendIfAuto(target, text)
  if not autoReplyInviteEnabled then return end
  if text and text ~= "" then
    SendChatMessage(text, "WHISPER", nil, target)
    logWhisper(getFullPlayerName(target), text, "out")
  end
end

local function handleRoleAssignmentFromRule(senderFull, role, inviteFlag)
  if isExcluded(senderFull) then return false end
  if not role or not canAddToRole(role) then return false end
  PersistAddToActive(role, senderFull)

  MyRaidAddon:AddToInvitedPlayers(senderFull, role, isPlayerInGroup(senderFull) and "active" or "request")

  if autoReplyInviteEnabled and inviteFlag then
    InviteIfNotExcluded(senderFull)
    MyRaidAddon:AddToInvitedPlayers(senderFull, role, "invited")
  end

  updatePlayersWithoutRole()
  updatePlayerStatuses()
  MyRaidAddon:UpdateRoleManagementPage()
  return true
end

local function onWhisper(_, msg, sender)
  local full = getFullPlayerName(sender)
  if not full or not full:find("-") then return end

  logWhisper(full, msg, "in")

  if isExcluded(full) then RebuildActiveTab(); return end

  if autoReplyInviteEnabled then
    local rule = evaluateAIRules(msg)
    if rule then
      if rule.excludePlayer then
        MyRaidAddon.db.profile.invitedPlayers[full] = MyRaidAddon.db.profile.invitedPlayers[full] or {}
        MyRaidAddon.db.profile.invitedPlayers[full].status = "Excluded"
        removeFromAllActiveLists(full)
        updatePlayersWithoutRole(); updatePlayerStatuses()
        sendIfAuto(sender, pickReply(rule))
        RebuildActiveTab()
        return
      end
      if rule.offtopic then
        sendIfAuto(sender, pickReply(rule))
        if rule.stop then RebuildActiveTab(); return end
      end
      if rule.role then
        if handleRoleAssignmentFromRule(full, rule.role, rule.invite) then
          sendIfAuto(sender, pickReply(rule))
          RebuildActiveTab()
          if rule.stop then return end
        else
          sendIfAuto(sender, "Sorry, that role is currently full.")
          RebuildActiveTab()
          return
        end
      else
        sendIfAuto(sender, pickReply(rule))
        RebuildActiveTab()
        if rule.stop then return end
      end
    end
  end

  local role = extractRole(msg)
  if not role then
    listAddUnique(conversationList, full)
    MyRaidAddon:AddToInvitedPlayers(full, nil, "request")
    RebuildActiveTab()
    MyRaidAddon:UpdateRoleManagementPage()
    return
  end

  if not canAddToRole(role) then
    sendIfAuto(sender, "Sorry, all slots for your role are already filled.")
    RebuildActiveTab()
    return
  end

  PersistAddToActive(role, full)
  MyRaidAddon:AddToInvitedPlayers(full, role, isPlayerInGroup(full) and "active" or "request")

  if autoReplyInviteEnabled then
    sendIfAuto(sender, "You have been registered as "..role..".")
    InviteIfNotExcluded(full)
    MyRaidAddon:AddToInvitedPlayers(full, role, "invited")
  end

  RebuildActiveTab()
  MyRaidAddon:UpdateRoleManagementPage()
end

-- Outgoing whisper logging
local function onWhisperOut(_, msg, target)
  local full = getFullPlayerName(target)
  if full then
    logWhisper(full, msg, "out")
    if tabGroup and tabGroup.GetSelected and tabGroup:GetSelected()=="history" then RebuildActiveTab() end
  end
end

-- ==============================
-- Inspect Ergebnis
-- ==============================
local function onInspectReady(_, guid)
  local unitFound
  for unit in IterateGroup() do
    if UnitGUID(unit) == guid then unitFound = unit; break end
  end
  if not unitFound then isInspecting=false; return end

  local total, count = 0, 0
  for slot = 1, 17 do
    if slot ~= 4 then
      local link = GetInventoryItemLink(unitFound, slot)
      if link then
        local _, _, _, ilvl = GetItemInfo(link)
        if GetDetailedItemLevelInfo then
          local det = GetDetailedItemLevelInfo(link)
          if det then ilvl = det end
        end
        if ilvl then total = total + ilvl; count = count + 1 end
      end
    end
  end

  if count > 0 then
    local nm = getFullPlayerName(GetUnitName(unitFound, true))
    playerItemLevels[nm] = math.floor((total / count) + 0.5)
    if MyRaidAddon.db.profile.invitedPlayers[nm] then
      MyRaidAddon.db.profile.invitedPlayers[nm].ilvl = playerItemLevels[nm]
    end
  end

  isInspecting = false
  if tabGroup and tabGroup.GetSelected and (tabGroup:GetSelected()=="roles" or tabGroup:GetSelected()=="history" or tabGroup:GetSelected()=="excluded") then
    RebuildActiveTab()
  end
end

-- ==============================
-- Chat-Ausgabe
-- ==============================
local function announceActiveLists()
  local chatType = IsInRaid() and "RAID" or (IsInGroup() and "PARTY" or "SAY")
  local function listToText(t) return (#t>0) and table.concat(t, ", ") or "—" end
  SendChatMessage("Role assignments:", chatType)
  SendChatMessage("Tanks: " .. listToText(activeTank),  chatType)
  SendChatMessage("Healers: " .. listToText(activeHealer), chatType)
  SendChatMessage("Melee DPS: " .. listToText(activeMelee), chatType)
  SendChatMessage("Range DPS: " .. listToText(activeRange), chatType)
end

local function postRaid(raidKey)
  local cfg = raidConfig[raidKey]
  if not cfg then print("Invalid raid key.") return end
  local t,h,r,m = #activeTank, #activeHealer, #activeRange, #activeMelee
  local dps     = r + m
  local opt     = cfg.raidOption and (cfg.raidOption .. " - ") or ""
  local msg = string.format(
    "LFM %s - %sTank: %d/%d, Heal: %d/%d, DPS: %d/%d (Range: %d, Melee: %d)",
    cfg.RaidName, opt, t,cfg.NeedTanks, h,cfg.NeedHealers, dps,cfg.NeedDPS, r,m
  )
  local sent=false
  for channel, enabled in pairs(selectedChannels) do
    if enabled then
      if channel:sub(1,7)=="CHANNEL" then
        local num = tonumber(channel:sub(9))
        local id  = num and GetChannelName(num) or 0
        if id and id ~= 0 then SendChatMessage(msg, "CHANNEL", nil, num); sent=true
        else print("Channel not joined or invalid:", channel) end
      else
        if channel=="GUILD" or channel=="SAY" or channel=="YELL" or channel=="RAID" or channel=="PARTY" then
          SendChatMessage(msg, channel); sent=true
        else print("Unknown chat type:", channel) end
      end
    end
  end
  if not sent then print("No valid channel selected for LFM message.") end
end

-- ==============================
-- Tabs / UI (Roles-Tab aktualisiert persistent)
-- ==============================
local function calcTotalIlvl()
  local total = 0
  for _, list in ipairs({activeTank, activeHealer, activeRange, activeMelee}) do
    for _, nm in ipairs(list) do
      total = total + (playerItemLevels[nm] or (MyRaidAddon.db.profile.invitedPlayers[nm] and MyRaidAddon.db.profile.invitedPlayers[nm].ilvl) or 0)
    end
  end
  return total
end
local function calcRaidProgress()
  local cfg = currentRaidCfg(); if not cfg then return 0 end
  local cur = #activeTank + #activeHealer + #activeRange + #activeMelee
  return math.floor(((cur / cfg.RaidSize) * 100) + 0.5)
end

function MyRaidAddon:UpdateStatusBar()
  if not mainFrame or not mainFrame.SetStatusText then return end

  local cfg = currentRaidCfg() or { NeedTanks=0, NeedHealers=0, NeedDPS=0, RaidSize=0 }
  local haveT, haveH = #activeTank, #activeHealer
  local haveR, haveM = #activeRange, #activeMelee
  local haveD        = haveR + haveM
  local needT, needH, needD = cfg.NeedTanks or 0, cfg.NeedHealers or 0, cfg.NeedDPS or 0

  -- Ready (in group & online & role assigned)
  local unitByName, isOnline = {}, {}
  for unit in IterateGroup() do
    local nm = GetUnitName(unit, true)
    if nm then nm = getFullPlayerName(nm); unitByName[nm] = unit; isOnline[nm] = UnitIsConnected(unit) and true or false end
  end
  local function countReady(list)
    local n=0; for _,nm in ipairs(list) do if unitByName[nm] and isOnline[nm] then n=n+1 end end; return n
  end
  local readyT = countReady(activeTank)
  local readyH = countReady(activeHealer)
  local readyR = countReady(activeRange)
  local readyM = countReady(activeMelee)
  local readyD = readyR + readyM
  local readyTotal = readyT + readyH + readyD

  -- Color helper
  local function colorize(curr, need)
    local col = "ffff5555" -- red
    if need <= 0 then col = "ffffffff"
    elseif curr >= need then col = "55ff55ff" -- green
    elseif curr > 0 then col = "ffffcc00" -- yellow
    end
    return string.format("|c%s%d|r/%d", col, curr, need)
  end

  local roleSummary = string.format("T %s H %s D %s (R %d, M %d)", colorize(haveT,needT), colorize(haveH,needH), colorize(haveD,needD), haveR, haveM)

  local missingParts = {}
  if haveT < needT then table.insert(missingParts, string.format("T%d", needT - haveT)) end
  if haveH < needH then table.insert(missingParts, string.format("H%d", needH - haveH)) end
  if haveD < needD then table.insert(missingParts, string.format("D%d", needD - haveD)) end
  local missingStr = (#missingParts>0) and (" | Missing: "..table.concat(missingParts, ", ")) or " | Missing: 0"

  local progress = calcRaidProgress()
  local totalIlvl = calcTotalIlvl()

  -- No-Role count (pending)
  updatePlayersWithoutRole()
  local pending = 0; for _,nm in ipairs(playersWithoutRole) do if nm and not inAnyActiveList(nm) then pending = pending + 1 end end

  local readyStr = string.format(" | Ready: %d in grp/online", readyTotal)

  local extra = ""

  local text = string.format("%s%s | Pending: %d | Progress: %d%% | ilvl: %d%s",
    roleSummary, missingStr, pending, progress, totalIlvl, extra)
  mainFrame:SetStatusText(text)
end

local function buildMainTab(container)
  container:ReleaseChildren()
  local scroll = AceGUI:Create("ScrollFrame"); scroll:SetLayout("Flow"); scroll:SetFullWidth(true); scroll:SetFullHeight(true); container:AddChild(scroll)

  local top = AceGUI:Create("SimpleGroup"); top:SetLayout("Flow"); top:SetFullWidth(true); scroll:AddChild(top)

  local postBtn = AceGUI:Create("Button"); postBtn:SetText("Post LFM"); postBtn:SetWidth(120)
  postBtn:SetCallback("OnClick", function() postRaid(selectedRaid) end)
  top:AddChild(postBtn)

  -- Auto Post LFM removed to comply with policies

  local autoAll = AceGUI:Create("CheckBox")
  autoAll:SetLabel("Auto Reply+Invite (enables Whisper Rules)")
  autoAll:SetValue(autoReplyInviteEnabled)
  autoAll:SetWidth(320)
  autoAll:SetCallback("OnValueChanged", function(_,_,v)
    autoReplyInviteEnabled = v
    MyRaidAddon.db.profile.autoReplyInviteEnabled = v
  end)
  top:AddChild(autoAll)

  if MyRaidAddon and MyRaidAddon.UpdateStatusBar then MyRaidAddon:UpdateStatusBar() end

  local raidGrp = AceGUI:Create("InlineGroup"); raidGrp:SetTitle("Raid Settings"); raidGrp:SetLayout("Flow"); raidGrp:SetFullWidth(true); scroll:AddChild(raidGrp)

  local raidList = {}; for k,v in pairs(raidConfig) do raidList[k]=v.RaidName end
  local cfg = currentRaidCfg()

  -- Links row (SR + Discord) with raid-warning option and post button
  MyRaidAddon.db.profile.srLink = MyRaidAddon.db.profile.srLink or ""
  MyRaidAddon.db.profile.discordLink = MyRaidAddon.db.profile.discordLink or ""
  if type(MyRaidAddon.db.profile.raidWarnEnabled) ~= "boolean" then MyRaidAddon.db.profile.raidWarnEnabled = false end

  local row0 = AceGUI:Create("SimpleGroup"); row0:SetFullWidth(true); row0:SetLayout("Flow"); raidGrp:AddChild(row0)

  local ebSR = AceGUI:Create("EditBox"); ebSR:SetLabel("SR Link"); ebSR:SetText(MyRaidAddon.db.profile.srLink or ""); ebSR:SetRelativeWidth(0.4); row0:AddChild(ebSR)
  ebSR:SetCallback("OnTextChanged", function(_,_,txt) MyRaidAddon.db.profile.srLink = txt or "" end)

  local ebDisc = AceGUI:Create("EditBox"); ebDisc:SetLabel("Discord Link"); ebDisc:SetText(MyRaidAddon.db.profile.discordLink or ""); ebDisc:SetRelativeWidth(0.4); row0:AddChild(ebDisc)
  ebDisc:SetCallback("OnTextChanged", function(_,_,txt) MyRaidAddon.db.profile.discordLink = txt or "" end)

  local cbRW = AceGUI:Create("CheckBox"); cbRW:SetLabel("Raid Warning (/rw)"); cbRW:SetValue(MyRaidAddon.db.profile.raidWarnEnabled); cbRW:SetWidth(150); row0:AddChild(cbRW)
  cbRW:SetCallback("OnValueChanged", function(_,_,v) MyRaidAddon.db.profile.raidWarnEnabled = v and true or false end)

  local function postLinks()
    local sr = (MyRaidAddon.db.profile.srLink or ""):match("%S") and MyRaidAddon.db.profile.srLink or nil
    local dc = (MyRaidAddon.db.profile.discordLink or ""):match("%S") and MyRaidAddon.db.profile.discordLink or nil
    if not sr and not dc then print("|cffffaa00[LFM]|r No links to post.") return end
    local inRaid = IsInRaid()
    local inGroup = IsInGroup()
    local chatType
    if inRaid then
      if MyRaidAddon.db.profile.raidWarnEnabled and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
        chatType = "RAID_WARNING"
      else
        chatType = "RAID"
      end
    elseif inGroup then
      chatType = "PARTY"
    else
      print("|cffffaa00[LFM]|r Not in party/raid; cannot post to group.")
      return
    end
    if sr then SendChatMessage("SR: "..sr, chatType) end
    if dc then SendChatMessage("Discord: "..dc, chatType) end
  end

  local btnPostLinks = AceGUI:Create("Button"); btnPostLinks:SetText("Post Links"); btnPostLinks:SetWidth(120); row0:AddChild(btnPostLinks)
  btnPostLinks:SetCallback("OnClick", function() postLinks() end)

  local row1 = AceGUI:Create("SimpleGroup"); row1:SetFullWidth(true); row1:SetLayout("Flow"); raidGrp:AddChild(row1)
  local dd = AceGUI:Create("Dropdown"); dd:SetLabel("Select Dungeon/Raid"); dd:SetList(raidList); dd:SetValue(selectedRaid); dd:SetRelativeWidth(0.5); row1:AddChild(dd)
  local ebName = AceGUI:Create("EditBox"); ebName:SetLabel("Raid Name (display)"); ebName:SetText(cfg.RaidName or ""); ebName:SetRelativeWidth(0.5); row1:AddChild(ebName)

  local row2 = AceGUI:Create("SimpleGroup"); row2:SetFullWidth(true); row2:SetLayout("Flow"); raidGrp:AddChild(row2)
  local ebOpt = AceGUI:Create("EditBox"); ebOpt:SetLabel("Raid Option (text)"); ebOpt:SetText(cfg.raidOption or ""); ebOpt:SetRelativeWidth(0.5); row2:AddChild(ebOpt)
  local eML = AceGUI:Create("EditBox"); eML:SetLabel("Min Level"); eML:SetText(tostring(cfg.minLevel or "")); eML:SetRelativeWidth(0.25); row2:AddChild(eML)
  local eIL = AceGUI:Create("EditBox"); eIL:SetLabel("Min iLvl");  eIL:SetText(tostring(cfg.minIlvl or "")); eIL:SetRelativeWidth(0.25); row2:AddChild(eIL)

  local row3 = AceGUI:Create("SimpleGroup"); row3:SetFullWidth(true); row3:SetLayout("Flow"); raidGrp:AddChild(row3)
  local eSize = AceGUI:Create("EditBox"); eSize:SetLabel("Raid Size"); eSize:SetText(tostring(cfg.RaidSize)); eSize:SetRelativeWidth(0.25); row3:AddChild(eSize)
  local eT    = AceGUI:Create("EditBox"); eT:SetLabel("Need Tanks"); eT:SetText(tostring(cfg.NeedTanks)); eT:SetRelativeWidth(0.25); row3:AddChild(eT)
  local eH    = AceGUI:Create("EditBox"); eH:SetLabel("Need Healers"); eH:SetText(tostring(cfg.NeedHealers)); eH:SetRelativeWidth(0.25); row3:AddChild(eH)
  local eD    = AceGUI:Create("EditBox"); eD:SetLabel("Need DPS"); eD:SetText(tostring(cfg.NeedDPS)); eD:SetRelativeWidth(0.25); row3:AddChild(eD)

  local function tonumberOr(old, txt) local n=tonumber(txt); return n or old end
  ebName:SetCallback("OnTextChanged", function(_,_,txt) raidConfig[selectedRaid].RaidName=txt; MyRaidAddon.db.profile.raidConfig=raidConfig end)
  ebOpt:SetCallback("OnTextChanged", function(_,_,txt) raidConfig[selectedRaid].raidOption=txt; MyRaidAddon.db.profile.raidConfig=raidConfig end)
  eML:SetCallback("OnTextChanged", function(w,_,txt) raidConfig[selectedRaid].minLevel = tonumberOr(raidConfig[selectedRaid].minLevel, txt); MyRaidAddon.db.profile.raidConfig=raidConfig end)
  eIL:SetCallback("OnTextChanged", function(w,_,txt) raidConfig[selectedRaid].minIlvl  = tonumberOr(raidConfig[selectedRaid].minIlvl,  txt); MyRaidAddon.db.profile.raidConfig=raidConfig end)
  eSize:SetCallback("OnTextChanged", function(w,_,txt) raidConfig[selectedRaid].RaidSize   = tonumberOr(raidConfig[selectedRaid].RaidSize,   txt); MyRaidAddon.db.profile.raidConfig=raidConfig end)
  eT:SetCallback(   "OnTextChanged", function(w,_,txt) raidConfig[selectedRaid].NeedTanks  = tonumberOr(raidConfig[selectedRaid].NeedTanks,  txt); MyRaidAddon.db.profile.raidConfig=raidConfig end)
  eH:SetCallback(   "OnTextChanged", function(w,_,txt) raidConfig[selectedRaid].NeedHealers= tonumberOr(raidConfig[selectedRaid].NeedHealers,txt); MyRaidAddon.db.profile.raidConfig=raidConfig end)
  eD:SetCallback(   "OnTextChanged", function(w,_,txt) raidConfig[selectedRaid].NeedDPS    = tonumberOr(raidConfig[selectedRaid].NeedDPS,    txt); MyRaidAddon.db.profile.raidConfig=raidConfig end)

  dd:SetCallback("OnValueChanged", function(_,_,key)
    selectedRaid = key; MyRaidAddon.db.profile.selectedRaid=key
    local c = raidConfig[key]
    ebName:SetText(c.RaidName or ""); ebOpt:SetText(c.raidOption or "")
    eML:SetText(tostring(c.minLevel or "")); eIL:SetText(tostring(c.minIlvl or ""))
    eSize:SetText(tostring(c.RaidSize)); eT:SetText(tostring(c.NeedTanks)); eH:SetText(tostring(c.NeedHealers)); eD:SetText(tostring(c.NeedDPS))
  end)

  local chGrp = AceGUI:Create("InlineGroup"); chGrp:SetTitle("Select Channels"); chGrp:SetLayout("Flow"); chGrp:SetFullWidth(true); scroll:AddChild(chGrp)
  local col1 = AceGUI:Create("SimpleGroup"); col1:SetRelativeWidth(0.5); col1:SetLayout("List"); chGrp:AddChild(col1)
  local col2 = AceGUI:Create("SimpleGroup"); col2:SetRelativeWidth(0.5); col2:SetLayout("List"); chGrp:AddChild(col2)
  local function updateSelectedChannel(channel, checked)
    if checked then selectedChannels[channel]=true else selectedChannels[channel]=nil end
    MyRaidAddon.db.profile.selectedChannels = selectedChannels
  end
  for i,ch in ipairs(channelOptions) do
    local cb = AceGUI:Create("CheckBox")
    cb:SetLabel(ch); cb:SetValue(selectedChannels[ch] or false)
    cb:SetCallback("OnValueChanged", function(_,_,v) updateSelectedChannel(ch, v) end)
    if i%2==1 then col1:AddChild(cb) else col2:AddChild(cb) end
  end
end

local function buildRolesTab(container)
  container:ReleaseChildren()
  local scroll = AceGUI:Create("ScrollFrame"); scroll:SetLayout("Flow"); scroll:SetFullWidth(true); scroll:SetFullHeight(true); container:AddChild(scroll)

  local top = AceGUI:Create("SimpleGroup"); top:SetLayout("Flow"); top:SetFullWidth(true); scroll:AddChild(top)

  local postBtn = AceGUI:Create("Button"); postBtn:SetText("Post LFM"); postBtn:SetWidth(120)
  postBtn:SetCallback("OnClick", function() postRaid(selectedRaid) end); top:AddChild(postBtn)

  local sortBtn = AceGUI:Create("Button"); sortBtn:SetText("Sort Grps"); sortBtn:SetWidth(120)
  sortBtn:SetCallback("OnClick", function() applySortRules() end); top:AddChild(sortBtn)

  local resetBtn = AceGUI:Create("Button"); resetBtn:SetText("Reset Roles"); resetBtn:SetWidth(120)
  resetBtn:SetCallback("OnClick", function()
    activeTank, activeHealer, activeRange, activeMelee = {},{},{},{}
    playersWithoutRole, conversationList = {},{}
    playerItemLevels, playerLevels = {},{}
    PersistActiveRoles()
    updatePlayersWithoutRole(); updatePlayerStatuses()
    MyRaidAddon:UpdateRoleManagementPage(); RebuildActiveTab()
  end); top:AddChild(resetBtn)

  local checkBtn = AceGUI:Create("Button"); checkBtn:SetText("Check Roles"); checkBtn:SetWidth(120)
  checkBtn:SetCallback("OnClick", function()
    updatePlayersWithoutRole(); updatePlayerStatuses()
    -- kein Auto-Apply hier, nur Status-Refresh
    MyRaidAddon:UpdateRoleManagementPage()
  end); top:AddChild(checkBtn)

  local announceBtn = AceGUI:Create("Button"); announceBtn:SetText("Announce Roles"); announceBtn:SetWidth(140)
  announceBtn:SetCallback("OnClick", function() announceActiveLists() end); top:AddChild(announceBtn)

  -- Filter für "Without Role"-Liste
  MyRaidAddon.db.profile.noRoleFilter = MyRaidAddon.db.profile.noRoleFilter or { onlyGroup=false, onlyOnline=false, maxRows=10 }
  local noRoleFilter = MyRaidAddon.db.profile.noRoleFilter

  local cbOnlyGroup = AceGUI:Create("CheckBox"); cbOnlyGroup:SetLabel("Only Group"); cbOnlyGroup:SetValue(noRoleFilter.onlyGroup or false); cbOnlyGroup:SetWidth(120)
  cbOnlyGroup:SetCallback("OnValueChanged", function(_,_,v)
    noRoleFilter.onlyGroup = v and true or false
    MyRaidAddon:UpdateRoleManagementPage(); RebuildActiveTab()
  end); top:AddChild(cbOnlyGroup)

  local cbOnlyOnline = AceGUI:Create("CheckBox"); cbOnlyOnline:SetLabel("Only Online"); cbOnlyOnline:SetValue(noRoleFilter.onlyOnline or false); cbOnlyOnline:SetWidth(120)
  cbOnlyOnline:SetCallback("OnValueChanged", function(_,_,v)
    noRoleFilter.onlyOnline = v and true or false
    MyRaidAddon:UpdateRoleManagementPage(); RebuildActiveTab()
  end); top:AddChild(cbOnlyOnline)

  local ebMax = AceGUI:Create("EditBox"); ebMax:SetLabel("Max Rows"); ebMax:SetText(tostring(noRoleFilter.maxRows or 10)); ebMax:SetWidth(110)
  ebMax:SetCallback("OnTextChanged", function(_,_,txt)
    local n = tonumber(txt) or noRoleFilter.maxRows or 10
    if n < 1 then n = 1 end; if n > 500 then n = 500 end
    noRoleFilter.maxRows = n
  end)
  ebMax:SetCallback("OnEnterPressed", function()
    MyRaidAddon:UpdateRoleManagementPage(); RebuildActiveTab()
  end); top:AddChild(ebMax)


  local function ShowPlayerOptions(name)
    local frame = AceGUI:Create("Window")
    frame:SetTitle("Assign Role"); frame:SetLayout("List"); frame:SetWidth(260); frame:SetHeight(330)
    frame:SetCallback("OnClose", function(w) AceGUI:Release(w) end)
    local roles = {
      { key="tank",  label="Tank" }, { key="healer",label="Healer" },
      { key="range", label="Range DPS" }, { key="melee", label="Melee DPS" },
    }
    for _,r in ipairs(roles) do
      local b = AceGUI:Create("Button"); b:SetText(r.label); b:SetWidth(200)
      b:SetCallback("OnClick", function() MyRaidAddon:AssignRoleAndPersist(name, r.key); frame:Hide() end)
      frame:AddChild(b)
    end
    local rem = AceGUI:Create("Button"); rem:SetText("Remove from Roles"); rem:SetWidth(200)
    rem:SetCallback("OnClick", function()
      removeFromAllActiveLists(name)
      MyRaidAddon:AddToInvitedPlayers(name, nil, "invited")
      PersistActiveRoles()
      updatePlayersWithoutRole(); updatePlayerStatuses()
      MyRaidAddon:UpdateRoleManagementPage(); frame:Hide(); RebuildActiveTab()
    end)
    frame:AddChild(rem)
    -- Open the picker near the cursor for faster workflow
    if openAtCursor then openAtCursor(frame) end
  end

  -- Dropdown version (smaller, inline) for quick role assignment
  local function ShowAssignDropdown(anchorWidget, name)
    local anchorFrame = anchorWidget and anchorWidget.frame or nil
    MyRaidAddon:OpenAssignWindow(name, anchorFrame)
  end

  -- Einheitliche Tabelle für aktive Rollen (Tanks ? Heals ? Melee ? Range)
  -- Build maps für Gruppenzugehörigkeit und Online-Status
  local unitByNameAR, isOnlineAR = {}, {}
  for unit in IterateGroup() do
    local nm = GetUnitName(unit, true)
    if nm then
      nm = getFullPlayerName(nm)
      unitByNameAR[nm] = unit
      isOnlineAR[nm] = UnitIsConnected(unit) and true or false
    end
  end
  local function statusIconAR(name)
    if unitByNameAR[name] then
      if isOnlineAR[name] then
        return "|TInterface\\FriendsFrame\\StatusIcon-Online:12:12|t"
      else
        return "|TInterface\\FriendsFrame\\StatusIcon-Offline:12:12|t"
      end
    else
      return "|TInterface\\FriendsFrame\\StatusIcon-Away:12:12|t"
    end
  end

  local roleRows = {}
  local function pushRows(list, roleKey)
    for _, nm in ipairs(list) do
      if nm:find("-") then table.insert(roleRows, {name=nm, role=roleKey}) end
    end
  end
  pushRows(activeTank,   "tank")
  pushRows(activeHealer, "healer")
  pushRows(activeMelee,  "melee")
  pushRows(activeRange,  "range")

  local orderIdx = { tank=1, healer=2, melee=3, range=4 }
  table.sort(roleRows, function(a,b)
    local oa, ob = orderIdx[a.role] or 99, orderIdx[b.role] or 99
    if oa ~= ob then return oa < ob end
    return (a.name or "") < (b.name or "")
  end)

  local activeBox = AceGUI:Create("InlineGroup"); activeBox:SetTitle("Active Roles"); activeBox:SetLayout("Flow"); activeBox:SetFullWidth(true); scroll:AddChild(activeBox)
  local headAR = AceGUI:Create("SimpleGroup"); headAR:SetFullWidth(true); headAR:SetLayout("Flow"); activeBox:AddChild(headAR)
  local function addH3(t, rel) local l=AceGUI:Create("Label"); l:SetText(t); l:SetRelativeWidth(rel); headAR:AddChild(l) end
  addH3("Name", 0.36); addH3("ilvl", 0.12); addH3("Status", 0.20); addH3("Role", 0.20)

  for _, row in ipairs(roleRows) do
    local nm, roleKey = row.name, row.role
    local disp = "|c"..getClassColorCode(nm)..nm.."|r"
    local il   = playerItemLevels[nm] or (MyRaidAddon.db.profile.invitedPlayers[nm] and MyRaidAddon.db.profile.invitedPlayers[nm].ilvl) or ""
    local st   = (MyRaidAddon.db.profile.invitedPlayers[nm] and MyRaidAddon.db.profile.invitedPlayers[nm].status) or ""

    local rgrp = AceGUI:Create("SimpleGroup"); rgrp:SetFullWidth(true); rgrp:SetLayout("Flow"); activeBox:AddChild(rgrp)

    local nameL = AceGUI:Create("InteractiveLabel"); nameL:SetText(disp); nameL:SetRelativeWidth(0.36)
    nameL:SetCallback("OnClick", function(widget) MyRaidAddon:OpenAssignWindow(nm, widget and widget.frame) end); rgrp:AddChild(nameL)
    local ilL = AceGUI:Create("Label"); ilL:SetText(il); ilL:SetRelativeWidth(0.12); rgrp:AddChild(ilL)
    local stL = AceGUI:Create("Label"); stL:SetText(statusIconAR(nm).."  "..st); stL:SetRelativeWidth(0.20); rgrp:AddChild(stL)

    local roleL = AceGUI:Create("InteractiveLabel")
    local roleDisp = (roleKey=="tank" and "Tank") or (roleKey=="healer" and "Healer") or (roleKey=="melee" and "Melee DPS") or (roleKey=="range" and "Range DPS") or roleKey
    roleL:SetText(roleDisp)
    roleL:SetRelativeWidth(0.20)
    roleL:SetCallback("OnClick", function(widget) MyRaidAddon:OpenAssignWindow(nm, widget and widget.frame) end)
    rgrp:AddChild(roleL)
  end

  updatePlayersWithoutRole()

  -- Build maps für Gruppenzugehörigkeit und Online-Status
  local unitByName, isOnline = {}, {}
  for unit in IterateGroup() do
    local nm = GetUnitName(unit, true)
    if nm then
      nm = getFullPlayerName(nm)
      unitByName[nm] = unit
      isOnline[nm] = UnitIsConnected(unit) and true or false
    end
  end

  local function statusIcon(name)
    if unitByName[name] then
      if isOnline[name] then
        return "|TInterface\\FriendsFrame\\StatusIcon-Online:12:12|t"
      else
        return "|TInterface\\FriendsFrame\\StatusIcon-Offline:12:12|t"
      end
    else
      return "|TInterface\\FriendsFrame\\StatusIcon-Away:12:12|t"
    end
  end

  -- Filter anwenden und nach Gruppenstatus trennen
  local showOnlyGroup  = (MyRaidAddon.db.profile.noRoleFilter and MyRaidAddon.db.profile.noRoleFilter.onlyGroup) or false
  local showOnlyOnline = (MyRaidAddon.db.profile.noRoleFilter and MyRaidAddon.db.profile.noRoleFilter.onlyOnline) or false
  local maxRows        = (MyRaidAddon.db.profile.noRoleFilter and MyRaidAddon.db.profile.noRoleFilter.maxRows) or 10
  if maxRows < 1 then maxRows = 1 end

  local listGroupOnline, listGroupOffline, listOthers = {}, {}, {}
  for _, nm in ipairs(playersWithoutRole) do
    if nm:find("-") and not inAnyActiveList(nm) then
      local inGrp = unitByName[nm] ~= nil
      local online = isOnline[nm] and true or false
      if (not showOnlyGroup or inGrp) and (not showOnlyOnline or online) then
        if inGrp and online then
          table.insert(listGroupOnline, nm)
        elseif inGrp and not online then
          table.insert(listGroupOffline, nm)
        else
          table.insert(listOthers, nm)
        end
      end
    end
  end

  local function renderSection(parent, title, arr)
    if #arr == 0 then return 0 end
    local box = AceGUI:Create("InlineGroup"); box:SetTitle(title.." ("..tostring(#arr)..")"); box:SetLayout("Flow"); box:SetFullWidth(true); parent:AddChild(box)
    local head = AceGUI:Create("SimpleGroup"); head:SetFullWidth(true); head:SetLayout("Flow"); box:AddChild(head)
    local function addH2(t) local l=AceGUI:Create("Label"); l:SetText(t); l:SetRelativeWidth(0.33); head:AddChild(l) end
    addH2("Name"); addH2("ilvl"); addH2("Status")

    local rendered = 0
    for i, nm in ipairs(arr) do
      if rendered >= maxRows then break end
      local disp = "|c"..getClassColorCode(nm)..nm.."|r"
      local il   = playerItemLevels[nm] or (MyRaidAddon.db.profile.invitedPlayers[nm] and MyRaidAddon.db.profile.invitedPlayers[nm].ilvl) or ""
      local st   = (MyRaidAddon.db.profile.invitedPlayers[nm] and MyRaidAddon.db.profile.invitedPlayers[nm].status) or ""

      local row = AceGUI:Create("SimpleGroup"); row:SetFullWidth(true); row:SetLayout("Flow"); box:AddChild(row)

      local nameL = AceGUI:Create("InteractiveLabel"); nameL:SetText(disp); nameL:SetRelativeWidth(0.33)
      nameL:SetCallback("OnClick", function(widget, _, button)
        if IsShiftKeyDown() then
          doWhoQuery(nm)
        else
          ShowAssignDropdown(widget, nm)
        end
      end)
      row:AddChild(nameL)

      local ilL = AceGUI:Create("Label"); ilL:SetText(il); ilL:SetRelativeWidth(0.33); row:AddChild(ilL)
      local stL = AceGUI:Create("Label"); stL:SetText(statusIcon(nm).."  "..st); stL:SetRelativeWidth(0.33); row:AddChild(stL)
      rendered = rendered + 1
    end
    return rendered
  end

  -- Gesamtkontainer für No-Role Bereich
  local others = AceGUI:Create("InlineGroup"); others:SetTitle("Without Role (filtered)"); others:SetLayout("Flow"); others:SetFullWidth(true); scroll:AddChild(others)

  local totalRendered = 0
  totalRendered = totalRendered + renderSection(others, "Group Online", listGroupOnline)
  if totalRendered < maxRows then totalRendered = totalRendered + renderSection(others, "Group Offline", listGroupOffline) end
  if totalRendered < maxRows then
    local remaining = maxRows - totalRendered
    -- Temporär reduziere maxRows für die letzte Sektion
    local prevMax = maxRows; maxRows = remaining
    totalRendered = totalRendered + renderSection(others, "Not In Group", listOthers)
    maxRows = prevMax
  end
end

-- ==============================
-- Whisper Log Viewer (read-only)
-- ==============================
local function showWhisperDetail(name)
  local store = ensureWhisperStore()
  local frame = AceGUI:Create("Window")
  frame:SetTitle("Whisper Log: "..name)
  frame:SetLayout("Fill")
  frame:SetWidth(560); frame:SetHeight(520)
  frame:SetCallback("OnClose", function(w) AceGUI:Release(w) end)

  local box = AceGUI:Create("ScrollFrame"); box:SetLayout("List"); frame:AddChild(box)
  local arr = store[name] or {}
  local start = math.max(1, #arr - WHISPER_MAX_KEEP + 1)
  for i=start,#arr do
    local m = arr[i]
    local ts = date("%Y-%m-%d %H:%M:%S", m.time or GetServerTime())
    local arrow = (m.dir=="in" and ">>") or (m.dir=="out" and "<<") or "--"
    local line = AceGUI:Create("Label")
    line:SetText(string.format("[%s] %s %s", ts, arrow, m.text or "")); line:SetFullWidth(true)
    box:AddChild(line)
  end
end

-- Helper: open AceGUI Window at cursor pos
local function openAtCursor(win)
  if not win or not win.frame then return end
  local f = win.frame
  -- Ensure the context window is always on top and clickable
  if f.SetToplevel then f:SetToplevel(true) end
  if f.SetFrameStrata then f:SetFrameStrata("TOOLTIP") end
  if f.Raise then f:Raise() end
  f:ClearAllPoints()
  local x, y = GetCursorPosition()
  local scale = UIParent:GetEffectiveScale()
  f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x/scale, y/scale)
end

-- Global role assignment helper so UI code can call it anywhere
function MyRaidAddon:AssignRoleAndPersist(name, roleKey)
  if not name or not roleKey then return end
  removeFromAllActiveLists(name)
  if roleKey=="tank" then table.insert(activeTank, name)
  elseif roleKey=="healer" then table.insert(activeHealer, name)
  elseif roleKey=="range" then table.insert(activeRange, name)
  elseif roleKey=="melee" then table.insert(activeMelee, name) end
  InviteIfNotExcluded(name)
  self:AddToInvitedPlayers(name, roleKey, isPlayerInGroup(name) and "active" or "invited")
  PersistActiveRoles()
  updatePlayersWithoutRole(); updatePlayerStatuses()
  if self.UpdateRoleManagementPage then self:UpdateRoleManagementPage() end
  if RebuildActiveTab then RebuildActiveTab() end
end

-- Lightweight dropdown helpers (Blizzard UIDropDown/EasyMenu)
local function ensureDropdownFrame()
  if not MyRaidAddon._dropdownFrame then
    MyRaidAddon._dropdownFrame = CreateFrame("Frame", "LFMManagerContextMenu", UIParent, "UIDropDownMenuTemplate")
    MyRaidAddon._dropdownFrame:HookScript("OnHide", function()
      MyRaidAddon._easyMenuShown = false
      MyRaidAddon._menuAnchorWidget = nil
    end)
  end
  return MyRaidAddon._dropdownFrame
end

-- Simple fallback dropdown if EasyMenu is unavailable
local function ensureMenuCatcher()
  if not MyRaidAddon._menuCatcher then
    local c = CreateFrame("Frame", "LFMManagerMenuCatcher", UIParent)
    c:Hide()
    c:SetAllPoints(UIParent)
    c:EnableMouse(true)
    c:SetFrameStrata("FULLSCREEN_DIALOG")
    c:SetFrameLevel(100)
    c:SetScript("OnMouseDown", function(self)
      local m = MyRaidAddon._simpleMenu
      if m then
        -- If the click is inside the menu or any of its children, ignore
        local focus = GetMouseFocus()
        while focus do
          if focus == m then return end
          focus = focus:GetParent()
        end
        m:Hide()
      end
      self:Hide()
    end)
    MyRaidAddon._menuCatcher = c
  end
  return MyRaidAddon._menuCatcher
end

local function buildSimpleDropdown(menuList, anchorFrame)
  local catcher = ensureMenuCatcher(); catcher:Show()
  if MyRaidAddon._simpleMenu then MyRaidAddon._simpleMenu:Hide() end
  -- Parent the menu to UIParent (not the catcher) so it stays above and clickable
  local f = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
  f:SetToplevel(true)
  f:SetFrameStrata("TOOLTIP")
  f:SetFrameLevel(10001)
  f:EnableMouse(true)
  f:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } })
  f:SetBackdropColor(0,0,0,0.9)
  f:EnableKeyboard(true)
  f:SetPropagateKeyboardInput(true)
  f:SetScript("OnKeyDown", function(self, key)
    if key == "ESCAPE" then self:Hide() end
  end)

  local items = {}
  for _,it in ipairs(menuList or {}) do
    if it.isTitle then
      table.insert(items, { text = it.text or "", isTitle = true })
    elseif it.hasArrow and type(it.menuList)=="table" then
      if it.text and it.text ~= "" then table.insert(items, { text = it.text, isTitle = true }) end
      for _,sub in ipairs(it.menuList) do
        table.insert(items, { text = sub.text, func = sub.func })
      end
    else
      table.insert(items, { text = it.text, func = it.func })
    end
  end

  local padding, rowH, width = 6, 18, 170
  local y = -padding
  f:SetScale(0.95)
  -- Title bar with close button (small X)
  if #items > 0 and items[1].isTitle then
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    title:SetPoint("TOPLEFT", f, "TOPLEFT", padding+2, y)
    title:SetText(items[1].text or "")
    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetSize(14,14)
    close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
    close:SetFrameLevel(f:GetFrameLevel()+15)
    close:SetScript("OnClick", function() f:Hide(); catcher:Hide() end)
    y = y - rowH
  end
  for _,it in ipairs(items) do
    if not it.isTitle then
      local text = it.text or ""
      local action = it.func
      local btn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
      btn:SetPoint("TOPLEFT", f, "TOPLEFT", padding, y)
      btn:SetSize(width - padding*2, rowH)
      btn:SetText(text)
      btn:RegisterForClicks("AnyUp")
      btn:SetFrameStrata("TOOLTIP")
      btn:SetFrameLevel(f:GetFrameLevel() + 10)
      btn:EnableMouse(true)
      btn:SetHitRectInsets(-2,-2,-2,-2)
      btn:SetScript("OnClick", function()
        if type(action)=="function" then action() end
        f:Hide(); catcher:Hide()
      end)
      y = y - (rowH + 2)
    end
  end

  local totalH = -y + padding
  f:SetSize(width, totalH)
  if anchorFrame and anchorFrame.GetCenter then
    f:ClearAllPoints(); f:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -2)
  else
    local x, ycur = GetCursorPosition(); local scale = UIParent:GetEffectiveScale()
    f:ClearAllPoints(); f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x/scale, ycur/scale)
  end
  f:SetScript("OnHide", function()
    catcher:Hide()
    if MyRaidAddon._simpleMenu == f then MyRaidAddon._simpleMenu = nil end
  end)
  f:Show()
  MyRaidAddon._simpleMenu = f
end

function openDropdownAt(anchorFrame, menuList)
  -- Toggle behavior: click again on same anchor closes the menu
  if MyRaidAddon._menuAnchorWidget and MyRaidAddon._menuAnchorWidget == anchorFrame then
    if MyRaidAddon._simpleMenu and MyRaidAddon._simpleMenu:IsShown() then
      MyRaidAddon._simpleMenu:Hide(); MyRaidAddon._menuAnchorWidget = nil; MyRaidAddon._easyMenuShown = false; return
    end
    if MyRaidAddon._easyMenuShown and CloseDropDownMenus then
      CloseDropDownMenus(); MyRaidAddon._menuAnchorWidget = nil; MyRaidAddon._easyMenuShown = false; return
    end
  end

  -- Close any existing before opening a new one
  if MyRaidAddon._simpleMenu and MyRaidAddon._simpleMenu:IsShown() then MyRaidAddon._simpleMenu:Hide() end
  if MyRaidAddon._easyMenuShown and CloseDropDownMenus then CloseDropDownMenus() end

  if type(EasyMenu) == "function" then
    local dd = ensureDropdownFrame()
    if not anchorFrame or not anchorFrame.GetCenter then
      EasyMenu(menuList, dd, "cursor", 0, 0, "MENU", true)
    else
      EasyMenu(menuList, dd, anchorFrame, 0, 0, "MENU", true)
    end
    MyRaidAddon._easyMenuShown = true
    MyRaidAddon._menuAnchorWidget = anchorFrame
  else
    MyRaidAddon._menuAnchorWidget = anchorFrame
    buildSimpleDropdown(menuList, anchorFrame)
  end
end

-- Close any open context menus (called on tab switch, etc.)
local function CloseContextMenus()
  if MyRaidAddon._simpleMenu and MyRaidAddon._simpleMenu:IsShown() then MyRaidAddon._simpleMenu:Hide() end
  if MyRaidAddon._easyMenuShown and CloseDropDownMenus then CloseDropDownMenus() end
  MyRaidAddon._menuAnchorWidget = nil
  MyRaidAddon._easyMenuShown = false
end

-- ==============================
-- History Context Menu (at cursor)
-- ==============================
local function showHistoryContext(name, anchorWidget)
  local store = ensureWhisperStore()
  local data  = MyRaidAddon.db.profile.invitedPlayers[name] or {}
  local function assignRoleDirect(roleKey)
    removeFromAllActiveLists(name)
    if roleKey=="tank" then table.insert(activeTank, name)
    elseif roleKey=="healer" then table.insert(activeHealer, name)
    elseif roleKey=="range" then table.insert(activeRange, name)
    elseif roleKey=="melee" then table.insert(activeMelee, name) end
    InviteIfNotExcluded(name)
    MyRaidAddon:AddToInvitedPlayers(name, roleKey, isPlayerInGroup(name) and "active" or "invited")
    PersistActiveRoles()
    updatePlayersWithoutRole(); updatePlayerStatuses(); if RebuildActiveTab then RebuildActiveTab() end
  end

  local menu = {
    { text = name, isTitle = true, notCheckable = true },
    { text = "Assign Role...", notCheckable = true, func = function() MyRaidAddon:OpenAssignWindow(name, anchorWidget and anchorWidget.frame) end },





    { text = "/who Player", notCheckable = true, func = function() doWhoQuery(name) end },
    { text = "Whisper",      notCheckable = true, func = function() if ChatFrame_OpenChat then ChatFrame_OpenChat("/w "..name.." ") end end },
    { text = "Invite",       notCheckable = true, func = function() InviteIfNotExcluded(name); MyRaidAddon:AddToInvitedPlayers(name, data.lastRole, "invited"); updatePlayerStatuses(); if RebuildActiveTab then RebuildActiveTab() end end },
    { text = "Remove from Group", notCheckable = true, func = function() if UninviteUnit then UninviteUnit(name) end; updatePlayerStatuses(); if RebuildActiveTab then RebuildActiveTab() end end },
    { text = "Exclude Player",    notCheckable = true, func = function() MyRaidAddon.db.profile.invitedPlayers[name] = MyRaidAddon.db.profile.invitedPlayers[name] or {}; MyRaidAddon.db.profile.invitedPlayers[name].status = "Excluded"; removeFromAllActiveLists(name); updatePlayersWithoutRole(); updatePlayerStatuses(); if RebuildActiveTab then RebuildActiveTab() end end },
    { text = "Refresh ilvl",      notCheckable = true, func = function() local unitMatch; for unit in IterateGroup() do local unitName = GetUnitName(unit, true); if unitName and getFullPlayerName(unitName) == name then unitMatch = unit; break end end; if unitMatch then queueInspect(unitMatch); print("|cff33ff99[LFM]|r Inspect queued for "..name) else print("|cffffaa00[LFM]|r "..name.." is not currently in your group for inspection.") end end },
    { text = "Open Whisper Log", notCheckable = true, func = function() showWhisperDetail(name) end },
    { text = "Clear Chat Log",  notCheckable = true, func = function() if store[name] then store[name] = {} end; if RebuildActiveTab then RebuildActiveTab() end end },
    { text = "Remove from DB",  notCheckable = true, func = function() MyRaidAddon.db.profile.invitedPlayers[name] = nil; removeFromAllActiveLists(name); updatePlayersWithoutRole(); updatePlayerStatuses(); if RebuildActiveTab then RebuildActiveTab() end end },
  }
  local anchor = anchorWidget and anchorWidget.frame or nil
  openDropdownAt(anchor, menu)
end

-- ==============================
-- Tabs: History
-- ==============================
local function buildHistoryTab(container)
  container:ReleaseChildren()
  local root = AceGUI:Create("SimpleGroup"); root:SetLayout("Flow"); root:SetFullWidth(true); root:SetFullHeight(true); container:AddChild(root)

  -- Top: scrollable table (height adjusted responsively)
  local scroll = AceGUI:Create("ScrollFrame"); scroll:SetLayout("Flow"); scroll:SetFullWidth(true); scroll:SetHeight(420); root:AddChild(scroll)

  local db = MyRaidAddon.db.profile.invitedPlayers
  local store = ensureWhisperStore()

  local header = AceGUI:Create("SimpleGroup"); header:SetFullWidth(true); header:SetLayout("Flow"); scroll:AddChild(header)
  -- Sorting state defaults
  MyRaidAddon.db.profile.historySortKey = MyRaidAddon.db.profile.historySortKey or "last"
  if MyRaidAddon.db.profile.historySortAsc == nil then MyRaidAddon.db.profile.historySortAsc = false end
  local curKey  = MyRaidAddon.db.profile.historySortKey
  local curAsc  = MyRaidAddon.db.profile.historySortAsc and true or false
  local function addHeader(label, rel, key)
    local txt = label
    if key and key == curKey then txt = label .. (curAsc and " ?" or " ?") end
    local w = AceGUI:Create("InteractiveLabel"); w:SetText(txt); w:SetRelativeWidth(rel)
    if key then
      w:SetCallback("OnClick", function()
        if MyRaidAddon.db.profile.historySortKey == key then
          MyRaidAddon.db.profile.historySortAsc = not MyRaidAddon.db.profile.historySortAsc
        else
          MyRaidAddon.db.profile.historySortKey = key
          -- Default for new key: by last date desc, others asc
          MyRaidAddon.db.profile.historySortAsc = (key ~= "last")
        end
        RebuildActiveTab()
      end)
    end
    header:AddChild(w)
  end
  addHeader("Name", 0.28, "name")
  addHeader("Last Role", 0.1, "role")
  addHeader("ilvl", 0.08, "ilvl")
  addHeader("Status", 0.18, "status")
  addHeader("#Msgs", 0.08, "msgs")
  addHeader("Last Whisper", 0.20, "last")
  addHeader(" ", 0.08, nil)

  -- Bottom: persistent, read-only whisper viewer (scrollable list)
  local viewBox = AceGUI:Create("InlineGroup"); viewBox:SetTitle("Whisper Text"); viewBox:SetFullWidth(true); viewBox:SetHeight(130); viewBox:SetLayout("Fill"); root:AddChild(viewBox)
  local viewScroll = AceGUI:Create("ScrollFrame"); viewScroll:SetLayout("List"); viewBox:AddChild(viewScroll)

  local function updateViewer(name)
    local msgs = store[name] or {}
    viewBox:SetTitle("Whisper Text: "..name)
    viewScroll:ReleaseChildren()
    if #msgs == 0 then
      local none = AceGUI:Create("Label"); none:SetText("(no messages)"); none:SetFullWidth(true); viewScroll:AddChild(none)
      return
    end
    for i=1,#msgs do
      local m = msgs[i]
      local ts = date("%Y-%m-%d %H:%M:%S", m.time or GetServerTime())
      local arrow = (m.dir=="in" and ">>") or (m.dir=="out" and "<<") or "--"
      local line = AceGUI:Create("Label")
      line:SetText(string.format("[%s] %s %s", ts, arrow, m.text or ""))
      line:SetFullWidth(true)
      viewScroll:AddChild(line)
    end
  end

  -- Keep references for responsive resize adjustments
  MyRaidAddon._historyScroll = scroll
  MyRaidAddon._historyViewBox = viewBox
  if MyRaidAddon.AdjustHistoryHeights then MyRaidAddon:AdjustHistoryHeights() end

  -- Build sortable entries list
  local keysMap = {}
  for k,_ in pairs(db) do keysMap[k]=true end
  for k,_ in pairs(store) do keysMap[k]=true end
  local entries = {}
  for name,_ in pairs(keysMap) do
    local data = db[name] or {}
    local msgs = store[name] or {}
    local lastTsNum = 0
    if #msgs > 0 and msgs[#msgs].time then lastTsNum = msgs[#msgs].time end
    table.insert(entries, {
      name = name,
      role = data.lastRole or "",
      ilvl = tonumber(data.ilvl) or 0,
      status = data.status or "",
      msgs = #msgs,
      last = lastTsNum,
    })
  end
  local key = MyRaidAddon.db.profile.historySortKey or "last"
  local asc = MyRaidAddon.db.profile.historySortAsc and true or false
  table.sort(entries, function(a,b)
    local va, vb
    if key == "name" then va, vb = a.name, b.name
    elseif key == "role" then va, vb = a.role, b.role
    elseif key == "ilvl" then va, vb = a.ilvl, b.ilvl
    elseif key == "status" then va, vb = a.status, b.status
    elseif key == "msgs" then va, vb = a.msgs, b.msgs
    else va, vb = a.last, b.last end
    if va == vb then return a.name < b.name end
    if asc then return va < vb else return va > vb end
  end)

  if #entries==0 then
    local none = AceGUI:Create("Label"); none:SetText("No history yet."); none:SetFullWidth(true); scroll:AddChild(none)
    return
  end

  for _, e in ipairs(entries) do
    local name = e.name
    local data = db[name] or {}
    local msgs = store[name] or {}
    local lastTs = (e.last and e.last>0) and date("%Y-%m-%d %H:%M:%S", e.last) or "-"

    local row = AceGUI:Create("SimpleGroup"); row:SetFullWidth(true); row:SetLayout("Flow"); scroll:AddChild(row)
    local display = "|c"..getClassColorCode(name)..name.."|r"

    local nL = AceGUI:Create("InteractiveLabel"); nL:SetText(display); nL:SetRelativeWidth(0.28)
    nL:SetCallback("OnClick", function(widget, _, button)
      if button=="RightButton" then
        showHistoryContext(name, widget)
      elseif IsShiftKeyDown() then
        doWhoQuery(name)
      else
        updateViewer(name)
      end
    end); row:AddChild(nL)
    local rL = AceGUI:Create("Label"); rL:SetText(data.lastRole or ""); rL:SetRelativeWidth(0.1); row:AddChild(rL)
    local iL = AceGUI:Create("Label"); iL:SetText(data.ilvl or "");    iL:SetRelativeWidth(0.08); row:AddChild(iL)
    local sL = AceGUI:Create("Label"); sL:SetText(data.status or "");  sL:SetRelativeWidth(0.18); row:AddChild(sL)
    local cL = AceGUI:Create("Label"); cL:SetText(tostring(#msgs));    cL:SetRelativeWidth(0.08); row:AddChild(cL)
    local tL = AceGUI:Create("Label"); tL:SetText(lastTs);             tL:SetRelativeWidth(0.20); row:AddChild(tL)

    -- smaller, stable options control on the right
    local opt = AceGUI:Create("InteractiveLabel")
    opt:SetText("|cffbbbbbb...|r")
    opt:SetRelativeWidth(0.06)
    if opt.SetJustifyH then opt:SetJustifyH("RIGHT") end
    opt:SetCallback("OnClick", function(widget) showHistoryContext(name, widget) end)
    opt:SetCallback("OnEnter", function(widget)
      GameTooltip:SetOwner(widget.frame, "ANCHOR_RIGHT")
      GameTooltip:SetText("Options", 1,1,1)
      GameTooltip:Show()
    end)
    opt:SetCallback("OnLeave", function()
      GameTooltip:Hide()
    end)
    row:AddChild(opt)
  end
end

-- ==============================
-- Tabs: Excluded
-- ==============================
local function showExcludedOptions(name)
  local data = MyRaidAddon.db.profile.invitedPlayers[name]
  local frame = AceGUI:Create("Window")
  frame:SetTitle("Excluded Player")
  frame:SetLayout("List")
  frame:SetWidth(360); frame:SetHeight(320)
  frame:SetCallback("OnClose", function(w) AceGUI:Release(w) end)

  local info = AceGUI:Create("Label")
  info:SetFullWidth(true)
  local ilvl = data and (data.ilvl or "-") or "-"
  local lastRole = data and (data.lastRole or "-") or "-"
  info:SetText(string.format("%s\nLast Role: %s\nilvl: %s\nStatus: Excluded", name, lastRole, ilvl))
  frame:AddChild(info)

  local viewChat = AceGUI:Create("Button"); viewChat:SetText("View Whisper Log"); viewChat:SetWidth(200)
  viewChat:SetCallback("OnClick", function() frame:Hide(); showWhisperDetail(name) end)
  frame:AddChild(viewChat)

  local removeEx = AceGUI:Create("Button"); removeEx:SetText("Remove Exclusion"); removeEx:SetWidth(200)
  removeEx:SetCallback("OnClick", function()
    if data then data.status = "request" end
    updatePlayersWithoutRole(); updatePlayerStatuses()
    frame:Hide(); RebuildActiveTab()
  end)
  frame:AddChild(removeEx)

  local purge = AceGUI:Create("Button"); purge:SetText("Delete From DB"); purge:SetWidth(200)
  purge:SetCallback("OnClick", function()
    MyRaidAddon.db.profile.invitedPlayers[name] = nil
    frame:Hide(); RebuildActiveTab()
  end)
  frame:AddChild(purge)
end

local function buildExcludedTab(container)
  container:ReleaseChildren()
  local scroll = AceGUI:Create("ScrollFrame"); scroll:SetLayout("Flow"); scroll:SetFullWidth(true); scroll:SetFullHeight(true); container:AddChild(scroll)

  local db = MyRaidAddon.db.profile.invitedPlayers
  local header = AceGUI:Create("SimpleGroup"); header:SetFullWidth(true); header:SetLayout("Flow"); scroll:AddChild(header)
  local function H(t,rel) local l=AceGUI:Create("Label"); l:SetText(t); l:SetRelativeWidth(rel); header:AddChild(l) end
  H("Name",0.4); H("Last Role",0.2); H("ilvl",0.15); H("Status",0.15); H("Actions",0.1)

  local keys = {}
  for k,v in pairs(db) do if v and v.status == "Excluded" then table.insert(keys, k) end end
  table.sort(keys)

  for _, name in ipairs(keys) do
    local data = db[name]
    local row = AceGUI:Create("SimpleGroup"); row:SetFullWidth(true); row:SetLayout("Flow"); scroll:AddChild(row)
    local display = "|c"..getClassColorCode(name)..name.."|r"
    local nL = AceGUI:Create("InteractiveLabel"); nL:SetText(display); nL:SetRelativeWidth(0.4); row:AddChild(nL)
    nL:SetCallback("OnClick", function(_, _, button)
      if IsShiftKeyDown() then
        doWhoQuery(name)
      else
        showExcludedOptions(name)
      end
    end)
    local rL = AceGUI:Create("Label"); rL:SetText(data.lastRole or ""); rL:SetRelativeWidth(0.2); row:AddChild(rL)
    local iL = AceGUI:Create("Label"); iL:SetText(data.ilvl or "");    iL:SetRelativeWidth(0.15);  row:AddChild(iL)
    local sL = AceGUI:Create("Label"); sL:SetText("Excluded");         sL:SetRelativeWidth(0.15);  row:AddChild(sL)
    local opt = AceGUI:Create("Button"); opt:SetText("Options"); opt:SetRelativeWidth(0.1); opt:SetCallback("OnClick", function() showExcludedOptions(name) end); row:AddChild(opt)
  end

  if #keys==0 then
    local none = AceGUI:Create("Label"); none:SetText("No excluded players."); none:SetFullWidth(true); scroll:AddChild(none)
  end
end

-- ==============================
-- Tabs: Whisper Rules (Editor & Test)
-- ==============================
local function buildRulesTab(container)
  container:ReleaseChildren()

  local wrap = AceGUI:Create("ScrollFrame"); wrap:SetLayout("Flow"); wrap:SetFullWidth(true); wrap:SetFullHeight(true)
  container:AddChild(wrap)

  local info = AceGUI:Create("Label"); info:SetFullWidth(true)
  info:SetText("|cff88ccffWhisper Rules|r — only active when |cff00ff00Auto Reply+Invite|r is enabled. Use '||' to provide multiple reply variants.")
  wrap:AddChild(info)

  local edit = AceGUI:Create("MultiLineEditBox")
  edit:SetLabel("Rules Text")
  edit:SetFullWidth(true); edit:SetNumLines(18)
  edit:SetText(MyRaidAddon.db.profile.aiRulesText or DEFAULT_AI_TEXT)
  wrap:AddChild(edit)

  local status = AceGUI:Create("Label"); status:SetFullWidth(true); status:SetText(""); wrap:AddChild(status)

  local btnRow = AceGUI:Create("SimpleGroup"); btnRow:SetLayout("Flow"); btnRow:SetFullWidth(true); wrap:AddChild(btnRow)

  local saveBtn = AceGUI:Create("Button"); saveBtn:SetText("Save & Parse"); saveBtn:SetWidth(140)
  saveBtn:SetCallback("OnClick", function()
    local txt = edit:GetText() or ""
    MyRaidAddon.db.profile.aiRulesText = txt
    local ok, parsed = pcall(parseAIRules, txt)
    if ok then
      MyRaidAddon.db.profile.aiRulesParsed = parsed
      status:SetText("|cff55ff55Parsed "..tostring(#parsed).." rules.|r")
    else
      status:SetText("|cffff5555Parse error:|r "..tostring(parsed))
    end
  end)
  btnRow:AddChild(saveBtn)

  local resetBtn = AceGUI:Create("Button"); resetBtn:SetText("Reset to Default"); resetBtn:SetWidth(160)
  resetBtn:SetCallback("OnClick", function()
    edit:SetText(DEFAULT_AI_TEXT)
    status:SetText("|cffffcc00Reset to defaults (not saved yet).|r")
  end)
  btnRow:AddChild(resetBtn)

  local testBox = AceGUI:Create("EditBox"); testBox:SetLabel("Test Message"); testBox:SetFullWidth(true); testBox:SetText("")
  wrap:AddChild(testBox)

  local testOut = AceGUI:Create("Label"); testOut:SetFullWidth(true); wrap:AddChild(testOut)

  local testBtn = AceGUI:Create("Button"); testBtn:SetText("Run Test"); testBtn:SetWidth(120)
  testBtn:SetCallback("OnClick", function()
    local msg = testBox:GetText() or ""
    local rule = evaluateAIRules(msg)
    if rule then
      local rep = pickReply(rule) or "-"
      local parts = {
        "match="..(rule.match or "any"),
        "role="..(rule.role or "-"),
        "invite="..tostring(rule.invite),
        "excludePlayer="..tostring(rule.excludePlayer),
        "offtopic="..tostring(rule.offtopic),
        "stop="..tostring(rule.stop),
        "reply="..rep,
      }
      testOut:SetText("|cff55ff55Matched rule:|r "..table.concat(parts, " | "))
    else
      testOut:SetText("|cffffaa00No rule matched.|r")
    end
  end)
  wrap:AddChild(testBtn)
end

-- ==============================
-- Tabs: Sort Rules (Editor)
-- ==============================
local function buildSortRulesTab(container)
  container:ReleaseChildren()

  local wrap = AceGUI:Create("ScrollFrame"); wrap:SetLayout("Flow"); wrap:SetFullWidth(true); wrap:SetFullHeight(true)
  container:AddChild(wrap)

  local info = AceGUI:Create("Label"); info:SetFullWidth(true)
  info:SetText("|cff88ccffSort Rules+|r — define class/role quotas with operators (>=, <=, >, <, =, !=) and hints: 'avoid X', 'require Y', 'wants=Tag', 'prefer=A,B,C'. You can add 'Global=' lines.")
  wrap:AddChild(info)

  local edit = AceGUI:Create("MultiLineEditBox")
  edit:SetLabel("Sort Rules Text")
  edit:SetFullWidth(true); edit:SetNumLines(18)
  edit:SetText(MyRaidAddon.db.profile.sortRulesText or DEFAULT_SORT_TEXT)
  wrap:AddChild(edit)

  local status = AceGUI:Create("Label"); status:SetFullWidth(true); status:SetText(""); wrap:AddChild(status)

  local btnRow = AceGUI:Create("SimpleGroup"); btnRow:SetLayout("Flow"); btnRow:SetFullWidth(true); wrap:AddChild(btnRow)

  local saveBtn = AceGUI:Create("Button"); saveBtn:SetText("Save"); saveBtn:SetWidth(120)
  saveBtn:SetCallback("OnClick", function()
    local txt = edit:GetText() or ""
    MyRaidAddon.db.profile.sortRulesText = txt
    local ok, parsed, global = pcall(function() local g; local p; p,g = parseSortRules(txt); return p,g end)
    if ok then
      local p,g = parsed, global
      local cnt=0; for _ in pairs(p) do cnt=cnt+1 end
      status:SetText("|cff55ff55Saved. Parsed definitions for "..tostring(cnt).." group(s).|r")
    else
      status:SetText("|cffff5555Parse error:|r "..tostring(parsed))
    end
  end)
  btnRow:AddChild(saveBtn)

  local resetBtn = AceGUI:Create("Button"); resetBtn:SetText("Reset to Default"); resetBtn:SetWidth(160)
  resetBtn:SetCallback("OnClick", function()
    edit:SetText(DEFAULT_SORT_TEXT)
    status:SetText("|cffffcc00Reset to defaults (not saved yet).|r")
  end)
  btnRow:AddChild(resetBtn)

  local runBtn = AceGUI:Create("Button"); runBtn:SetText("Apply Now"); runBtn:SetWidth(120)
  runBtn:SetCallback("OnClick", function() applySortRules() end)
  btnRow:AddChild(runBtn)
end

-- ==============================
-- Tab Container / Dispatcher
-- ==============================
local tabs = {
  {text="Main",          value="main"},
  {text="Roles",         value="roles"},
  {text="Excluded",      value="excluded"},
  {text="History",       value="history"},
  {text="Whisper Rules", value="rules"},
  {text="Sort Rules",    value="sortrules"},
}

local function SelectTab(container, _, group)
  if CloseContextMenus then CloseContextMenus() end
  container:ReleaseChildren()
  if     group=="main"     then buildMainTab(container)
  elseif group=="roles"    then buildRolesTab(container)
  elseif group=="history"  then buildHistoryTab(container)
  elseif group=="excluded" then buildExcludedTab(container)
  elseif group=="rules"    then buildRulesTab(container)
  elseif group=="sortrules"then buildSortRulesTab(container)
  else buildMainTab(container) end
end

-- Adjust the split between the history table (top) and the whisper viewer (bottom)
function MyRaidAddon:AdjustHistoryHeights()
  if not tabGroup or not tabGroup.GetSelected or tabGroup:GetSelected() ~= "history" then return end
  local scroll = self._historyScroll
  local view   = self._historyViewBox
  if not scroll or not view then return end
  local parentH = (tabGroup and tabGroup.frame and tabGroup.frame:GetHeight()) or (mainFrame and mainFrame.frame and mainFrame.frame:GetHeight()) or 700
  local topH = math.floor(parentH * 0.58)
  local botH = math.floor(parentH * 0.26)
  if topH < 160 then topH = 160 end
  if botH < 100 then botH = 100 end
  scroll:SetHeight(topH)
  view:SetHeight(botH)
end

function MyRaidAddon:CreateMainWindow()
  if mainFrame and not mainFrame.frame then mainFrame = nil; tabGroup = nil end
  if not mainFrame then
    mainFrame = AceGUI:Create("Frame")
    mainFrame:SetTitle("LFM-Manager")
    mainFrame:SetStatusText("")
    mainFrame:SetWidth(860)
    mainFrame:SetHeight(700)
    mainFrame:SetLayout("Fill")
    mainFrame:SetCallback("OnClose", function(widget)
      if uiStatusTickerTimer then MyRaidAddon:CancelTimer(uiStatusTickerTimer, true); uiStatusTickerTimer = nil end
      AceGUI:Release(widget); mainFrame = nil; tabGroup = nil
    end)
    -- Hook window resize to keep history pane responsive
    local f = mainFrame.frame
    if f and f.GetScript then
      local prev = f:GetScript("OnSizeChanged")
      f:SetScript("OnSizeChanged", function(frame, ...)
        if type(prev) == "function" then prev(frame, ...) end
        if MyRaidAddon and MyRaidAddon.AdjustHistoryHeights then MyRaidAddon:AdjustHistoryHeights() end
      end)
    end
  end
  mainFrame:Show()
  mainFrame:ReleaseChildren()

  tabGroup = AceGUI:Create("TabGroup")
  tabGroup:SetLayout("Fill")
  tabGroup:SetTabs(tabs)
  tabGroup:SetFullWidth(true)
  tabGroup:SetFullHeight(true)
  tabGroup:SetCallback("OnGroupSelected", SelectTab)
  mainFrame:AddChild(tabGroup)

  tabGroup:SelectTab("main")

  -- 1-second status updater (progress + auto post countdown)
  if uiStatusTickerTimer then MyRaidAddon:CancelTimer(uiStatusTickerTimer, true); uiStatusTickerTimer = nil end
  if MyRaidAddon and MyRaidAddon.UpdateStatusBar then
    MyRaidAddon:UpdateStatusBar()
    uiStatusTickerTimer = MyRaidAddon:ScheduleRepeatingTimer(function() MyRaidAddon:UpdateStatusBar() end, 1.0)
  end
end

-- ==============================
-- Events (roster & inspect pump)
-- ==============================
local function onRosterUpdate()
  -- Baue Lookup für aktuelle Gruppenzugehörigkeit und Online-Status
  local unitByName, isOnline = {}, {}
  for unit in IterateGroup() do
    local nm = GetUnitName(unit, true)
    if nm then
      nm = getFullPlayerName(nm)
      unitByName[nm] = unit
      isOnline[nm] = UnitIsConnected(unit) and true or false
    end
  end

  -- 1) Spieler aus aktiven Rollen entfernen, wenn offline oder nicht (mehr) in der Gruppe
  local currentlyActive = {}
  for _,n in ipairs(activeTank)   do currentlyActive[n] = true end
  for _,n in ipairs(activeHealer) do currentlyActive[n] = true end
  for _,n in ipairs(activeRange)  do currentlyActive[n] = true end
  for _,n in ipairs(activeMelee)  do currentlyActive[n] = true end

  for name,_ in pairs(currentlyActive) do
    local unit = unitByName[name]
    local online = unit and isOnline[name]
    if (not unit) or (online == false) then
      removeFromActiveListsKeepAssignment(name)
      -- Status setzen: offline falls in Gruppe aber offline, sonst eingeladen
      if unit and online == false then
        MyRaidAddon:AddToInvitedPlayers(name, nil, "offline")
      else
        MyRaidAddon:AddToInvitedPlayers(name, nil, "invited")
      end
    end
  end

  -- 2) Zurück in aktive Rollen nehmen, wenn (wieder) in Gruppe und online, basierend auf gespeicherter Rolle
  local ra = MyRaidAddon.db.profile.roleAssignments or {}
  for name, unit in pairs(unitByName) do
    if isOnline[name] and not inAnyActiveList(name) then
      local role = ra[name]
      if role and canAddToRole(role) then
        PersistAddToActive(role, name)
        MyRaidAddon:AddToInvitedPlayers(name, role, "active")
      end
    end
  end

  -- 3) Nacharbeiten: Status, Listen und UI
  updatePlayersWithoutRole()
  updatePlayerStatuses()
  for unit in IterateGroup() do queueInspect(unit) end
  -- Gruppe automatisch in Raid/Party konvertieren je nach Größe
  local num = (GetNumGroupMembers and GetNumGroupMembers()) or 0
  local inRaid = IsInRaid and IsInRaid() or false
  local function isLeader()
    if UnitIsGroupLeader and UnitIsGroupLeader("player") then return true end
    if IsPartyLeader and IsPartyLeader() then return true end
    if IsRaidLeader and IsRaidLeader() then return true end
    if (IsInGroup and not IsInGroup()) or (not GetNumGroupMembers or num==0) then return true end
    return false
  end
  if not inRaid and num > 5 and ConvertToRaid and isLeader() then
    ConvertToRaid()
    print("|cff55ff55[LFM]|r Auto-converted to Raid (group size > 5)")
  elseif inRaid and num <= 5 and ConvertToParty and isLeader() then
    ConvertToParty()
    print("|cff55ff55[LFM]|r Auto-converted to Party (group size <= 5)")
  end
  if tabGroup and tabGroup.GetSelected then
    local sel = tabGroup:GetSelected()
    if sel=="roles" or sel=="history" or sel=="excluded" then RebuildActiveTab() end
  end
end

-- ==============================
-- Initialize / Slash
-- ==============================
function MyRaidAddon:OnInitialize()
  print("|cffa0ff00LFM-Manager: OnInitialize()|r")
  self.db = AceDB:New("MyRaidAddonDB", {
    profile = {
      autoReplyInviteEnabled = false,
      lfmAutoPostEnabled = false,
      lfmAutoPostInterval = 120,
      raidConfig        = raidConfig,
      selectedChannels  = {},
      invitedPlayers    = {},
      selectedRaid      = selectedRaid,
      whisperHistory    = {},
      aiRulesText       = DEFAULT_AI_TEXT,
      aiRulesParsed     = nil,
      sortRulesText     = DEFAULT_SORT_TEXT,
      activeRoles       = { tank={}, healer={}, range={}, melee={} },
      roleAssignments   = {},
      historySortKey    = "last",
      historySortAsc    = false,
      srLink            = "",
      discordLink       = "",
      raidWarnEnabled   = false,
    },
  }, true)

  -- sane defaults / refs
  self.db.profile.invitedPlayers   = self.db.profile.invitedPlayers   or {}
  self.db.profile.whisperHistory   = self.db.profile.whisperHistory   or {}
  self.db.profile.selectedChannels = self.db.profile.selectedChannels or {}
  self.db.profile.activeRoles      = self.db.profile.activeRoles      or { tank={}, healer={}, range={}, melee={} }
  self.db.profile.roleAssignments  = self.db.profile.roleAssignments  or {}
  if type(self.db.profile.lfmAutoPostEnabled) ~= "boolean" then self.db.profile.lfmAutoPostEnabled = false end
  if type(self.db.profile.lfmAutoPostInterval) ~= "number" then self.db.profile.lfmAutoPostInterval = 120 end

  autoReplyInviteEnabled = self.db.profile.autoReplyInviteEnabled or false
  selectedRaid      = self.db.profile.selectedRaid or selectedRaid
  raidConfig        = self.db.profile.raidConfig or raidConfig
  selectedChannels  = self.db.profile.selectedChannels or {}

  if type(self.db.profile.aiRulesText) ~= "string" or self.db.profile.aiRulesText == "" then
    self.db.profile.aiRulesText = DEFAULT_AI_TEXT
  end
  self.db.profile.aiRulesParsed = parseAIRules(self.db.profile.aiRulesText)

  if type(self.db.profile.sortRulesText) ~= "string" or self.db.profile.sortRulesText == "" then
    self.db.profile.sortRulesText = DEFAULT_SORT_TEXT
  end

  -- Lade persistente Rollen in die Runtime-Listen
  LoadActiveRolesFromDB()
  -- (Falls roleAssignments leer war, fülle aus activeRoles)
  for _,n in ipairs(activeTank)   do self.db.profile.roleAssignments[n]="tank" end
  for _,n in ipairs(activeHealer) do self.db.profile.roleAssignments[n]="healer" end
  for _,n in ipairs(activeRange)  do self.db.profile.roleAssignments[n]="range" end
  for _,n in ipairs(activeMelee)  do self.db.profile.roleAssignments[n]="melee" end

  self:RegisterChatCommand("myraidaddon", "CreateMainWindow")
  self:RegisterChatCommand("lfm", function() postRaid(selectedRaid) end)

  -- Events
  self:RegisterEvent("CHAT_MSG_WHISPER", onWhisper)
  self:RegisterEvent("CHAT_MSG_WHISPER_INFORM", onWhisperOut)
  self:RegisterEvent("GROUP_ROSTER_UPDATE", onRosterUpdate)
  self:RegisterEvent("PLAYER_ENTERING_WORLD", onRosterUpdate)
  self:RegisterEvent("INSPECT_READY", onInspectReady)
  -- Reagiere auch auf Online/Offline Wechsel von Gruppeneinheiten
  self:RegisterEvent("UNIT_CONNECTION", function() onRosterUpdate() end)

  -- Inspect Pumpe
  self:ScheduleRepeatingTimer(function() pumpInspect() end, 0.8)

  -- Auto-Post LFM removed (no scheduled posting)

  -- Minimap Button (optional)
  local okLDB, LDBObj = pcall(LibStub, "LibDataBroker-1.1")
  if okLDB and LDBObj and LDBObj.NewDataObject then
    local LDB = LDBObj:NewDataObject("LFM-Manager", {
      type = "launcher",
      text = "LFM-Manager",
      icon = "Interface\\AddOns\\LFM-Manager\\lib\\Icon\\Logo.png",
      OnClick = function(_, button) if button=="LeftButton" then MyRaidAddon:CreateMainWindow() end end,
      OnTooltipShow = function(tt) tt:AddLine("LFM-Manager"); tt:AddLine("Left-click to open the addon.") end,
    })
    local okIcon, LibDBIcon = pcall(LibStub, "LibDBIcon-1.0")
    if okIcon and LibDBIcon and LibDBIcon.Register then
      LibDBIcon:Register("LFM-Manager", LDB, {})
    end
  end
end

-- override stub
function MyRaidAddon:UpdateRoleManagementPage()
  if tabGroup and tabGroup.GetSelected and tabGroup:GetSelected() == "roles" then
    RebuildActiveTab()
  end
end











