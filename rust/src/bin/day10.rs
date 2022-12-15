use anyhow::Result;

#[derive(Debug)]
enum Command {
    Noop,
    Add(isize),
}

#[derive(Debug, Clone)]
struct CathodTube {
    value: isize,
    signal_strength: isize,
    cycle: isize,
}

impl CathodTube {
    fn init() -> CathodTube {
        CathodTube {
            value: 1,
            signal_strength: 0,
            cycle: 0,
        }
    }
    fn apply_command(
        cathod_tube: &CathodTube,
        command: &Command,
        sprite: &mut Vec<char>,
    ) -> CathodTube {
        let mut update_sprite = |x: isize, cycle: isize| {
            let shift = cycle % 40;
            let draw_pixel = x.abs_diff(shift) <= 1;
            sprite.push(match draw_pixel {
                true => '#',
                false => '.',
            });
        };
        match command {
            Command::Add(step) => {
                let mut tube = cathod_tube.clone();
                for _ in 0..2 {
                    update_sprite(tube.value, tube.cycle);

                    tube.cycle += 1;
                    tube.signal_strength +=
                        get_signal_strength(tube.cycle, cathod_tube.value).unwrap_or(0);
                }
                tube.value += step;
                tube
            }
            Command::Noop => {
                update_sprite(cathod_tube.value, cathod_tube.cycle);

                CathodTube {
                    value: cathod_tube.value,
                    signal_strength: cathod_tube.signal_strength
                        + get_signal_strength(cathod_tube.cycle + 1, cathod_tube.value)
                            .unwrap_or(0),
                    cycle: cathod_tube.cycle + 1,
                }
            }
        }
    }
}

fn get_signal_strength(cycle: isize, value: isize) -> Option<isize> {
    if cycle != 20 && cycle != 60 && cycle != 100 && cycle != 140 && cycle != 180 && cycle != 220 {
        return None;
    }
    Some(cycle * value)
}

fn parse_file_in_strings() -> Result<Vec<String>> {
    let list = std::fs::read_to_string("./data/day10.prod")
        .unwrap()
        .lines()
        .map(|l| l.to_string())
        .collect();
    Ok(list)
}

fn parse_command(command: &str) -> Command {
    match command {
        "noop" => Command::Noop,
        add_string => {
            let (_, add_value_str) = add_string.split_at(5);
            Command::Add(add_value_str.parse::<isize>().unwrap())
        }
    }
}
fn main() {
    let parsed = parse_file_in_strings().unwrap();

    let commands = parsed
        .iter()
        .map(|c| parse_command(c))
        .collect::<Vec<Command>>();

    let mut sprite: Vec<char> = vec![];

    let res = commands.iter().fold(CathodTube::init(), |tube, command| {
        CathodTube::apply_command(&tube, command, &mut sprite)
    });

    println!("{:?}", res);
    let sprite_foratted = sprite.chunks(40).into_iter().collect::<Vec<&[char]>>();
    for row in sprite_foratted {
        let mut string = String::from("");
        for char in row {
            string.push(*char);
        }
        println!("{:?}", string);
    }
}
