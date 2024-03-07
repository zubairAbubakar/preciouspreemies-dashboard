import { Button } from "@/components/ui/button";
import { UserButton } from "@clerk/nextjs";

const SetupPage = () => {
  return (
    <div className="p-4">
      <UserButton afterSignOutUrl="/" />
      <Button variant={"secondary"}>Testing</Button>
      <Button variant={"destructive"}>Testing</Button>
      <Button variant={"outline"}>Testing</Button>
    </div>
  );
};

export default SetupPage;
