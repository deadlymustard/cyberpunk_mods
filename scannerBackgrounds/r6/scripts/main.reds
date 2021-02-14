@addMethod(NPCPuppet)
private func GenerateCharacterBackground() -> String {
  let characterRecord: ref<Character_Record>;
  characterRecord = TweakDBInterface.GetCharacterRecord(this.GetRecordID());
  let name = LocKeyToString(characterRecord.DisplayName());

  let entityIDHash: Int32 = Cast(EntityID.GetHash(this.GetEntityID()));
  Log(IntToString(entityIDHash));

  let seed = RandRange(entityIDHash, 0, 9999999999);
  Log(IntToString(seed));

  let headerString = "Brought to you by InfoComp©\n\n";
  let backgroundString = "Early Life:\n" + GenerateUpbringingEvents(seed) + "\n\n" + GenerateChildhoodEvents(seed) + "\n\n"
    + "Significant Events:\n" + GenerateAdultEvents(seed);

  Log(headerString + backgroundString);
  Log("Called!");

  return headerString + backgroundString;
}

public func GenerateLifestyle(seed: Int32) -> String {
  let jobSeed = seed + 91841;
  let jobVal: Int32 = RandRange(jobSeed, 0, 8);
  if jobVal == 0 { return "Corporate"; };
  if jobVal == 1 { return "Nomad"; };
  if jobVal == 2 { return "Fixer"; };
  if jobVal == 3 { return "Gangster"; };
  if jobVal == 4 { return "Joytoy"; };
  if jobVal == 5 || jobVal == 6 { return "Wageslave"; };
  if jobVal >= 7 { return "Homeless"; } ;
}

public func GenerateUpbringingEvents(seed: Int32) -> String {
  let upbringingSeed = seed + 86166;
  let hasGenericUpbringing: Bool = RandTrueFalse(upbringingSeed);

  let motherSeed = seed + 73358;
  let fatherSeed = seed + 11363;
  let hasFatherEvent: Bool = RandTrueFalse(fatherSeed);
  let hasMotherEvent: Bool = RandTrueFalse(motherSeed);

  let parentEvents: String;
  if Equals(hasGenericUpbringing, true) || Equals(hasFatherEvent, false) && Equals(hasMotherEvent, false) {
    parentEvents += GenerateGenericUpbringingEvent(upbringingSeed);
  } else {
    if Equals(hasFatherEvent, true) {
      parentEvents += GenerateParentEvent(fatherSeed, "Father");
    }
    if Equals(hasMotherEvent, true) {
       parentEvents += GenerateParentEvent(motherSeed, "Mother");
    };
  }
  return parentEvents;
}

public func GenerateParentEvent(seed: Int32, parent: String) -> String {
  let parentVal: Int32 = RandRange(seed, 0, 4);
  Log("ParentVal: " + IntToString(parentVal));

  if parentVal == 0 { return parent + " died in warfare. "; }
  if parentVal == 1 { return parent + " died in an accident. "; }
  if parentVal == 2 { return parent + " was murdered. "; }
  if parentVal == 3 { return parent + " has amnesia and doesn't remember them. "; }
  if parentVal >= 4 { return parent + " is in hiding. "; }
}

public func GenerateGenericUpbringingEvent(seed: Int32) -> String {
  let upbringingVal: Int32 = RandRange(seed, 0, 10);
  Log("UpbringingVal: " + IntToString(upbringingVal));

  if upbringingVal == 0 { return "Never knew their parents."; }
  if upbringingVal == 1 { return "Left with relatives for safekeeping. "; }
  if upbringingVal == 2 { return "Grew up on the street and never knew their parents. "; }
  if upbringingVal == 3 { return "Parents gave them up for adoption. "; }
  if upbringingVal == 4 { return "Parent sold them for money. "; }
  if upbringingVal == 5 { return "Parent overdosed on chems. "; }
  if upbringingVal >= 6 { return "Parents died in a car crash. "; }
  if upbringingVal >= 7 { return "Raised by their grandparents."; }
  if upbringingVal >= 8 { return "Grew up with a loving mother and father. "; }
  if upbringingVal >= 9 { return "Adopted into a loving home."; }
}

public func GenerateChildhoodEvents(seed: Int32) -> String {
  let childhoodEvents: String;

  let childhoodValOne: Int32 = RandRange(seed + 65964, 0, 8);
  Log("childhoodValOne: " + IntToString(childhoodValOne));
  if childhoodValOne == 0 { childhoodEvents += "Spent early life on street with no adult supervision. "; }
	if childhoodValOne == 1 { childhoodEvents +=  "Lived in a safe Corpo Suburbia. "; }
	if childhoodValOne == 2 { childhoodEvents +=  "Lived in a nomad pack moving from city to city. "; }
	if childhoodValOne == 3 { childhoodEvents +=  "Lived in a decaying, once upscale neighborhood. "; }
	if childhoodValOne == 4 { childhoodEvents +=  "Lived in a defended Corpo Zone in the Night City. "; }
	if childhoodValOne == 5 { childhoodEvents +=  "Lived in the heart of the Combat Zone. "; }
	if childhoodValOne == 6 { childhoodEvents +=  "Lived in a small village or town far from the city. "; }
	if childhoodValOne >= 7 { childhoodEvents +=  "Lived in a corporate controlled farm or research facility. "; }

  let majorEventVal: Int32;
  let eventVal: Int32;
  let eventsCount: Int32 = RandRange(seed + 21620, 1, 4);

  let possibleEvents: array<String>;
  ArrayPush(possibleEvents, "Joined a gang at an early age. ");
  ArrayPush(possibleEvents, "Joined a gang at an early age. ");
  ArrayPush(possibleEvents, "Ran away from home. ");
  ArrayPush(possibleEvents, "Was kidnapped by Scavvers. ");
  ArrayPush(possibleEvents, "Started using chems at ten years old. ");
  ArrayPush(possibleEvents, "Was bullied relentlessly. ");
  ArrayPush(possibleEvents, "Stole a car at thirteen years old. ");
  ArrayPush(possibleEvents, "Started selling chems for a local gang. ");
  ArrayPush(possibleEvents, "Joined a band. ");
  ArrayPush(possibleEvents, "Was an average athlete on a sports team. ");
  ArrayPush(possibleEvents, "Spent most of their time on the net. ");
  ArrayPush(possibleEvents, "Began tinkering with electronics. ");
  ArrayPush(possibleEvents, "Was radicalized by extremists on the net. ");
  ArrayPush(possibleEvents, "Developed an interest in guns. ");
  ArrayPush(possibleEvents, "Developed an interest in swords. ");
  ArrayPush(possibleEvents, "Developed an interest in cybernetics. ");
  ArrayPush(possibleEvents, "Joined an anti-corpo Net forum. ");
  ArrayPush(possibleEvents, "Hacked into a small corpo database. ");
  ArrayPush(possibleEvents, "Hacked into a large corpo database. ");

  let i = 0;
  while i < eventsCount {
    majorEventVal = RandRange(seed + i, 0, ArraySize(possibleEvents) - 1);
    Log("majorEventVal: " + IntToString(majorEventVal));
    childhoodEvents += possibleEvents[i];
    ArrayErase(possibleEvents, i);
    i += 1;
  }


  let childhoodValThree: Int32 = RandRange(seed + 14322, 0, 7);
  Log("childhoodValThree: " + IntToString(childhoodValThree));
  if childhoodValThree == 0 { childhoodEvents +=  "Had no friends in high school. "; }
  if childhoodValThree == 1 { childhoodEvents +=  "Had a large group of friends in high school. "; }
  if childhoodValThree == 2 { childhoodEvents +=  "Was a social outcast in school. "; }
  if childhoodValThree == 3 { childhoodEvents +=  "Dropped out of school after middle school. "; }
  if childhoodValThree == 4 { childhoodEvents +=  "Flunked out of high school. "; }
  if childhoodValThree == 5 { childhoodEvents +=  "Was homeschooled by a Corpo subscription service. "; }
  if childhoodValThree == 6 { childhoodEvents +=  "Managed to get into an exclusive private school. "; }
  if childhoodValThree >= 7 { childhoodEvents +=  "Did not attend any schooling. "; }

  return childhoodEvents;
}

public func GenerateAdultEvents(seed: Int32) -> String {
  let adultEvents: String;
  let firstJobVal = RandRange(seed + 81435, 0, 14);

  if firstJobVal == 0 { adultEvents += "Started doing jobs for a local fixer. "; }
  if firstJobVal == 1 { adultEvents += "Started working as a wageslave for a bodega. "; }
  if firstJobVal == 2 { adultEvents += "Started working as a department store wageslave. "; }
  if firstJobVal == 3 { adultEvents += "Got a job as a bouncer at a nightclub. "; }
  if firstJobVal == 4 { adultEvents += "Began begging for money in the street. "; }
  if firstJobVal == 5 { adultEvents += "Started working as a gas station wageslave. "; }
  if firstJobVal == 6 { adultEvents += "Started robbing apartments for cash. "; }
  if firstJobVal == 7 { adultEvents += "Started working as a Joytoy on Jig Jig Street. "; }
  if firstJobVal == 8 { adultEvents += "Started working as a high-end Joytoy for Corpo Executives. "; }
  if firstJobVal == 9 { adultEvents += "Started working as Security for  " + GetRandomCorpo(seed) + ". ";}
  if firstJobVal == 10 { adultEvents += "Started working as a receptionist for  " + GetRandomCorpo(seed) + ". ";}
  if firstJobVal == 11 { adultEvents += "Started working as a desk jockey for  " + GetRandomCorpo(seed) + ". ";}
  if firstJobVal == 12 { adultEvents += "Started working as a wageslave for " + GetRandomCorpo(seed) + ". ";}
  if firstJobVal == 13 { adultEvents += "Got a position working as a corporate manager for " + GetRandomCorpo(seed) + ". ";}
  if firstJobVal == 14 { adultEvents += "Got a position working as a corporate executive for " + GetRandomCorpo(seed) + ". ";}

  let possibleEvents: array<String>;
  let majorEventVal: Int32;
  ArrayPush(possibleEvents, "Lost $" + RandRange(seed + 58299, 100, 30000) + " Eurodollars gambling. ");
  ArrayPush(possibleEvents, "Installed a new cybernetic augmentation. ");
  ArrayPush(possibleEvents, "Moonlighted as a radio jockey. ");
  ArrayPush(possibleEvents, "Was in a car accident. ");
  ArrayPush(possibleEvents, "Became a chemhead. ");
  ArrayPush(possibleEvents, "Was imprisoned for " + RandRange(seed + 61830, 1, 15) + " years. ");
  ArrayPush(possibleEvents, "Stole some high-tech equipment from " + GetRandomCorpo(seed + 83943));
  ArrayPush(possibleEvents, "Was involved in a robbery at a bodega. ");
  ArrayPush(possibleEvents, "Joined a new band. ");
  ArrayPush(possibleEvents, "Completed a job for a fixer and received a $" + RandRange(seed + 37703, 1000, 25000) + " payout.");
  ArrayPush(possibleEvents, "Began running chems for a local gang. ");
  ArrayPush(possibleEvents, "Won a scratch-off. ");
  ArrayPush(possibleEvents, "Bought a car. ");
  ArrayPush(possibleEvents, "Moved into a new apartment. ");
  ArrayPush(possibleEvents, "Bought a firearm. ");
  ArrayPush(possibleEvents, "Bought a sword. ");
  ArrayPush(possibleEvents, "Was involved in a riot. ");
  ArrayPush(possibleEvents, "Killed an unlucky choom. ");
  ArrayPush(possibleEvents, "Lost their job. ");

  let eventsCount: Int32 = RandRange(seed + 64597, 1, 6);
  let i = 0;
  while i < eventsCount {
    majorEventVal = RandRange(seed + i, 0, ArraySize(possibleEvents) - 1);
    Log("majorEventVal: " + IntToString(majorEventVal));
    adultEvents += possibleEvents[i];
    ArrayErase(possibleEvents, i);
    i += 1;
  }

  return adultEvents;
}

public func GetRandomCorpo(seed: Int32) -> String {
  let corpos: array<String>;
  ArrayPush(corpos, "Network News 54");
  ArrayPush(corpos, "Nippon Network");
  ArrayPush(corpos, "Diverse Media Systems");
  ArrayPush(corpos, "World News Service");
  ArrayPush(corpos, "Akaromi BioCorp");
  ArrayPush(corpos, "ConAg");
  ArrayPush(corpos, "Network News 54");
  ArrayPush(corpos, "Petrochem");
  ArrayPush(corpos, "SovOil");
  ArrayPush(corpos, "Arasaka");
  ArrayPush(corpos, "EBM");
  ArrayPush(corpos, "IEC");
  ArrayPush(corpos, "Kang Tao");
  ArrayPush(corpos, "Militech");
  ArrayPush(corpos, "Mitsubishi-Sugo");
  ArrayPush(corpos, "SegAtari");
  ArrayPush(corpos, "Tsunami Defense Systems");
  ArrayPush(corpos, "Akari Heavy Industries");
  ArrayPush(corpos, "Euro Business Machines");
  ArrayPush(corpos, "IEC");
  ArrayPush(corpos, "Microtech");
  ArrayPush(corpos, "Zetatech");
  ArrayPush(corpos, "Adrek Robotics");
  ArrayPush(corpos, "Akagi Systems Incorporated");
  ArrayPush(corpos, "Bakumatsu Chipmasters");
  ArrayPush(corpos, "Biotechnica");
  ArrayPush(corpos, "Cyphire Cyberware");
  ArrayPush(corpos, "Dakai Soundsystems");
  ArrayPush(corpos, "Dynalar Technologies");
  ArrayPush(corpos, "Kenjiri Technology");
  ArrayPush(corpos, "Kiroshi Opticals");
  ArrayPush(corpos, "Trauma Team International");
  ArrayPush(corpos, "Merrill, Asukaga, & Finch");

  let corpoVal = RandRange(seed + 41948, 0, ArraySize(corpos)-1);

  return corpos[corpoVal];
}

public func RandRange(seed: Int32, min: Int32, max: Int32) -> Int32 {
  // Add (max + 1) to account for truncation of floats.
  let val: Int32 = Cast(RandNoiseF(seed, Cast(min), Cast(max + 1)));
  Log("RandRangeVal: " + IntToString(val));
  return val;
}


public func RandTrueFalseWeighted(seed: Int32, opt weight: Int32) -> Bool {
  let val: Int32 = Cast(RandNoiseF(seed, 0.0, 100.0)) + weight;
  Log("RandVal: " + IntToString(val));

  if val > 50 {
    return true;
  } else {
    return false;
  }
}

public func RandTrueFalse(seed: Int32) -> Bool {
  return RandTrueFalseWeighted(seed, 0);
}