#: dzp-ignore wooden_bat

#| ilore
#| Intuitive item lore
#|
#| @version 1.0.0
#| @author acikek


ilore:
  type: procedure
  definitions: item
  script:
  - if !<[item].has_flag[ilore]>:
    - determine <[item]>

  # Item data and constants
  - define data <[item].flag[ilore]>
  - define sep <list[<empty>|<empty>]>

  # Description
  - define desc "<list[<[data].get[description].split_lines_by_width[220].split[<n>].if_null[No description]>].parse_tag[<gray><[parse_value]>]>"

  # Abilities list
  - define abilities "<[data].get[abilities].if_null[<list[None]>].parse_tag[<dark_gray>- <gray><[parse_value]>]>"
  - define a_header <&color[#FFC42E]>Abilities<gray><&co>

  # Rarity tier
  - define r_color <script[ilore_colors].data_key[<[data].get[rarity].to_lowercase>].parsed.if_null[<white>]>
  - define rarity <&r><[r_color]><bold><[data].get[rarity].to_uppercase.if_null[COMMON]>

  # Final item
  - determine <[item].with[lore=<list[<[desc]>|<[sep]>|<[a_header]>|<[abilities]>|<[sep]>|<[rarity]>].combine>;hides=ATTRIBUTES]>

ilore_colors:
  type: data
  common: <white>
  uncommon: <green>
  rare: <aqua>
  super rare: <light_purple>
  legendary: <gold>

wooden_bat:
  type: item
  material: wooden_sword
  display name: <red>Wooden Bat
  flags:
    ilore:
      description: A humble, solid bat.
      abilities:
      - Head-splitting swings
      - Dependable, and solid as a rock
      rarity: legendary