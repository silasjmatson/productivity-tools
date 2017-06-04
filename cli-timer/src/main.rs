#[macro_use]
extern crate clap;
extern crate ctrlc;

use std::io::{self, Write};
use std::{thread, time};
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;

fn main() {
    clap_app!(cli_timer =>
        (version: "0.1.0")
        (author: "Silas J. Matson <silas@infinite.red>")
        (about: "Simple Stopwatch CLI")
        (@arg format: -f ... "Specify Format")
    ).get_matches();
    
    let running = Arc::new(AtomicBool::new(true));
    let r = running.clone();
    ctrlc::set_handler(move || {
        r.store(false, Ordering::SeqCst);
    }).expect("Error setting Ctrl-C Handler");

    let start = time::Instant::now();
    let sleep_duration = time::Duration::from_secs(1);

    while running.load(Ordering::SeqCst) {
        thread::sleep(sleep_duration);

        let time_now = time::Instant::now();
        let duration = (time_now - start).as_secs();
        
        let hours = duration / 3600;
        let remainder = duration % 3600;
        let minutes = remainder / 60;
        let seconds = remainder % 60;

        print!("\rTimer:  {:02}:{:02}:{:02} ", hours, minutes, seconds);
        io::stdout().flush().unwrap();
    }
}