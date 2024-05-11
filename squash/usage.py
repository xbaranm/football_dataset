def train(args):
  
    # Setup run name & folder
    if (args.name == ""):
        now = datetime.now()
        name = now.strftime("%Y%m%d-%H%M%S")
    else:
        name = args.name


    with auto_mount_sqfs(args.data) as sqsh:

        # Replace the value with mounted path
        args.data = sqsh.mount_path

        trainer = Trainer(args, name)
        # Loggers & samplers
        trainer.setup([
            ConsoleLogger(interval=50),
            ResultSampler(trainer, interval=50, sinks=[
                    ImageFileSink(os.path.join(trainer.outFolder, "images"), name)
                ]),
            CheckpointMaker(trainer, interval=5000)
        ])
        trainer.train()