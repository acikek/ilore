# ilore

Intuitive item lore

## Setup

Install with [dzp](https://github.com/acikek/dzp):
```sh
dzp install <repository link>
```

Install with git:
```sh
git clone <repository link>
```

## Example

```yml
wooden_bat:
  type: item
  material: wooden_sword
  display name: <red>Wooden Bat
  flags:
    ilore:
      # Element, displayed below the title
      description: A humble, solid bat.
      # List of elements, displayed in order
      abilities:
      - Head-splitting swings
      - Dependable, and solid as a rock
      # A key in the 'ilore_colors' script
      rarity: legendary

# /ex give <item[wooden_bat].proc[ilore]>
```

## Scripts

### Data
- `ilore_colors`

### Procedure
- `ilore`

## License

MIT © 2021 Kyle Prince
