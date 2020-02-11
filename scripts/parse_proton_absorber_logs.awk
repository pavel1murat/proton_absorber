#------------------------------------------------------------------------------
#  awk -f murat/scripts/parse_log.awk g4study_Au197foil.log
#------------------------------------------------------------------------------
BEGIN{
    start = 0;
    vol   = -1
}

{ 
#    if (n == 1) print $0; 
    n = 0;
}
/PrintModule Run\/Subrun\/Event/ {
    event = $6
    vol   = -1
#    print "event = ",event
}

/ mu2e::StepPointMCs_g4run_tracker_MuonCaptureProtons2020/ {
#    print $0;
    start = 1
}

/StepPointMCCollection has/ {
    if (start == 1) start = 10;
}

{
    if ((start == 10) && ($1 == "ind")) start  = 11
    if (start == 11) {
	if ($1 != "ind") {
	    if (NF == 11) {
		if ($1 != "Friendly") {
#------------------------------------------------------------------------------
# handle data
#------------------------------------------------------------------------------
#		    print "start = ",start, "NF = ", NF ," : ", $0

		    if (vol == -1) {
			vol  = $3;
			x    = $6
			y    = $7
			z0   = $8
			p0   = $9
			edep = $4
		    }
		    else {
			if (vol == $3) {
			    edep = edep + $4
			}
			else {
			    printf "%5i %5i %10.3f %10.3f %10.3f %10.3f %10.5f\n", event, vol, x,y, z0, p0, edep
			    # update 
			    vol  = $3;
			    x    = $6
			    y    = $7
			    z0   = $8
			    p0   = $9
			    edep = $4
			}
		    }
		}
		else {
		    if (vol > 0) {
			printf "%5i %5i %10.3f %10.3f %10.3f %10.3f %10.5f\n", event, vol, x,y, z0, p0, edep
		    }
		    start = 0
		    e     = 0
		    vol   = -1;
		}
	    }
	}
    }
}
/mu2e::SimParticleart::Ptrmu2e::MCTrajectorystd::map_g4run__MuonCaptureProtons2020/ {
#    print $0
    printf "%5i %5i %10.3f %10.3f %10.3f %10.3f %10.5f\n", event, vol, x,y, z0, p0, edep
    start = 0

#    if ((pdg == "11,") && (estart > 35)) {
#	print 11,  estart, eend, estart-eend
#    }
}

END {
}
