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
    fn apply_command(cathod_tube: &CathodTube, command: &Command) -> CathodTube {
        match command {
            Command::Add(step) => {
                let mut tube = cathod_tube.clone();
                for _ in 0..2 {
                    let cycle = tube.cycle + 1;
                    let new_signal = tube.signal_strength
                        + get_signal_strength(cycle, cathod_tube.value).unwrap_or(0);

                    tube = CathodTube {
                        value: cathod_tube.value,
                        signal_strength: new_signal,
                        cycle,
                    };
                }
                CathodTube {
                    value: tube.value + step,
                    signal_strength: tube.signal_strength,
                    cycle: tube.cycle,
                }
            }
            Command::Noop => {
                let cycle = cathod_tube.cycle + 1;
                let new_signal = cathod_tube.signal_strength
                    + get_signal_strength(cycle, cathod_tube.value).unwrap_or(0);

                CathodTube {
                    value: cathod_tube.value,
                    signal_strength: new_signal,
                    cycle,
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

    let apply = |tube: CathodTube, command: &Command| -> CathodTube {
        CathodTube::apply_command(&tube, command)
    };

    let res = commands
        .iter()
        .fold::<CathodTube, fn(CathodTube, &Command) -> CathodTube>(CathodTube::init(), apply);
    println!("{:?}", res);
}
