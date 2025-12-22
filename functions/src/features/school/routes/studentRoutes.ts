import {Router} from "express";

// eslint-disable-next-line new-cap
const router = Router();

router.get("/", (req, res) => {
  res.send("Hello from Student Routes within School!");
});

export default router;
