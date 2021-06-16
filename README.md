# ilore

Intuitive item lore

## Setup

Install with [dzp](https://github.com/acikek/dzp):
```sh
dzp install https://github.com/acikek/ilore
```

Install with git:
```sh
git clone https://github.com/acikek/ilore
```

## Config

The ilore system relies on the `ilore_config` script. The default config is already fleshed-out, but it's easy to create your own.

To get started, make a new `ilore_config` data script. Add a `tiers` map, with each rarity tier that items might have. Each key is a tier name, and its value is a color tag.

Then, add a `description` map. The `max_length` key represents the cutoff pixel length that lines should be separated by. The `color` key is a parsed color tag. Lastly, the `default` key represents the description if none is provided.

```yml
ilore_config:
  type: data
  description:
    max_length: 220
    color: <gray>
    default: No description
  tiers:
    common: <white>
    uncommon: <green>
    rare: <aqua>
    super rare: <light_purple>
    legendary: <gold>
```

Each extra section is auto-generated and dependent on the config script. The sections are under the `section` map. Each section should also be a map, with the key being the section ID (what the item should call upon).

Each section has a `type` and `name`. The type **is dependent** on end value's object type. For example, if there's a section in the item data that has a value of `hello world`, then its type would be `element`. Sections cannot have multiple types, and the type checking is strict.

The section `name` is what to display before the value. It can include color tags.

Each type represented in the sections must also have a format procedure script linked through the `format` key, it being a map with each key as the type name and its value as the script name. Each format procedure must take in `value` and `name` definitions, in that order.

> A drop-in ready config and linked type format procedures are bundled with the script.

## Example

The `ilore` flag of an item controls the ilore data. Only `description` and `tier` are required. Any other sections can be referenced directly inside the main flag map, with their corresponding value type.

```yml
wooden_bat:
  type: item
  material: wooden_sword
  display name: <yellow>Wooden Bat
  flags:
    ilore:
      # Element, displayed below the title
      description: A humble, solid bat.
      # Custom sections
      abilities:
      - Head-splitting swings
      - Dependable, and solid as a rock
      stats:
        Damage: 1,000,000+
        Durability: Unbreakable
      godlike: True
      # A key under 'tiers' in the config
      tier: legendary

# /ex give <item[wooden_bat].proc[ilore]>
```

![](https://media.discordapp.net/attachments/695402715534196787/853406409747202058/wooden_bat.png)

## Pre-processing

The `ilore` procedure usually takes a few milliseconds for the average item. With many items, this processing time can add up. For ease-of-access, the `ilore_save` task is provided within the main file. It applies ilore to the item and flags the result to the server under an `ilore_` prefix. 

Taking the example item above, one might have this setup:

```yml
item_config:
  type: data
  items:
  - wooden_bat
  # other items here...

item_load:
  type: task
  script:
  - foreach <script[item_config]> as:name:
    - run ilore_save def:<item[<[name]>]>

item_reload:
  type: world
  events:
    after server start:
    - run item_load
    after script reload:
    - run item_load

# <server.flag[ilore_wooden_bat]>
```

## Scripts

### Data
- `ilore_config`

### Procedure
- `ilore`
- `ilore_format_element`
- `ilore_format_list`
- `ilore_format_map`

### Task
- `ilore_save`

## License

MIT © 2021 Kyle Prince
