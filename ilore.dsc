#: dzp-ignore wooden_bat

#| ilore
#| Intuitive item lore
#|
#| @version 1.0.0
#| @author acikek


# The ilore config.
# @key {map} description: The description data.
# @key {number} description.max_length: The cutoff for description lines, in pixels.
# @key {color} description.color: The description text color.
# @key {element} description.default: The description message if none is provided.
# @key {map} format: The section format data, with each key being a type name and the value being a format procedure.
# @key {map} sections: The section data, with each key being a section name and the value being a map with a type and name.
# @key {map} tiers: The item tier data, with each key being a tier name and the value being a color.

ilore_config:
  type: data
  description:
    max_length: 220
    color: <gray>
    default: No description
  format:
    element: ilore_format_element
    list: ilore_format_list
    map: ilore_format_map
  sections:
    abilities:
      type: list
      name: <green>Abilities
    stats:
      type: map
      name: <aqua>Stats
    godlike:
      type: element
      name: <red>Godlike
  tiers:
    common: <white>
    uncommon: <green>
    rare: <aqua>
    super rare: <light_purple>
    legendary: <gold>


#| Format Scripts
#| Each is a procedure with definitions value and name.

ilore_format_element:
  type: procedure
  definitions: value|name
  script:
  - determine "<[name]><gray>: <white><[value]>"

ilore_format_list:
  type: procedure
  definitions: value|name
  script:
  - define lines "<[value].parse_tag[<dark_gray>- <gray><[parse_value]>]>"
  - determine <list[<[name]><gray>:].include[<[lines]>]>

ilore_format_map:
  type: procedure
  definitions: value|name
  script:
  - define lines "<[value].parse_value_tag[  <gray><[parse_key]>: <white><[parse_value]>].values>"
  - determine <list[<[name]><gray>:].include[<[lines]>]>


# Returns a new item with ilore data applied.
# Requires the item to have an 'ilore' flag. If not, returns the original item.
# @def {item} item: The item to apply lore to.
# @determine {item} The item with applied lore.
# @usage <item[my_item].proc[ilore]>
# @uses ilore_config

ilore:
  type: procedure
  definitions: item
  script:
  # Exit immediately if the item doesn't have the 'ilore' flag
  - if !<[item].has_flag[ilore]>:
    - determine <[item]>

  # Item data and config
  - define data <[item].flag[ilore]>
  - define config <script[ilore_config]>
  - define sep <list[<empty>|<empty>]>

  # Description constants
  - define description_data <[config].data_key[description]>
  - define desc_length <[description_data].get[max_length].if_null[220]>
  - define desc_color <[description_data].get[color].parsed.if_null[<gray>]>
  - define desc_default "<[description_data].get[default].if_null[No description]>"

  # Section constants
  - define types <[config].data_key[format]>

  # Splits the description element into lines based on the max pixel length in the config.
  - define description_lines <list[<[data].get[description].split_lines_by_width[<[desc_length]>].split[<n>].if_null[<[desc_default]>]>]>
  # Parses the description lines to be the desired color.
  - define description <[description_lines].parse_tag[<[desc_color]><[parse_value]>].include[<[sep]>]>

  #| This needs to be predefined as a list.
  #| The data action for appending to a list does not offer the same capabilities as ListTag.include.
  - define sections <list>

  # Section parsing
  - foreach <[config].data_key[sections]> key:name as:section:
    # Check if section exists in item data
    # No error should be thrown if it doesn't
    - if !<[data].contains[<[name]>]>:
      - foreach next

    - define true_type <[section].get[type].to_lowercase>

    # Check if config type is valid
    - if !<[types].keys.contains[<[true_type]>]>:
      - debug error "No valid type format for ilore section <aqua><[name]><&r> (<[true_type]>)"
      - foreach next

    - define script <[types].get[<[true_type]>]>

    # Check if script exists (no type validation)
    - if !<script[<[script]>].exists>:
      - debug error "Script <aqua><[script]><&r> does not exist"
      - foreach next

    - define section_data <[data].get[<[name]>]>
    - define section_type <[section_data].object_type.to_lowercase>

    # Check that the section types match
    - if <[section_type]> != <[true_type]>:
      - debug error "Item <aqua><[item].script.name><&r>'s ilore section <aqua><[name]><&r> is of type <[section_type]>, should be <[true_type]>"
      - foreach next

    - define name <white><[section].get[name].parsed.if_null[Section]>
    - define formatted <[section_data].proc[<[script]>].context[<[name]>]>

    #| See above comments
    - define sections <[sections].include[<[formatted]>].include[<[sep]>]>

  # Parse tier color from config
  - define tier_color <[config].data_key[tiers].get[<[data].get[tier].to_lowercase>].parsed.if_null[<white>]>
  # Assemble tier
  - define tier <&r><[tier_color]><bold><[data].get[tier].to_uppercase.if_null[COMMON]>

  # Construct lore list
  - define lore <[description].include[<[sections]>].include[<list[<[tier]>]>]>

  # Construct final item
  - determine <[item].with[lore=<[lore]>;hides=ATTRIBUTES]>


# Applies ilore to an item and saves it to the server's flags. Useful for preprocessing items.
# Flag syntax: `ilore_<item_script_name>`
# @def {item} item: The item to apply lore to.
# @usage Save to server$n- run ilore_save def:<item[my_item]>$n$nRetrieve item$n<server.flag[ilore_my_item]>
# @uses ilore

ilore_save:
  type: task
  definitions: item
  script:
  - define name <[item].script.name>

  - if !<[item].has_flag[ilore]>:
    - debug error "Item <aqua><[name]><&r> has no 'ilore' flag."
    - stop

  - define result <[item].proc[ilore]>
  - flag server ilore_<[name]>:<[result]>


#| EXAMPLE ITEM

wooden_bat:
  type: item
  material: wooden_sword
  display name: <yellow>Wooden Bat
  flags:
    ilore:
      description: A humble, solid bat.
      abilities:
      - Head-splitting swings
      - Dependable, and solid as a rock
      stats:
        Damage: 1,000,000+
        Durability: Unbreakable
      godlike: True
      tier: legendary