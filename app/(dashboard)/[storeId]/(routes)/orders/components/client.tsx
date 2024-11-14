"use client";

import { Separator } from "@radix-ui/react-separator";

import { Heading } from "@/components/ui/heading";
import { OrderColumn, columns } from "./columns";
import { DataTable } from "@/components/ui/data-table";

interface OrderClientProps {
  data: OrderColumn[];
}

export const OrderClient: React.FC<OrderClientProps> = ({ data }) => {
  return (
    <>
      <Heading
        title={`Orders (${data.length})`}
        description="Manage Orders for your store"
      />
      <DataTable searchKey="products" columns={columns} data={data} />
      <Heading title="API" description="API calls for Orders" />
      <Separator />
    </>
  );
};
